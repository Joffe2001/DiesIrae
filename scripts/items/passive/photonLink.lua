local mod = DiesIraeMod
local game = Game()
local PhotonLink = {}

mod.CollectibleType.COLLECTIBLE_PHOTON_LINK = Isaac.GetItemIdByName("Photon Link")

local LASER_OFFSET = LaserOffset.LASER_TECH1_OFFSET
local DAMAGE_PER_TICK = 1 
local LASER_COLOR = Color(0.5, 0.8, 1, 1, 0, 0, 0)

function PhotonLink:OnTearUpdate(_, tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_PHOTON_LINK) then return end

    local data = tear:GetData()

    if not data.PhotonLaser or not data.PhotonLaser:Exists() then
        local direction = (tear.Position - player.Position):Normalized()
        local laser = player:FireTechLaser(
            player.Position,
            LASER_OFFSET, 
            direction,
            false,
            false,
            player,
            DAMAGE_PER_TICK
        )
        laser.Color = LASER_COLOR
        data.PhotonLaser = laser
    end

    if data.PhotonLaser and data.PhotonLaser:Exists() then
        local laser = data.PhotonLaser
        local delta = tear.Position - player.Position
        laser.Position = player.Position
        laser.Velocity = delta
        laser.Angle = delta:GetAngleDegrees()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, PhotonLink.OnTearUpdate)

function PhotonLink:OnTearRemove(_, tear)
    local data = tear:GetData()
    if data.PhotonLaser and data.PhotonLaser:Exists() then
        data.PhotonLaser:Remove()
        data.PhotonLaser = nil
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, PhotonLink.OnTearRemove, EntityType.ENTITY_TEAR)
