local mod = DiesIraeMod

local EyeSacrifice = {}
local game = Game()

-- Helper function to modify the tear position to the right eye
local function adjustTearPosition(tear, player)
    -- Calculate the offset for Isaac's right eye based on the player's facing direction
    local eyeOffset = Vector(0, -8) -- Default offset for the right eye (this can be adjusted for accuracy)

    if player:IsFacingLeft() then
        eyeOffset = Vector(-8, -8) -- Adjust if the player is facing left
    end

    -- Set the tear position to the right eye
    tear.Position = player.Position + eyeOffset
end

-- Handle the firing of tears, adjusting position based on Eye Sacrifice
function EyeSacrifice:onFireTear(tear, player)
    -- Ensure that the player object is not nil
    if not player then return end

    -- Check if the player has the Eye Sacrifice item
    if player:HasCollectible(mod.Items.EyeSacrifice) then
        -- Adjust the tear position to the player's right eye
        adjustTearPosition(tear, player)
    end
end

-- Check for entering Devil Deal room and handle other effects
function EyeSacrifice:onUpdate()
    local player = Isaac.GetPlayer(0) -- Get the first player (use 0 for single-player)
    if not player then return end

    if not player:HasCollectible(mod.Items.EyeSacrifice) then
        return
    end

    if player:HasCollectible(Isaac.GetItemIdByName("Stapler")) then
        player.Damage = player.Damage - 1
    end

    if game:GetRoom():GetType() == RoomType.ROOM_DEVIL and not enteredDevilRoom then
        enteredDevilRoom = true
        player:AddHearts(0)
        Isaac.DebugString("Eye Sacrifice: Free Devil Deal granted!")
    elseif game:GetRoom():GetType() ~= RoomType.ROOM_DEVIL then
        enteredDevilRoom = false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, EyeSacrifice.onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, EyeSacrifice.onFireTear)
