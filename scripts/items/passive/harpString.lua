local mod = DiesIraeMod
local game = Game()

local HarpString = {}

function HarpString:TrackHarpString(player)
    if player:GetPlayerType() == mod.Players.David then
        local harpStringCount = player:GetCollectibleNum(mod.Items.HarpString)
        player:GetData().harpStringCount = harpStringCount
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, HarpString.TrackHarpString)

function HarpString:SpawnExtraPedestals()
    local player = Isaac.GetPlayer(0)

    if player:GetPlayerType() == mod.Players.David then
        local harpStringCount = player:GetData().harpStringCount or 0 
        local treasureRoom = game:GetRoom()

        if treasureRoom:GetType() == RoomType.ROOM_TREASURE then
            local additionalPedestals = harpStringCount - 1 

            for i = 1, additionalPedestals do
                local roomWidth = treasureRoom:GetWidth()
                local roomHeight = treasureRoom:GetHeight()
                local centerPos = treasureRoom:GetCenterPos()
                
                local randomPos = centerPos + Vector(math.random(-roomWidth / 2, roomWidth / 2), math.random(-roomHeight / 2, roomHeight / 2))

                local gridCollision = treasureRoom:GetGridCollisionAtPos(randomPos)
                if gridCollision == GridCollisionClass.COLLISION_NONE then
                    local pedestal = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, randomPos, Vector(0, 0), nil)
                    pedestal:GetData().isHarpString = true
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, HarpString.SpawnExtraPedestals)
