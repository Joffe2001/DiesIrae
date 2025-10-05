local mod = DiesIraeMod

local RemoveCurseOnVoid = {}

-- Callback that runs when a new room is loaded
function RemoveCurseOnVoid:OnNewFloor()
    local player = Isaac.GetPlayer(0) -- Get the first player
    local level = Game():GetLevel() -- Get the current level (floor)

    -- Check if the current floor is The Void
    if level:GetStage() == StageType.STAGETYPE_VOID then
        -- Remove Curse of the Lost if on The Void floor
        level:RemoveCurse(LevelCurse.CURSE_OF_THE_LOST)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, RemoveCurseOnVoid.OnNewFloor)
