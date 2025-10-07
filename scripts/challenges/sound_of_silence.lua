local mod = DiesIraeMod
local SoundOfSilence = {}
local blockPedestalReward = false

function SoundOfSilence:TearGFXApply(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end
    if game.Challenge ~= mod.Challenges.SoundOfSilence then return end
    tear:GetSprite():ReplaceSpritesheet(0, "gfx/proj/music_tears.png", true)
end

function SoundOfSilence:PostPickupInit(pickup)
    if game.Challenge ~= SoundOfSilence.ID then return end

    local roomType = Game():GetRoom():GetType()
    if blockPedestalReward
    and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
    and (roomType == RoomType.ROOM_BOSS or roomType == RoomType.ROOM_TREASURE) then
        pickup:Remove()
        blockPedestalReward = false
    end
end

local function spawnRandomTrinket()
    local room = Game():GetRoom()
    local pos = room:FindFreePickupSpawnPosition(Vector(room:GetCenterPos().X, room:GetCenterPos().Y), 0, true)
    local trinketID = math.random(1, TrinketType.NUM_TRINKETS - 1)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinketID, pos, Vector.Zero, nil)
end

function SoundOfSilence:OnNewRoom()
    if game.Challenge ~= SoundOfSilence.ID then return end

    local room = Game():GetRoom()
    local roomType = room:GetType()
    if roomType == RoomType.ROOM_TREASURE then
        blockPedestalReward = true
        spawnRandomTrinket()
    end
end

function SoundOfSilence:PostBossKill()
    if game.Challenge ~= SoundOfSilence.ID then return end

    local room = Game():GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSS then return end

    blockPedestalReward = true
    spawnRandomTrinket()
end


mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, SoundOfSilence.PostPickupInit)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SoundOfSilence.OnNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, entity)
if entity:IsBoss() then
        SoundOfSilence:PostBossKill()
    end
end)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, SoundOfSilence.TearGFXApply)

