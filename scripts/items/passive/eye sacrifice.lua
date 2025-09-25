local EyeSacrifice = {}
EyeSacrifice.COLLECTIBLE_ID = Isaac.GetItemIdByName("Eye Sacrifice")
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
    if player:HasCollectible(EyeSacrifice.COLLECTIBLE_ID) then
        -- Adjust the tear position to the player's right eye
        adjustTearPosition(tear, player)
    end
end

-- Check for entering Devil Deal room and handle other effects
function EyeSacrifice:onUpdate()
    local player = Isaac.GetPlayer(0) -- Get the first player (use 0 for single-player)
    if not player then return end  -- Ensure player is valid

    if not player:HasCollectible(EyeSacrifice.COLLECTIBLE_ID) then
        return
    end

    -- Inherit Stapler functionality (except damage)
    if player:HasCollectible(Isaac.GetItemIdByName("Stapler")) then
        -- Inherit the stapler behavior but remove damage bonus
        player.Damage = player.Damage - 1 -- Remove the stapler damage bonus (adjust as needed)
    end

    -- Check if the player enters a Devil Deal room
    if game:GetRoom():GetType() == RoomType.ROOM_DEVIL and not enteredDevilRoom then
        enteredDevilRoom = true
        -- Grant a free devil deal (you can implement logic to prevent health cost)
        player:AddHearts(0)  -- Adding 0 hearts to avoid health cost (you can adjust this for a better solution)
        -- Optional: Display a message or add a special effect
        Isaac.DebugString("Eye Sacrifice: Free Devil Deal granted!")
    elseif game:GetRoom():GetType() ~= RoomType.ROOM_DEVIL then
        enteredDevilRoom = false  -- Reset when leaving the room
    end
end

-- Initialize the item
function EyeSacrifice:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, EyeSacrifice.onUpdate)
    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, EyeSacrifice.onFireTear)

    if EID then
        EID:addCollectible(
            EyeSacrifice.COLLECTIBLE_ID,
            "Shoot only from Isaac's right eye.#Upon entering the Devil Deal room, receive a free Devil Deal.",
            "Eye Sacrifice",
            "en_us"
        )
    end
end

return EyeSacrifice
