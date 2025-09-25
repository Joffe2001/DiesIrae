local BossCompass = {}
BossCompass.COLLECTIBLE_ID = Enums.Items.BossCompass

--THIS SEEMS TO BE UNUSED, SO I LEFT IT LARGELY UNCHANGED

function BossCompass:OnLevelLoaded()
    local player = Isaac.GetPlayer(0)  -- Get the first player
    if not player:HasCollectible(BossCompass.COLLECTIBLE_ID) then return end
    
    -- Set the boss room spawn position near the starting room for next floor
    local currentLevel = GameRef:GetLevel()
    local roomType = RoomType.ROOM_BOSS
    local startRoom = currentLevel:GetRoomByIdx(0)  -- The first room of the floor (usually the starting room)

    -- Find a room that can be the boss room
    local room = nil
    for i = 1, currentLevel:GetRoomCount() do
        local potentialRoom = currentLevel:GetRoomByIdx(i, Dimension.CURRENT)
        if potentialRoom:GetType() == roomType then
            room = potentialRoom
            break
        end
    end

    if room then
        -- Move the boss room closer to the starting room of the next floor
        room:SetPosition(startRoom.Position + Vector(0, 100))  -- Just an example, adjust based on need
        print("Boss Compass: Boss room will spawn near starting room next floor.")
    else
        print("Boss Compass: No boss room found!")
    end
end

---------------------------------------------------------
-- CALLBACK REGISTER
---------------------------------------------------------
function BossCompass:Init(mod)
    -- Register for when the level is loaded (when you move to a new floor)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
        BossCompass:OnLevelLoaded()
    end)

    -- EID description for the Boss Compass
    if EID then
        EID:addCollectible(BossCompass.COLLECTIBLE_ID,
            "Spawn the boss room near the starting room on the next floor.",
            "Boss Compass",
            "en_us"
        )
    end
end

return BossCompass
