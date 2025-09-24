local RemoveCurseOnVoid = {}

-- Callback that runs when a new room is loaded
function RemoveCurseOnVoid:OnNewFloor()
    local player = Isaac.GetPlayer(0) -- Get the first player
    local level = Game():GetLevel() -- Get the current level (floor)

    -- Check if the current floor is The Void
    if level:GetStage() == StageType.STAGETYPE_VOID then
        -- Remove Curse of the Lost if on The Void floor
        level:RemoveCurse(LevelCurse.CURSE_OF_THE_LOST)
        print("Curse of the Lost removed on The Void floor.")
    end
end

-- Initialize the mod and callbacks
function RemoveCurseOnVoid:Init(mod)
end

return RemoveCurseOnVoid
