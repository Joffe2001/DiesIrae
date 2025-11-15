local mod = DiesIraeMod
local game = Game()


--- Definitions
---

---@type PlayerType
local elijah = mod.Players.Elijah

---@type PickupVariant
local elijahWill = mod.Pickups.ElijahsWill

---@type CollectibleType
local elijahStartingItem = mod.Items.PersonalBeggar

local customBeggar = {
    [SlotVariant.BEGGAR] = mod.ElijahNPCs.BeggarElijah,
    [mod.NPCS.TechBeggar] = mod.ElijahNPCs.TechBeggarElijah,
    [SlotVariant.BOMB_BUM] = mod.ElijahNPCs.BombBeggarElijah,
    [SlotVariant.KEY_MASTER] = mod.ElijahNPCs.KeyBeggarElijah,
    [SlotVariant.ROTTEN_BEGGAR] = mod.ElijahNPCs.RottenBeggarElijah,
    [SlotVariant.BATTERY_BUM] = mod.ElijahNPCs.BatteryBeggarElijah,
}

local spawnElijahWill = {
    [PickupVariant.PICKUP_KEY] = elijahWill,
    [PickupVariant.PICKUP_BOMB] = elijahWill,
    [PickupVariant.PICKUP_COIN] = elijahWill,
}

local elijahFuncs = {}


--- Callbacks
---

---Add starting item to Elijah.
---@param player EntityPlayer
function elijahFuncs:PlayerInit(player)
    if player:GetPlayerType() ~= elijah then return end

    if (player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= elijahStartingItem) then
        player:SetPocketActiveItem(elijahStartingItem)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, elijahFuncs.PlayerInit)


---Delete Elijah's Will if not playing Elijah.
---@param pickup EntityPickup
function elijahFuncs:OnPickupInit(pickup)
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end
    pickup:Remove()
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, elijahFuncs.OnPickupInit, elijahWill)


---Display a header when picking up a Elijah's Will
---@param pickup EntityPickup
---@param collider Entity
---@return boolean
function elijahFuncs:OnPickupCollision(pickup, collider)
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= elijah then return false end

    local data = player:GetData()
    data.ElijahBoosts = data.ElijahBoosts or {}

    local stat = math.random(6)
    local boostMessage = ""

    if stat == 1 then
        data.ElijahBoosts.Damage = (data.ElijahBoosts.Damage or 0) + 0.1
        boostMessage = "Damage Up!"
    elseif stat == 2 then
        data.ElijahBoosts.Tears = (data.ElijahBoosts.Tears or 0) + 0.1
        boostMessage = "Tears Up!"
    elseif stat == 3 then
        data.ElijahBoosts.Speed = (data.ElijahBoosts.Speed or 0) + 0.1
        boostMessage = "Speed Up!"
    elseif stat == 4 then
        data.ElijahBoosts.Range = (data.ElijahBoosts.Range or 0) + 0.1
        boostMessage = "Range Up!"
    elseif stat == 5 then
        data.ElijahBoosts.Luck = (data.ElijahBoosts.Luck or 0) + 0.1
        boostMessage = "Luck Up!"
    elseif stat == 6 then
        data.ElijahBoosts.ShotSpeed = (data.ElijahBoosts.ShotSpeed or 0) + 0.1
        boostMessage = "Shot Speed Up!"
    end

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()

    Game():GetHUD():ShowItemText("Elijah's Will", boostMessage)
    SFXManager():Play(SoundEffect.SOUND_POWERUP1)
    pickup:Remove()
    return true
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, elijahFuncs.OnPickupCollision, elijahWill)


---Stats up by comparing with the number of Elijah's Will acquired.
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function elijahFuncs:EvaluateCache(player, cacheFlag)
    if player:GetPlayerType() ~= elijah then return end

    local data = player:GetData()
    if not data.ElijahBoosts then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + (data.ElijahBoosts.Damage or 0)
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local tearsUp = data.ElijahBoosts.Tears or 0
        local currentTears = 30 / (player.MaxFireDelay + 1)
        local newTears = currentTears + tearsUp
        player.MaxFireDelay = math.max(1, (30 / newTears) - 1)
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + (data.ElijahBoosts.Speed or 0)
    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange + (data.ElijahBoosts.Range or 0)
    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + (data.ElijahBoosts.Luck or 0)
    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + (data.ElijahBoosts.ShotSpeed or 0)
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, elijahFuncs.EvaluateCache)


---Replace base pickup with the Elijah's Will.
---@param type EntityType
---@param variant integer
---@param subtype integer
---@param seed integer
---@return table | nil
function elijahFuncs:PreEntitySpawnWill(type, variant, subtype, _, _, _, seed)
    if type ~= EntityType.ENTITY_PICKUP then return end
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    local will = spawnElijahWill[variant]
    if will then
        return { type, will, subtype, seed }
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, elijahFuncs.PreEntitySpawnWill)


---Replace beggars with the custom beggars.
---@param type EntityType
---@param variant integer
---@param subtype integer
---@param seed integer
---@return table | nil
function elijahFuncs:PreEntitySpawn(type, variant, subtype, _, _, _, seed)
    if type ~= EntityType.ENTITY_SLOT then return end
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    local npc = customBeggar[variant]
    if npc then
        return { type, npc, subtype, seed }
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, elijahFuncs.PreEntitySpawn)
