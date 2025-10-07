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

------------------------------------------------------
---                David Unlock                    ---
------------------------------------------------------
local function ResetUnlocks(player)
    player:GetData().goldenKeyPickedUp = false
    player:GetData().goldenBombPickedUp = false
    player:GetData().goldenCoinPickedUp = false
end

local function CheckForDavidUnlock(player)
    if player:GetData().goldenKeyPickedUp and player:GetData().goldenBombPickedUp and player:GetData().goldenCoinPickedUp then
        TryUnlock(mod.Achievements.David)
    end
end

local function OnPickupCollision(pickup, player)
    if not player:ToPlayer() then return end

    if pickup.Variant == PickupVariant.PICKUP_KEY and pickup.SubType == KeySubType.KEY_GOLDEN then
        player:GetData().goldenKeyPickedUp = true
    elseif pickup.Variant == PickupVariant.PICKUP_BOMB and pickup.SubType == BombSubType.BOMB_GOLDEN then
        player:GetData().goldenBombPickedUp = true
    elseif pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType == CoinSubType.COIN_GOLDEN then
        player:GetData().goldenCoinPickedUp = true
    end
    CheckForDavidUnlock(player)
end

local function OnNewRun(reenter)
    if reenter then return end 

    for _, player in ipairs(PlayerManager.GetPlayers()) do
        ResetUnlocks(player)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewRun)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, OnPickupCollision)
