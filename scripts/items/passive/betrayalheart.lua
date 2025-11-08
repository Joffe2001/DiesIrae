local mod = DiesIraeMod
local game = Game()

local function GetPData(player)
    local d = player:GetData()
    d._betrayal = d._betrayal or {}
    return d._betrayal
end

local function SyncBrokenHearts(player)
    local pdata = GetPData(player)
    local itemCount = player:GetCollectibleNum(mod.Items.BetrayalHeart)
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

function mod:PostPlayerUpdate_BetrayalHeart(player)
    if player:GetCollectibleNum(mod.Items.BetrayalHeart) > 0 then
        SyncBrokenHearts(player)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.PostPlayerUpdate_BetrayalHeart)

function mod:EvaluateCache_BetrayalHeart(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(mod.Items.BetrayalHeart)
        if itemCount > 0 then
            local brokenHearts = player:GetBrokenHearts()
            player.Damage = player.Damage + brokenHearts * 1
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache_BetrayalHeart)

function mod:PostPlayerInit_BetrayalHeart(player)
    local pdata = GetPData(player)
    pdata.givenBroken = 0
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.PostPlayerInit_BetrayalHeart)

function mod:PostNewLevel_BetrayalHeart()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetCollectibleNum(mod.Items.BetrayalHeart) > 0 then
            SyncBrokenHearts(player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.PostNewLevel_BetrayalHeart)
