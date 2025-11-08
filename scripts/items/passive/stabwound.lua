local mod = DiesIraeMod

local StabWound = {}
local game = Game()

function StabWound:onCache(player, cacheFlag)
    if not player:HasCollectible(mod.Items.StabWound) then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 1.0

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local currentTears = 30 / (player.MaxFireDelay + 1)
        local newTears = currentTears + 0.5
        player.MaxFireDelay = math.max(1, (30 / newTears) - 1)
    end
end

function StabWound:onUpdate()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()

        if player:HasCollectible(mod.Items.StabWound) then
            if not data.StabWoundCacheApplied then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY)
                player:EvaluateItems()
                data.StabWoundCacheApplied = true
            end
        else
            if data.StabWoundCacheApplied then
                data.StabWoundCacheApplied = nil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY)
                player:EvaluateItems()
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, StabWound.onCache)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, StabWound.onUpdate)
