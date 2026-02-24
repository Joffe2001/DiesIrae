local mod = DiesIraeMod
local Psychosocial = {}
local game = Game()

mod.CollectibleType.COLLECTIBLE_PSYCHOSOCIAL = Isaac.GetItemIdByName("Psychosocial")

local lastEnemyCount = 0

function Psychosocial:onCache(player, cacheFlag)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_PSYCHOSOCIAL) then return end
    
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local enemyCount = Isaac.CountEnemies()
        if enemyCount > 0 then
            player.MaxFireDelay = math.max(player.MaxFireDelay - (enemyCount * 0.5), 1)
        end
    end
end

function Psychosocial:onUpdate()
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_PSYCHOSOCIAL) then return end

    local enemyCount = Isaac.CountEnemies()
    if enemyCount ~= lastEnemyCount then
        lastEnemyCount = enemyCount
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Psychosocial.onCache)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, Psychosocial.onUpdate)

