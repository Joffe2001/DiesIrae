local mod = DiesIraeMod
local game = Game()
local ELIJAH = mod.Players.Elijah

function mod:ElijahActive(player)
    if player:GetPlayerType() ~= ELIJAH then return end

    if (player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= mod.Items.PersonalBeggar) then
        player:SetPocketActiveItem(mod.Items.PersonalBeggar)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.ElijahActive)

function mod:Elijah_ReplacePickups(pickup)
    local anyElijah = false
    for i = 0, game:GetNumPlayers() - 1 do
        if Isaac.GetPlayer(i):GetPlayerType() == ELIJAH then
            anyElijah = true
            break
        end
    end
    if not anyElijah then return end

    if pickup.Variant == PickupVariant.PICKUP_COIN
    or pickup.Variant == PickupVariant.PICKUP_KEY
    or pickup.Variant == PickupVariant.PICKUP_BOMB then

        local pos = pickup.Position
        pickup:Remove()

        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            mod.Pickups.ElijahsWill,
            0,
            pos,
            Vector.Zero,
            nil
        )
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.Elijah_ReplacePickups)

function mod:ElijahsWill_OnPickupInit(pickup)
    local anyElijah = false
    for i = 0, game:GetNumPlayers() - 1 do
        if Isaac.GetPlayer(i):GetPlayerType() == ELIJAH then
            anyElijah = true
            break
        end
    end

    if not anyElijah then
        pickup:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.ElijahsWill_OnPickupInit, mod.Pickups.ElijahsWill)


function mod:ElijahsWill_OnPickupCollision(pickup, collider)
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= ELIJAH then return false end

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
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.ElijahsWill_OnPickupCollision, mod.Pickups.ElijahsWill)


function mod:ElijahsWill_OnCache(player, cacheFlag)
    if player:GetPlayerType() ~= ELIJAH then return end

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
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ElijahsWill_OnCache)

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, type, variant, subtype, pos, vel, spawner, seed)
    if type == EntityType.ENTITY_SLOT then
        local anyElijah = false

        for i = 0, Game():GetNumPlayers() - 1 do
            local p = Isaac.GetPlayer(i)
            if p and p:GetPlayerType() == ELIJAH then
                anyElijah = true
                break
            end
        end

        if anyElijah then
            if variant == SlotVariant.BEGGAR then
                return {type, mod.ElijahNPCs.BeggarElijah, subtype, seed}
            end
            if variant == mod.NPCS.TechBeggar then
                return {type, mod.ElijahNPCs.TechBeggarElijah, subtype, seed}
            end
            if variant == SlotVariant.BOMB_BUM then
                return {type, mod.ElijahNPCs.BombBeggarElijah, subtype, seed}
            end
            if variant == SlotVariant.KEY_MASTER then
                return {type, mod.ElijahNPCs.KeyBeggarElijah, subtype, seed}
            end
            if variant == SlotVariant.ROTTEN_BEGGAR then
                return {type, mod.ElijahNPCs.RottenBeggarElijah, subtype, seed}
            end
            if variant == SlotVariant.BATTERY_BUM then
                return {type, mod.ElijahNPCs.BatteryBeggarElijah, subtype, seed}
            end
        end
    end
end)