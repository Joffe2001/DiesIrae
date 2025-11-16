local mod = DiesIraeMod
local game = Game()
local TGS = {}
TGS.COLLECTIBLE_ID = mod.Items.TGS

local lastEnemyCount = 0
local tearEffects = {
    {color = Color(0.2, 1, 0.2, 1, 0, 0, 0), status = "poison"},
    {color = Color(0.4, 0.6, 1, 1, 0, 0, 0), status = "freeze"},
    {color = Color(1, 0.4, 1, 1, 0, 0, 0), status = "charm"},
}

function TGS:onUpdate(player)
    if not player or not player:HasCollectible(self.COLLECTIBLE_ID) then return end

    local enemyCount = Isaac.CountEnemies()
    if enemyCount ~= (player:GetData().TGS_LastEnemyCount or 0) then
        player:GetData().TGS_LastEnemyCount = enemyCount
        player:AddCacheFlags(CacheFlag.CACHE_HEALTH)
        player:EvaluateItems()
    end
end

function TGS:onCache(player, cacheFlag)
    if not player:HasCollectible(self.COLLECTIBLE_ID) then return end

    if cacheFlag == CacheFlag.CACHE_HEALTH then
        player:AddMaxHearts(2)
        player:AddHearts(2)
    end
end

function TGS:onFireTear(_, tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(self.COLLECTIBLE_ID) then return end

    local enemyCount = Isaac.CountEnemies()
    local chance = math.min(enemyCount * 0.04, 0.4)

    if math.random() < chance then
        local effectData = tearEffects[math.random(#tearEffects)]
        local data = tear:GetData()
        data.TGSEffect = effectData
        tear.Color = effectData.color
    end
end

function TGS:onPreTearCollision(_, tear, collider)
    local data = tear:GetData()
    if not data.TGSEffect then return end

    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end

    if collider:IsVulnerableEnemy() and not collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
        local status = data.TGSEffect.status
        if status == "poison" then
            collider:AddPoison(EntityRef(player), 90, player.Damage)
        elseif status == "freeze" then
            collider:AddFreeze(EntityRef(player), 90)
        elseif status == "charm" then
            collider:AddCharmed(EntityRef(player), 90)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player) TGS:onUpdate(player) end)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag) TGS:onCache(player, flag) end)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear) TGS:onFireTear(_, tear) end)
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider) TGS:onPreTearCollision(_, tear, collider) end)

return TGS
