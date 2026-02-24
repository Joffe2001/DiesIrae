---@class ModReference
local mod = DiesIraeMod
local corona = {}

mod.CollectibleType.COLLECTIBLE_CORONA = Isaac.GetItemIdByName("Corona")

local BURST_CHANCE = 0.2
local BURNING_CREEP_DAMAGE = 2.0
local CREEP_LIFETIME = 120

function corona:OnCoronaEvaluateCache(player, cacheFlag)
    if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_CORONA) then
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = math.max(1, player.MaxFireDelay - 1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, corona.OnCoronaEvaluateCache)

function corona:OnCoronaCreepUpdate(entity)
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
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, corona.OnCoronaCreepUpdate)

function corona:OnCoronaTearCollision(_, tear, collider)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_CORONA) then return end

    if math.random() < BURST_CHANCE then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, tear.Position, Vector
        .Zero, player):ToEffect()
        if creep == nil then return end
        creep.Timeout = CREEP_LIFETIME
        creep.Color = Color(1.4, 0.7, 0.2, 1, 0.3, 0, 0)
        creep:GetData().IsCoronaCreep = true
        creep.SpriteScale = Vector(1.2, 1.2)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, corona.OnCoronaTearCollision)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    if tear:IsDead() then
        local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
        if player and player:HasCollectible(mod.CollectibleType.COLLECTIBLE_CORONA) and math.random() < BURST_CHANCE then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, tear.Position,
                Vector.Zero, player):ToEffect()
            if creep == nil then return end
            creep.Timeout = CREEP_LIFETIME
            creep.Color = Color(1.4, 0.7, 0.2, 1, 0.3, 0, 0)
            creep:GetData().IsCoronaCreep = true
            creep.SpriteScale = Vector(1.2, 1.2)
        end
    end
end)
