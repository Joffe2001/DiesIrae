local mod = DiesIraeMod

local HereToStay = {}
local game = Game()


local MAX_TICKS = 6
local CREEP_INTERVAL = 20
local BASE_RADIUS = 20
local RADIUS_STEP = 10
local CREEP_DAMAGE = 2.5
local CREEP_LIFETIME = 90 

function HereToStay:PostPlayerUpdate(player)
    if not player:HasCollectible(mod.Items.HereToStay) then return end

    local data = player:GetData()
    data.TickCount = data.TickCount or 0
    data.LastPos = data.LastPos or player.Position
    data.Timer = data.Timer or 0

    if player.Position:DistanceSquared(data.LastPos) < 1 then
        data.Timer = data.Timer + 1

        if data.Timer % CREEP_INTERVAL == 0 and data.TickCount < MAX_TICKS then
            data.TickCount = data.TickCount + 1

            local radius = math.min(BASE_RADIUS + RADIUS_STEP * (data.TickCount - 1), 60)

            local creep = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                EffectVariant.PLAYER_CREEP_RED,
                0,
                player.Position,
                Vector.Zero,
                player
            ):ToEffect()

            creep:SetTimeout(CREEP_LIFETIME)
            creep.SpriteScale = Vector(radius / 20, radius / 20)
            creep.CollisionDamage = CREEP_DAMAGE
            creep.Color = Color(0, 1, 0, 1, 0, 0, 0)
        end
    else
        data.Timer = 0
        data.TickCount = 0
    end

    data.LastPos = player.Position
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, HereToStay.PostPlayerUpdate)

if EID then
    EID:assignTransformation("collectible", mod.Items.HereToStay, "Isaac's sinful Playlist")
end
