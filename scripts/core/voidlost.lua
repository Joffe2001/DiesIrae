local mod = DiesIraeMod

local RemoveCurseOnVoid = {}

function RemoveCurseOnVoid:OnNewFloor()
    local player = Isaac.GetPlayer(0) 
    local level = Game():GetLevel() 

    if level:GetStage() == StageType.STAGETYPE_VOID then
        level:RemoveCurse(LevelCurse.CURSE_OF_THE_LOST)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, RemoveCurseOnVoid.OnNewFloor)
