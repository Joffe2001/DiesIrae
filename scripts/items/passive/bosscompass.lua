local mod = DiesIraeMod

local BossCompass = {}
local game = Game()
local rng = RNG()

---------------------------------------------------------
-- BOSS COMPASS EFFECT (SPAWN BOSS ROOM NEXT FLOOR)
---------------------------------------------------------
function BossCompass:OnLevelLoaded()
    local player = Isaac.GetPlayer(0)  -- Get the first player
    if not player:HasCollectible(mod.Items.BossCompass) then return end
    
    -- Set the boss room spawn position near the starting room for next floor
    local currentLevel = game:GetLevel()
    local roomType = RoomType.ROOM_BOSS
    local startRoom = currentLevel:GetRoomByIdx(0)  -- The first room of the floor (usually the starting room)

    -- Find a room that can be the boss room
    local room = nil
    for i = 1, currentLevel:GetRoomsCount() do
        local potentialRoom = currentLevel:GetRoom(i)
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
-- Register for when the level is loaded (when you move to a new floor)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    BossCompass:OnLevelLoaded()
end)
