---@class ModReference
local mod = DiesIraeMod
local game = Game()
local betrayalHeart = {}

mod.CollectibleType.COLLECTIBLE_BETRAYAL_HEART = Isaac.GetItemIdByName("Betrayal Heart")

local function GetPData(player)
    local d = player:GetData()
    d._betrayal = d._betrayal or {}
    return d._betrayal
end

local function SyncBrokenHearts(player)
    local pdata = GetPData(player)
    local itemCount = player:GetCollectibleNum(mod.CollectibleType.COLLECTIBLE_BETRAYAL_HEART)
    local prevGiven = pdata.givenBroken or 0

    if itemCount > 0 then
        local delta = itemCount - prevGiven
        if delta ~= 0 then
            player:AddBrokenHearts(delta)
            pdata.givenBroken = itemCount
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    elseif prevGiven > 0 then
        pdata.givenBroken = 0
    end
end

function betrayalHeart:PostPlayerUpdate_BetrayalHeart(player)
    if player:GetCollectibleNum(mod.CollectibleType.COLLECTIBLE_BETRAYAL_HEART) > 0 then
        SyncBrokenHearts(player)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, betrayalHeart.PostPlayerUpdate_BetrayalHeart)

function betrayalHeart:EvaluateCache_BetrayalHeart(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(mod.CollectibleType.COLLECTIBLE_BETRAYAL_HEART)
        if itemCount > 0 then
            local brokenHearts = player:GetBrokenHearts()
            player.Damage = player.Damage + brokenHearts * 1
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, betrayalHeart.EvaluateCache_BetrayalHeart)

function betrayalHeart:PostPlayerInit_BetrayalHeart(player)
    local pdata = GetPData(player)
    pdata.givenBroken = 0
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, betrayalHeart.PostPlayerInit_BetrayalHeart)

function betrayalHeart:PostNewLevel_BetrayalHeart()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetCollectibleNum(mod.CollectibleType.COLLECTIBLE_BETRAYAL_HEART) > 0 then
            SyncBrokenHearts(player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, betrayalHeart.PostNewLevel_BetrayalHeart)
