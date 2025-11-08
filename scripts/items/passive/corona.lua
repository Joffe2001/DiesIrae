local mod = DiesIraeMod
local game = Game()

local BURST_CHANCE = 0.2
local BURNING_CREEP_DAMAGE = 2.0
local CREEP_LIFETIME = 120

function mod:OnCoronaEvaluateCache(player, cacheFlag)
    if player:HasCollectible(mod.Items.Corona) then
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = math.max(1, player.MaxFireDelay - 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnCoronaEvaluateCache)

function mod:OnCoronaCreepUpdate(entity)
    if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.PLAYER_CREEP_RED then
        local data = entity:GetData()
        if data.IsCoronaCreep then
            for _, e in ipairs(Isaac.GetRoomEntities()) do
                if e:IsActiveEnemy(false) and not e:IsDead() then
                    if e.Position:Distance(entity.Position) < 40 then
                        e:TakeDamage(BURNING_CREEP_DAMAGE / 30, 0, EntityRef(entity), 0)
                        e:AddBurn(EntityRef(entity), 60, BURNING_CREEP_DAMAGE / 2)
                    end
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnCoronaCreepUpdate)

function mod:OnCoronaTearCollision(_, tear, collider)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(mod.Items.Corona) then return end

    if math.random() < BURST_CHANCE then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, tear.Position, Vector.Zero, player):ToEffect()
        creep.Timeout = CREEP_LIFETIME
        creep.Color = Color(1.4, 0.7, 0.2, 1, 0.3, 0, 0) 
        creep:GetData().IsCoronaCreep = true
        creep.SpriteScale = Vector(1.2, 1.2)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.OnCoronaTearCollision)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    if tear:IsDead() then
        local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
        if player and player:HasCollectible(mod.Items.Corona) and math.random() < BURST_CHANCE then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, tear.Position, Vector.Zero, player):ToEffect()
            creep.Timeout = CREEP_LIFETIME
            creep.Color = Color(1.4, 0.7, 0.2, 1, 0.3, 0, 0)
            creep:GetData().IsCoronaCreep = true
            creep.SpriteScale = Vector(1.2, 1.2)
        end
    end
end)
