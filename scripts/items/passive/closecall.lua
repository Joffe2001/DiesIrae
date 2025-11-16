local mod = DiesIraeMod
local game = Game()

-- Random stat boosts (these can be expanded based on your preferences)
local statBoosts = {
    {type = "damage", value = 0.1},
    {type = "speed", value = 0.1},
    {type = "tears", value = 0.2},
    {type = "range", value = 0.3}
}

function mod:CloseCall_OnProjectileNear(player)
    local radius = 100 -- Distance to check for nearby projectiles
    local projectiles = Isaac.FindInRadius(player.Position, radius, EntityPartition.PROJECTILE)

    for _, entity in ipairs(projectiles) do
        if entity:ToProjectile() then
            local projectile = entity:ToProjectile()

            -- Check if the projectile is colliding with Isaac
            if not projectile:CollidesWithPlayer(player) then
                -- Randomly choose a stat boost
                local boost = statBoosts[math.random(#statBoosts)]

                -- Apply the random stat boost
                if boost.type == "damage" then
                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                    player:EvaluateItems()
                elseif boost.type == "speed" then
                    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                    player:EvaluateItems()
                elseif boost.type == "tears" then
                    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                    player:EvaluateItems()
                elseif boost.type == "range" then
                    player:AddCacheFlags(CacheFlag.CACHE_RANGE)
                    player:EvaluateItems()
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.CloseCall_OnProjectileNear)