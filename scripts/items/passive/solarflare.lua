local mod = DiesIraeMod

local SolarFlare = {}

function SolarFlare:onTearInit(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if player and player:HasCollectible(mod.Items.SolarFlare) then
        local data = tear:GetData()
        data.SolarFlare = {
            timer = 15,    
            dashed = false, 
        }
        tear.FallingSpeed = tear.FallingSpeed + 2
        tear.FallingAcceleration = tear.FallingAcceleration + 0.5
        tear.Scale = 0.9
        tear.CollisionDamage = tear.CollisionDamage * 1.2
        tear.Velocity = tear.Velocity * 0.5 
    end
end

function SolarFlare:onTearUpdate(tear)
    local data = tear:GetData().SolarFlare
    if not data then return end

    if not data.dashed then
        data.timer = data.timer - 1
        if data.timer <= 0 then
            local target = SolarFlare:getNearestEnemy(tear.Position)
            if target then
                local dir = (target.Position - tear.Position):Resized(20)
                tear.Velocity = dir
                data.dashed = true
            end
        end
    else
        if tear.FrameCount % 2 == 0 then
            local flame = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                EffectVariant.RED_CANDLE_FLAME,
                0,
                tear.Position,
                Vector.Zero,
                tear
            ):ToEffect()
            flame.Timeout = 30 
        end
    end
end


function SolarFlare:onTearHit(tear, collider, low)
    if tear:GetData().SolarFlare and collider:ToNPC() then
        local enemy = collider:ToNPC()
        if enemy:IsVulnerableEnemy() then
            enemy:AddBurn(EntityRef(tear), 120, tear.CollisionDamage * 0.5) 
        end
    end
end

function SolarFlare:getNearestEnemy(pos)
    local nearest, nearestDist
    for _, e in ipairs(Isaac.GetRoomEntities()) do
        if e:IsVulnerableEnemy() and e.HitPoints > 0 then
            local dist = pos:Distance(e.Position)
            if not nearest or dist < nearestDist then
                nearest, nearestDist = e, dist
            end
        end
    end
    return nearest
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, SolarFlare.onTearInit)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, SolarFlare.onTearUpdate)
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, SolarFlare.onTearHit)

if EID then
    EID:addCollectible(
        mod.Items.SolarFlare,
        "Tears start slow#After ~0.2s they dash toward the nearest enemy#Leave a short fire trail while dashing#Burn enemies on hit",
        "Solar Flare",
        "en_us"
    )
end
