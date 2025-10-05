local mod = DiesIraeMod

local MonstersUnderTheBed = {}
local game = Game()

local lastEnemyCount = 0

function MonstersUnderTheBed:onCache(player, cacheFlag)
    if not player:HasCollectible(mod.Items.MonstersUnderTheBed) then return end
    
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local enemyCount = Isaac.CountEnemies()
        if enemyCount > 0 then
            player.MaxFireDelay = math.max(player.MaxFireDelay - (enemyCount * 0.5), 1)
        end
    end
end

function MonstersUnderTheBed:onUpdate()
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.Items.MonstersUnderTheBed) then return end

    local enemyCount = Isaac.CountEnemies()
    if enemyCount ~= lastEnemyCount then
        lastEnemyCount = enemyCount
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, MonstersUnderTheBed.onCache)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, MonstersUnderTheBed.onUpdate)

if EID then
    EID:addCollectible(
        mod.Items.MonstersUnderTheBed,
        "↑ Fire rate increases for each enemy in the room#Bonus decreases as enemies are defeated#Resets when room is cleared",
        "Monsters Under The Bed",
        "en_us"
    )
end
