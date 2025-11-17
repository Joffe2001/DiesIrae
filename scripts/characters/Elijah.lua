local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class Utils
local utils = include("scripts.core.utils")

local save = mod.SaveManager


--- MAGIC NUMBERS
---

ELIJAHSWILL_HEADER = "Elijah's Will"

WILL_SPEED_UP = 0.1
WILL_TEARS_UP = 0.15
WILL_DAMAGE_UP = 0.2
WILL_RANGE_UP = 0.25
WILL_SHOT_SPEED_UP = 0.1
WILL_LUCK_UP = 0.5

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
    [PickupVariant.PICKUP_MOMSCHEST] = mod.ElijahNPCs.MomBoxBeggarElijah,
}

local spawnElijahWill = {
    [PickupVariant.PICKUP_KEY] = elijahWill,
    [PickupVariant.PICKUP_BOMB] = elijahWill,
    [PickupVariant.PICKUP_COIN] = elijahWill,
}

local ItemRoomBeggar = {
    [RoomType.ROOM_TREASURE] = mod.ElijahNPCs.TreasureBeggarElijah
}

---@alias statUpFun fun(data: table): string
---@type statUpFun[]
local statsUpFuncs = {
    function(data)
        data.WillSpeed = (data.WillSpeed or 0) + WILL_SPEED_UP
        print(data.WillSpeed)
        return "Speed Up!"
    end,
    function(data)
        data.WillFireDelay = (data.WillFireDelay or 0) + WILL_TEARS_UP
        return "Tears Up!"
    end,
    function(data)
        data.WillDamage = (data.WillDamage or 0) + WILL_DAMAGE_UP
        return "Damage Up!"
    end,
    function(data)
        data.WillRange = (data.WillRange or 0) + WILL_RANGE_UP
        return "Range Up!"
    end,
    function(data)
        data.WillShotSpeed = (data.WillShotSpeed or 0) + WILL_SHOT_SPEED_UP
        return "Shot Speed Up!"
    end,
    function(data)
        data.WillLuck = (data.WillLuck or 0) + WILL_LUCK_UP
        return "Luck Up!"
    end,
}

---@alias cacheFun fun(player: EntityPlayer)
---@type table<CacheFlag, cacheFun>
local cacheFuncs = {
    [CacheFlag.CACHE_SPEED] = function(player)
        player.MoveSpeed = player.MoveSpeed + (save.GetRunSave(player).WillSpeed or 0)
    end,
    [CacheFlag.CACHE_FIREDELAY] = function(player)
        player.MaxFireDelay = utils.TearsUp(player.MaxFireDelay, save.GetRunSave(player).WillFireDelay or 0)
    end,
    [CacheFlag.CACHE_DAMAGE] = function(player)
        player.Damage = player.Damage + (save.GetRunSave(player).WillDamage or 0)
    end,
    [CacheFlag.CACHE_RANGE] = function(player)
        player.TearRange = player.TearRange + 40 * (save.GetRunSave(player).WillRange or 0)
    end,
    [CacheFlag.CACHE_SHOTSPEED] = function(player)
        player.ShotSpeed = player.ShotSpeed + (save.GetRunSave(player).WillShotSpeed or 0)
    end,
    [CacheFlag.CACHE_LUCK] = function(player)
        player.Luck = player.Luck + (save.GetRunSave(player).WillLuck or 0)
    end,
}

local elijahFuncs = {}


--- Callbacks
---

---Add starting item to Elijah.
---@param player EntityPlayer
function elijahFuncs:PlayerInit(player)
    if player:GetPlayerType() ~= elijah then return end

    player:AddCollectible(elijahStartingItem)
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, elijahFuncs.PlayerInit)


---Delete Elijah's Will if not playing Elijah.
---@param pickup EntityPickup
function elijahFuncs:OnPickupInit(pickup)
    if PlayerManager.AnyoneIsPlayerType(elijah) then return end
    pickup:Remove()
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, elijahFuncs.OnPickupInit, elijahWill)


---Display a header when picking up a Elijah's Will
---@param pickup EntityPickup
---@param collider Entity
---@return boolean | nil
function elijahFuncs:OnPickupCollision(pickup, collider)
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= elijah then return false end

    local data = save.GetRunSave(player)

    local stat = math.random(#statsUpFuncs)
    StatUp = statsUpFuncs[stat]
    local secondaryString = StatUp(data)

    player:AddCacheFlags(CacheFlag.CACHE_ALL, true)

    game:GetHUD():ShowItemText(ELIJAHSWILL_HEADER, secondaryString)
    sfx:Play(SoundEffect.SOUND_POWERUP1)
    pickup:Remove()
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, elijahFuncs.OnPickupCollision, elijahWill)


---Stats up by comparing with the number of Elijah's Will acquired.
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function elijahFuncs:EvaluateCache(player, cacheFlag)
    if player:GetPlayerType() ~= elijah then return end

    local CacheFunc = cacheFuncs[cacheFlag]
    if (not CacheFunc) then return end
    CacheFunc(player)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, elijahFuncs.EvaluateCache)


---Replace base pickup with the Elijah's Will.
---@param type EntityType
---@param variant integer
---@param seed integer
---@return table | nil
function elijahFuncs:PreEntitySpawnWill(type, variant, _, _, _, _, seed)
    if type ~= EntityType.ENTITY_PICKUP then return end
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    local will = spawnElijahWill[variant]
    if will then
        return { type, will, 0, seed }
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


---Replace pedestals by the correct beggar
function elijahFuncs:PostNewRoom()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.Elijah then
        return
    end

    local roomType = game:GetRoom():GetType()
    local beggar = ItemRoomBeggar[roomType]
    if beggar == nil then return end

    for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local ped = entity:ToPickup()
        if not ped then return end

        local pos = ped.Position
        ped:Remove()
        Isaac.Spawn(EntityType.ENTITY_SLOT, beggar, 0, pos, Vector.Zero, nil)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, elijahFuncs.PostNewRoom)