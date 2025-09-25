local HereToStay = {}
HereToStay.COLLECTIBLE_ID = Isaac.GetItemIdByName("Here to Stay")
local game = Game()

-- Constants
local MAX_TICKS = 8              -- how many growth steps
local CREEP_INTERVAL = 30        -- 0.5s between each tick
local BASE_RADIUS = 20
local RADIUS_STEP = 50           -- how much bigger per tick
local CREEP_DAMAGE = 2.5         -- flat creep damage
local CREEP_LIFETIME = 60        -- how long each puddle stays

function HereToStay:PostPlayerUpdate(player)
    if not player:HasCollectible(HereToStay.COLLECTIBLE_ID) then return end

    local data = player:GetData()
    data.TickCount = data.TickCount or 0
    data.LastPos = data.LastPos or player.Position
    data.Timer = data.Timer or 0

    -- If the player is standing still
    if player.Position:DistanceSquared(data.LastPos) < 1 then
        data.Timer = data.Timer + 1

        if data.Timer % CREEP_INTERVAL == 0 and data.TickCount < MAX_TICKS then
            data.TickCount = data.TickCount + 1

            local radius = BASE_RADIUS + RADIUS_STEP * (data.TickCount - 1)

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

            -- ✅ Flat damage, no scaling
            creep.CollisionDamage = CREEP_DAMAGE

            creep.Color = Color(0, 1, 0, 1, 0, 0, 0) -- green puddle
        end
    else
        -- Reset when moving
        data.Timer = 0
        data.TickCount = 0
    end

    -- Update last position
    data.LastPos = player.Position
end

function HereToStay:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, HereToStay.PostPlayerUpdate)

    if EID then
        EID:addCollectible(
            HereToStay.COLLECTIBLE_ID,
            "Standing still spawns creep in growing steps.#Each tick the puddle gets bigger.",
            "Here to Stay",
            "en_us"
        )
    end
end

return HereToStay
