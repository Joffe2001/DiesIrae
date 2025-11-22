local mod = DiesIraeMod

local MomsDress = {}

local mantle = CollectibleType.COLLECTIBLE_HOLY_MANTLE
local mantleGiven = false
local hasSpawnedHearts = false

function MomsDress:CheckPickup(player)
    if player:HasCollectible(mod.Items.MomsDress) and not hasSpawnedHearts then
        hasSpawnedHearts = true

        for i = 1, 2 do
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_HEART,
                HeartSubType.HEART_ROTTEN,
                player.Position,
                Vector(5, 0):Rotated(i * 180),
                nil
            )
        end
    end
end

function MomsDress:OnNewRoom()
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.Items.MomsDress) then return end

    local room = Game():GetRoom()
    if room:IsClear() or (room:GetType() == RoomType.ROOM_BOSS and room:IsAmbushDone()) then
        return
    end

    local rng = RNG()
    rng:SetSeed(Game():GetSeeds():GetStartSeed() + room:GetDecorationSeed(), 35)

    mantleGiven = false

    if rng:RandomFloat() < 0.3 then
        player:AddCollectibleEffect(mantle, true)
        mantleGiven = true
    else
    end
end

function MomsDress:OnTakeDamage(entity)
    if not entity:ToPlayer() or not mantleGiven then return end

    local player = entity:ToPlayer()
    if player and player:HasCollectibleEffect(mantle) then
        mantleGiven = false
        return false
    end
end

function MomsDress:OnRoomReset()
    mantleGiven = false
end

function MomsDress:OnPlayerUpdate(player)
    MomsDress:CheckPickup(player)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, MomsDress.OnNewRoom)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, MomsDress.OnTakeDamage)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, MomsDress.OnRoomReset)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, MomsDress.OnPlayerUpdate)

