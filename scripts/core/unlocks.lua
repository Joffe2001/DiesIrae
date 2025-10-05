local mod = DiesIraeMod

-- Map unlocks to items/trinkets
local UnlocksTable = {
    [mod.Players.David] = {
        [CompletionType.MOMS_HEART] = mod.Achievements.ArmyOfLovers,
        [CompletionType.ISAAC] = mod.Achievements.TheBadTouch,
        [CompletionType.SATAN] = mod.Achievements.LittleLies,
        [CompletionType.LAMB] = mod.Achievements.ParanoidAndroid,
        [CompletionType.MEGA_SATAN] = mod.Achievements.ShBoom,
        [CompletionType.BOSS_RUSH] = mod.Achievements.Universal,
        [CompletionType.HUSH] = mod.Achievements.EverybodysChanging,
        [CompletionType.BEAST] = mod.Achievements.U2,
        [CompletionType.MOTHER] = mod.Achievements.KillerQueen,
        [CompletionType.ULTRA_GREEDIER] = mod.Achievements.RingOfFire,
        [CompletionType.DELIRIUM] = mod.Achievements.HelterSkelter,
        [CompletionType.BLUE_BABY] = mod.Achievements.BabyBlue,
        [CompletionType.ULTRA_GREED] = mod.Achievements.WonderOfYou
    }
}

local function TryUnlock(ach)
    if not Game():AchievementUnlocksDisallowed() then
        Isaac.GetPersistentGameData():TryUnlock(ach)
    end
end

function mod:GiveUnlocks(mark, ptype)
    if not (UnlocksTable[ptype] and UnlocksTable[ptype][mark]) then return end

    TryUnlock(UnlocksTable[ptype][mark])
end

mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_MARK_GET, mod.GiveUnlocks)
