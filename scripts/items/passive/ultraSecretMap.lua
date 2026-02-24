local mod = DiesIraeMod
local UltraSecretMap = {}
local game = Game()
local rng = RNG()

mod.CollectibleType.COLLECTIBLE_ULTRA_SECRET_MAP = Isaac.GetItemIdByName("Ultra Secret Map")

local crackedKeySpawned = false

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

function UltraSecretMap:OnRender()
    local level = game:GetLevel()

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_ULTRA_SECRET_MAP) then
            for j = 0, level:GetRooms().Size - 1 do
                local roomDesc = level:GetRooms():Get(j)
                if roomDesc.Data.Type == RoomType.ROOM_ULTRASECRET then
                    roomDesc.DisplayFlags = roomDesc.DisplayFlags | RoomDescriptor.DISPLAY_ICON
                end
            end
        end
    end
end

function UltraSecretMap:OnNewRoom()
    local room = game:GetRoom()
    local level = game:GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()

    if crackedKeySpawned then return end

    local secretRoomDesc = FindSecretRoom()
    if room:GetType() == RoomType.ROOM_SECRET and secretRoomDesc ~= nil then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_ULTRA_SECRET_MAP) then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, room:FindFreePickupSpawnPosition(player.Position), Vector.Zero, nil)
                crackedKeySpawned = true
                break
            end
        end
    end
end
function UltraSecretMap:OnNewLevel()
    crackedKeySpawned = false
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, UltraSecretMap.OnRender)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, UltraSecretMap.OnNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, UltraSecretMap.OnNewLevel)

