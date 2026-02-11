local mod = DiesIraeMod

local RemoveCurseOnVoid = {}

function RemoveCurseOnVoid:OnCurseEval(curses)
    local level = Game():GetLevel()
    
    if level:GetStage() == LevelStage.STAGE7 then
        if (curses & LevelCurse.CURSE_OF_THE_LOST) > 0 then
            return curses ~ LevelCurse.CURSE_OF_THE_LOST
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, RemoveCurseOnVoid.OnCurseEval)
