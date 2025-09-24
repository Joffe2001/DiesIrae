local RedMap = {}
RedMap.COLLECTIBLE_ID = Isaac.GetItemIdByName("Red Map")

-- Function to teleport Isaac to a random red room (even without keys)
function RedMap:UseItem(_, _, player, _, _)
    local level = Game():GetLevel()
    local roomsCount = level:GetRoomsCount()

    -- Make sure rooms are available and that roomsCount is valid
    if roomsCount == nil or roomsCount <= 0 then
        return false  -- return false if there are no rooms available
    end

    local roomIndex = math.random(1, roomsCount)
    local room = level:GetRoom(roomIndex)

    -- Ensure that the room is valid
    if not room then
        return false  -- return false if room is invalid
    end

    -- Ensure the room is a Red Room or similar special room, even without keys
    while not self:IsSpecialRedRoom(room) do
        roomIndex = math.random(1, roomsCount)
        room = level:GetRoom(roomIndex)
        
        -- Ensure that the new room is valid
        if not room then
            return false  -- return false if room is invalid
        end
    end

    -- Teleport to the red room
    player.Position = room:GetCenterPos()
    player:TeleportToRoom(room)

    return true
end

-- Helper function to check if room is a special red room (Cracked or Red Key rooms)
function RedMap:IsSpecialRedRoom(room)
    -- Check if the room is a red room or one that could be considered 'special' (i.e., Cracked or Red Key rooms)
    return room:IsRedRoom()  -- You can add other conditions here if needed
end

function RedMap:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return RedMap:UseItem(...)
    end, RedMap.COLLECTIBLE_ID)
end

-- EID description
if EID then
    EID:addCollectible(RedMap.COLLECTIBLE_ID, "Teleport to a random Red Room", "Red Map", "en_us")
end

return RedMap