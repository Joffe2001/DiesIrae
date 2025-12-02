local mod = DiesIraeMod
local HereToStay = {}
local game = Game()

local MAX_TICKS = 6
local CREEP_INTERVAL = 20

local BASE_RADIUS = 20
local RADIUS_STEP = 10
local MAX_RADIUS = 60

local BASE_DAMAGE = 2.5
local DAMAGE_STEP = 1.0

local SHRINK_DELAY = 60
local SHRINK_SPEED = 0.02


function HereToStay:PostPlayerUpdate(player)
    if not player:HasCollectible(mod.Items.HereToStay) then return end

    local data = player:GetData()
    data.TickCount = data.TickCount or 0
    data.LastPos = data.LastPos or player.Position
    data.Timer = data.Timer or 0

    data.Creeps = data.Creeps or {}

    local standingStill = player.Position:DistanceSquared(data.LastPos) < 1

    if standingStill then
        data.Timer = data.Timer + 1

        if data.Timer % CREEP_INTERVAL == 0 and data.TickCount < MAX_TICKS then
            data.TickCount = data.TickCount + 1

            local radius = math.min(BASE_RADIUS + RADIUS_STEP * (data.TickCount - 1), MAX_RADIUS)
            local creepDamage = BASE_DAMAGE + DAMAGE_STEP * (data.TickCount - 1)

            local creep = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                EffectVariant.PLAYER_CREEP_GREEN,
                0,
                player.Position + Vector(0, 1),
                Vector.Zero,
                player
            ):ToEffect()

            creep:SetTimeout(-1)

            creep.SpriteScale = Vector(radius / 20, radius / 20)
            creep.TargetPosition = creep.SpriteScale
            creep.CollisionDamage = creepDamage
            creep:SetDamageSource(EntityType.ENTITY_PLAYER)

            table.insert(data.Creeps, {
                entity = creep,
                shrinking = false,
                shrinkDelay = 0
            })
        end

    else

        data.Timer = 0
        data.TickCount = 0

        for _, creepData in ipairs(data.Creeps) do
            if creepData.entity and creepData.entity:Exists() then
                if not creepData.shrinking then
                    creepData.shrinking = true
                    creepData.shrinkDelay = SHRINK_DELAY
                end
            end
        end
    end

    for i = #data.Creeps, 1, -1 do
        local creepData = data.Creeps[i]
        local creep = creepData.entity

        if creep and creep:Exists() then

            if creepData.shrinking then
                if creepData.shrinkDelay > 0 then
                    creepData.shrinkDelay = creepData.shrinkDelay - 1
                else
                    local scale = creep.SpriteScale.X - SHRINK_SPEED

                    if scale <= 0.05 then
                        creep:Remove()
                        table.remove(data.Creeps, i)
                    else
                        creep.SpriteScale = Vector(scale, scale)
                        creep.TargetPosition = creep.SpriteScale
                    end
                end
            end
        else
            table.remove(data.Creeps, i)
        end
    end
    data.LastPos = player.Position
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, HereToStay.PostPlayerUpdate)
