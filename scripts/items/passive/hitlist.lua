local mod = DiesIraeMod
local HitList = {}


local clearedRooms = {}

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.Items.HitList) then return end

    local level = Game():GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()

    if roomDesc and roomDesc.Data and roomDesc.Data.Type == RoomType.ROOM_DEFAULT then
        clearedRooms[roomDesc.SafeGridIndex] = true
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local game = Game()
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.Items.HitList) then return end

    local level = game:GetLevel()
    local currentRoom = game:GetRoom()
    local rooms = level:GetRooms() 

    local totalNormalRooms, clearedCount = 0, 0

    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if desc.Data and desc.Data.Type == RoomType.ROOM_DEFAULT then
            totalNormalRooms = totalNormalRooms + 1
            if clearedRooms[desc.SafeGridIndex] then
                clearedCount = clearedCount + 1
            end
        end
    end

    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = currentRoom:GetDoor(i)
        if door and door.TargetRoomType == RoomType.ROOM_BOSS then
            if clearedCount < totalNormalRooms then
                door:SetLocked(true)
            else
                door:SetLocked(false)
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    clearedRooms = {}
end)

