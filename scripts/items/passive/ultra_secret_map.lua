local UltraSecretMap = {}
UltraSecretMap.COLLECTIBLE_ID = Isaac.GetItemIdByName("Ultra Secret Map")

local game = Game()
local rng = RNG()

-- Track if Cracked Key has already been spawned this floor
local crackedKeySpawned = false

-- Utility to find the current Secret Room (not Super/Ultra)
local function FindSecretRoom()
    local level = game:GetLevel()
    for i = 0, level:GetRooms().Size - 1 do
        local roomDesc = level:GetRooms():Get(i)
        local roomType = roomDesc.Data.Type
        if roomType == RoomType.ROOM_SECRET then
            return roomDesc
        end
    end
    return nil
end

-- Show the ultra secret room on map if player has Secret Map
function UltraSecretMap:OnRender()
    local level = game:GetLevel()

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(UltraSecretMap.COLLECTIBLE_ID) then
            -- Reveal Ultra Secret Room on map
            for j = 0, level:GetRooms().Size - 1 do
                local roomDesc = level:GetRooms():Get(j)
                if roomDesc.Data.Type == RoomType.ROOM_ULTRASECRET then
                    roomDesc.DisplayFlags = roomDesc.DisplayFlags | RoomDescriptor.DISPLAY_ICON
                end
            end
        end
    end
end

-- Drop a cracked key when entering the secret room (only once per floor)
function UltraSecretMap:OnNewRoom()
    local room = game:GetRoom()
    local level = game:GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()

    if crackedKeySpawned then return end

    -- Optional: Use the FindSecretRoom function for some condition
    local secretRoomDesc = FindSecretRoom()
    if room:GetType() == RoomType.ROOM_SECRET and secretRoomDesc ~= nil then
        -- Spawn the Cracked Key only if the player has the item
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(UltraSecretMap.COLLECTIBLE_ID) then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, room:FindFreePickupSpawnPosition(player.Position), Vector.Zero, nil)
                crackedKeySpawned = true
                break
            end
        end
    end
end

-- Reset spawn flag on new floor
function UltraSecretMap:OnNewLevel()
    crackedKeySpawned = false
end

function UltraSecretMap:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_RENDER, UltraSecretMap.OnRender)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, UltraSecretMap.OnNewRoom)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, UltraSecretMap.OnNewLevel)

    if EID then
        EID:addCollectible(
            UltraSecretMap.COLLECTIBLE_ID,
            "Reveals the Ultra Secret Room on the map.#Drops a Cracked Key in the Secret Room.",
            "Ultra Secret Map",
            "en_us"
        )
    end
end

return UltraSecretMap
