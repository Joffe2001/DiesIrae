local mod = DiesIraeMod
local TouristMap = {}
local game = Game()

mod.CollectibleType.COLLECTIBLE_TOURIST_MAP = Isaac.GetItemIdByName("Tourist Map")

local function ForceShop(level)
    local stage = level:GetStage()
    if stage >= LevelStage.STAGE4_1 then
        local roomDesc = level:GetRoomByIdx(GridRooms.ROOM_SHOP_IDX, 0)
        if not roomDesc or roomDesc.Data.Type ~= RoomType.ROOM_SHOP then
            level:InitializeDevilAngelRoom(false)
            level:MakeRedRoomDoor(level:GetStartingRoomIndex(), 0)
            level:SetRoomType(GridRooms.ROOM_SHOP_IDX, RoomType.ROOM_SHOP)
        end
    end
end

function TouristMap:onNewLevel()
    local level = game:GetLevel()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_TOURIST_MAP) then
            ForceShop(level)
            break
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, TouristMap.onNewLevel)

