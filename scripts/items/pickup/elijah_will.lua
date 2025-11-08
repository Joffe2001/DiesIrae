local mod = DiesIraeMod
local game = Game()

local ElijahsWill = {}
local ELIJAH = mod.Players.Elijah


function ElijahsWill:OnPickupInit(pickup)
    local anyElijah = false
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetPlayerType() == ELIJAH then
            anyElijah = true
            break
        end
    end

    if not anyElijah then
        pickup:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ElijahsWill.OnPickupInit, mod.EntityVariant.ElijahsWill)


function ElijahsWill:OnPickupCollision(pickup, collider)
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= ELIJAH then
        return false
    end

    local data = player:GetData()
    data.ElijahBoosts = data.ElijahBoosts or {}

    local stat = math.random(5)
    local boostMessage = ""

    if stat == 1 then
        data.ElijahBoosts.Damage = (data.ElijahBoosts.Damage or 0) + 0.25
        boostMessage = "Damage Up!"
    elseif stat == 2 then
        data.ElijahBoosts.Tears = (data.ElijahBoosts.Tears or 0) + 0.15
        boostMessage = "Tears Up!"
    elseif stat == 3 then
        data.ElijahBoosts.Speed = (data.ElijahBoosts.Speed or 0) + 0.1
        boostMessage = "Speed Up!"
    elseif stat == 4 then
        data.ElijahBoosts.Range = (data.ElijahBoosts.Range or 0) + 1.0
        boostMessage = "Range Up!"
    elseif stat == 5 then
        data.ElijahBoosts.Luck = (data.ElijahBoosts.Luck or 0) + 1
        boostMessage = "Luck Up!"
    end

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()

    Game():GetHUD():ShowItemText("Elijah's Will", boostMessage)
    SFXManager():Play(SoundEffect.SOUND_POWERUP1)

    pickup:Remove()
    return true
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, ElijahsWill.OnPickupCollision, mod.EntityVariant.ElijahsWill)

function ElijahsWill:onCache(player, cacheFlag)
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
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ElijahsWill.onCache)
