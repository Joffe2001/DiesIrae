local mod = DiesIraeMod

local SlingShot = {}

local SPEED = 5.5
local DAMAGE_MULT = 2.0
local BASE_BONUS = 5
local SCALE_MULT = 2.8

local game = Game()
local sfx = SFXManager()

local function dirToVector(dir)
    if dir == Direction.LEFT then return Vector(-1, 0)
    elseif dir == Direction.RIGHT then return Vector(1, 0)
    elseif dir == Direction.UP then return Vector(0, -1)
    elseif dir == Direction.DOWN then return Vector(0, 1)
    else return Vector(1, 0) end
end

function SlingShot:onUse(_, _, player, _, _)
    local dir = dirToVector(player:GetHeadDirection())

    local tear = Isaac.Spawn(
        EntityType.ENTITY_TEAR,
        TearVariant.BLUE,
        0,
        player.Position,
        dir * SPEED,
        player
    ):ToTear()

    if tear then
        tear:GetData().IsSlingShot = true
        tear.CollisionDamage = (player.Damage * DAMAGE_MULT) + BASE_BONUS
        tear.Scale = SCALE_MULT
        tear.FallingSpeed = 0
        tear.FallingAcceleration = 0
        tear.Height = -999
        tear.TearFlags = tear.TearFlags
            | TearFlags.TEAR_PIERCING
            | TearFlags.TEAR_SPECTRAL
            | TearFlags.TEAR_ROCK
        tear.Color = Color(1.8, 0.1, 0.1, 1, 0, 0, 0)
    end

    sfx:Play(SoundEffect.SOUND_MEGA_BLAST_START, 1.0)
    game:ShakeScreen(10)

    return true 
end

function SlingShot:onTearUpdate(tear)
    if not tear:GetData().IsSlingShot then return end
    local room = game:GetRoom()
    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = room:GetDoor(i)
        if door and not door:IsOpen() then
            local doorPos = room:GetDoorSlotPosition(i)
            if tear.Position:Distance(doorPos) < 30 then
                if door.TargetRoomType == RoomType.ROOM_SECRET or door.TargetRoomType == RoomType.ROOM_SUPERSECRET then
                    door:TryOpen(true)
                else
                    door:Open()
                end
            end
        end
    end
    local gridCollision = room:GetGridCollisionAtPos(tear.Position)
    if gridCollision ~= GridCollisionClass.COLLISION_NONE then
        Isaac.Explode(tear.Position, tear.SpawnerEntity, tear.CollisionDamage)
        tear:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, SlingShot.onUse, mod.Items.SlingShot)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, SlingShot.onTearUpdate)
