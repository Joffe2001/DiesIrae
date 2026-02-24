---@class ModReference
local mod = DiesIraeMod
local game = Game()
local challengeMap = {}

mod.CollectibleType.COLLECTIBLE_CHALLENGER_MAP = Isaac.GetItemIdByName("Challenger Map")

function challengeMap:ChallengerMapRender()
    local level = game:GetLevel()

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_CHALLENGER_MAP) then
            local rooms = level:GetRooms()
            for j = 0, rooms.Size - 1 do
                local roomDesc = rooms:Get(j)
                if roomDesc and roomDesc.Data then
                    if roomDesc.Data.Type == RoomType.ROOM_CHALLENGE then
                        roomDesc.DisplayFlags = roomDesc.DisplayFlags | RoomDescriptor.DISPLAY_ICON
                    end
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, challengeMap.ChallengerMapRender)

function challengeMap:ChallengerMapRoomUnlock()
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_CHALLENGER_MAP) then return end
    local room = game:GetRoom()
    local level = game:GetLevel()

    for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = room:GetDoor(slot)
        if door then
            local target = level:GetRoomByIdx(door.TargetRoomIndex)
            if target and target.Data and target.Data.Type == RoomType.ROOM_CHALLENGE then
                local gridIndex = door.GridIndex
                if gridIndex ~= nil then
                    local gridEntity = room:GetGridEntity(gridIndex)
                    if gridEntity then
                        local gridDoor = gridEntity:ToDoor()
                        if gridDoor then
                            gridDoor:TryUnlock(player)
                            gridDoor:SetLocked(false)
                            gridDoor:Open()
                        end
                    end
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, challengeMap.ChallengerMapRoomUnlock)
