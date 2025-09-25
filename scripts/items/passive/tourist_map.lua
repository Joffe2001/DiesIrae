local TouristMap = {}
TouristMap.COLLECTIBLE_ID = Isaac.GetItemIdByName("Tourist Map")

local game = Game()

-- Helper: force shop on current floor
local function ForceShop(level)
    local stage = level:GetStage()
    if stage >= LevelStage.STAGE4_1 then
        local roomDesc = level:GetRoomByIdx(GridRooms.ROOM_SHOP_IDX, 0)
        if not roomDesc or roomDesc.Data.Type ~= RoomType.ROOM_SHOP then
            level:InitializeDevilAngelRoom(false) -- make sure special rooms are seeded
            level:MakeRedRoomDoor(level:GetStartingRoomIndex(), 0) -- open a door for accessibility

            -- Force shop
            level:SetRoomType(GridRooms.ROOM_SHOP_IDX, RoomType.ROOM_SHOP)
        end
    end
end

-- On new level, check if player has item, then inject shop
function TouristMap:onNewLevel()
    local level = game:GetLevel()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(TouristMap.COLLECTIBLE_ID) then
            ForceShop(level)
            break
        end
    end
end

-- Init
function TouristMap:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, TouristMap.onNewLevel)

    if EID then
        EID:addCollectible(
            TouristMap.COLLECTIBLE_ID,
            "Adds a shop to every floor starting from Womb/Corpse (Stage 4 and above)",
            "Tourist Map",
            "en_us"
        )
    end
end

return TouristMap
