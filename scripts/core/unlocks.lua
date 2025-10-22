local mod = DiesIraeMod

------------------------------------------------------
---                Characters items Unlock         ---
------------------------------------------------------
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
        [CompletionType.ULTRA_GREED] = mod.Achievements.WonderOfYou,
        AllHardMarks = mod.Achievements.Muse
    },
    --[mod.Players.TDavid] = {
        --[CompletionType.MOMS_HEART] = mod.Achievements.Mutter,
        --[CompletionType.ISAAC] = mod.Achievements.,
        --[CompletionType.SATAN] = mod.Achievements.LittleLies,
        --[CompletionType.LAMB] = mod.Achievements.ParanoidAndroid,
        --[CompletionType.MEGA_SATAN] = mod.Achievements.ShBoom,
        --[CompletionType.BOSS_RUSH] = mod.Achievements.Universal,
        --[CompletionType.HUSH] = mod.Achievements.EverybodysChanging,
        --[CompletionType.BEAST] = mod.Achievements.U2,
        --[CompletionType.MOTHER] = mod.Achievements.KillerQueen,
        --[CompletionType.ULTRA_GREEDIER] = mod.Achievements.RingOfFire,
        --[CompletionType.DELIRIUM] = mod.Achievements.HelterSkelter,
        --[CompletionType.BLUE_BABY] = mod.Achievements.BabyBlue,
        --[CompletionType.ULTRA_GREED] = mod.Achievements.WonderOfYou
    --}
}

local function TryUnlock(ach)
    if not Game():AchievementUnlocksDisallowed() then
        Isaac.GetPersistentGameData():TryUnlock(ach)
    end
end

function mod:GiveUnlocks(mark, ptype)
    if not (UnlocksTable[ptype] and UnlocksTable[ptype][mark]) then return end
    TryUnlock(UnlocksTable[ptype][mark])
    if Isaac.AllMarksFilled(ptype) >= 2 then
    TryUnlock(UnlocksTable[ptype].AllHardMarks)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_MARK_GET, mod.GiveUnlocks)

------------------------------------------------------
---                David Unlock                    ---
------------------------------------------------------
local function OnPickupCollision(_, pickup, player)
    if not player:ToPlayer() then return end

    if pickup.Variant == PickupVariant.PICKUP_KEY and pickup.SubType == KeySubType.KEY_GOLDEN then
        player:GetData().goldenKeyPickedUp = true
    elseif pickup.Variant == PickupVariant.PICKUP_BOMB and pickup.SubType == BombSubType.BOMB_GOLDEN then
        player:GetData().goldenBombPickedUp = true
    elseif pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType == CoinSubType.COIN_GOLDEN then
        player:GetData().goldenCoinPickedUp = true
    end

    if player:GetData().goldenKeyPickedUp 
        and player:GetData().goldenBombPickedUp 
        and player:GetData().goldenCoinPickedUp then
        TryUnlock(mod.Achievements.David)
    end
end

local function OnNewRun(_, reenter)
    if reenter then return end 

    for _, player in ipairs(PlayerManager.GetPlayers()) do
        player:GetData().goldenKeyPickedUp = false
        player:GetData().goldenBombPickedUp = false
        player:GetData().goldenCoinPickedUp = false
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewRun)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, OnPickupCollision)

------------------------------------------------------
---                Tainted David Unlock            ---
------------------------------------------------------
if REPENTOGON then
    local game = Game()
    local character = mod.Players.David
    local achievement = mod.Achievements.T_David
    local gfxSlot = "gfx/characters/costumes/t_david_spritesheet.png"
    
    local taintedAchievement = {
      [character] = {unlock = achievement, gfx = gfxSlot}
    }
    
    function mod:SlotUpdate(slot)
      if not slot:GetSprite():IsFinished("PayPrize") then return end
      local d = slot:GetData().Tainted
      if d then
        Isaac.GetPersistentGameData():TryUnlock(d.unlock)
      end
    end
    mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.SlotUpdate, 14)
    
    function mod:HiddenCloset()
      if game:GetLevel():GetStage() ~= LevelStage.STAGE8 then return end
      if game:GetLevel():GetCurrentRoomDesc().SafeGridIndex ~= 94 then return end
      if game:AchievementUnlocksDisallowed() then return end
      local p = Isaac.GetPlayer():GetPlayerType()
      local d = taintedAchievement[p]
      if not d then return end
      local g = Isaac.GetPersistentGameData()
      if g:Unlocked(d.unlock) then return end
      if game:GetRoom():IsFirstVisit() then
        for _, k in ipairs(Isaac.FindByType(17)) do
          k:Remove()
        end
        for _, i in ipairs(Isaac.FindByType(5)) do
          i:Remove()
        end
        local s = Isaac.Spawn(6, 14, 0, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
        s:GetSprite():ReplaceSpritesheet(0, d.gfx, true)
        s:GetData().Tainted = d
      else
        for _, s in ipairs(Isaac.FindByType(6, 14)) do
          s:GetSprite():ReplaceSpritesheet(0, d.gfx, true)
          s:GetData().Tainted = d
        end
      end
    end
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.HiddenCloset)
    end
------------------------------------------------------
---                 Unlock Golden Day              ---
------------------------------------------------------
local function OnPickupCollision_GoldenDay(_, pickup, collider)
    local player = collider:ToPlayer()
    if not player then return end  
    if player:GetPlayerType() ~= mod.Players.David then return end  

    local data = player:GetData()

    if pickup.Variant == PickupVariant.PICKUP_KEY and pickup.SubType == KeySubType.KEY_GOLDEN then
        data.goldenKeyPickedUp = true
    elseif pickup.Variant == PickupVariant.PICKUP_BOMB and pickup.SubType == BombSubType.BOMB_GOLDEN then
        data.goldenBombPickedUp = true
    elseif pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType == CoinSubType.COIN_GOLDEN then
        data.goldenCoinPickedUp = true
    end

    if data.goldenKeyPickedUp 
    and data.goldenBombPickedUp 
    and data.goldenCoinPickedUp then
        TryUnlock(mod.Achievements.GoldenDay)
    end
end

local function OnNewRun_GoldenDay(_, reenter)
    if reenter then return end 

    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local data = player:GetData()
        data.goldenKeyPickedUp = false
        data.goldenBombPickedUp = false
        data.goldenCoinPickedUp = false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewRun_GoldenDay)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, OnPickupCollision_GoldenDay)

------------------------------------------------------
---                 Unlock Gaga                    ---
------------------------------------------------------
local hasUnlockedGaga = false
function mod:OnEntityKill(entity)
    local player = entity:ToPlayer()
    if not player then return end

    if player:GetPlayerType() ~= mod.Players.David then return end
    if player:WillPlayerRevive() then return end
    if hasUnlockedGaga then return end

    TryUnlock(mod.Achievements.Gaga)
    hasUnlockedGaga = true
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.OnEntityKill, EntityType.ENTITY_PLAYER)

------------------------------------------------------
---                 Unlock King's Heart            ---
------------------------------------------------------
local hasUnlockedKingsHeart = false
---@param player EntityPlayer
function mod:OnPlayerUpdate(player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local goldenHeartCount = player:GetGoldenHearts()

    if goldenHeartCount >= 3 and not hasUnlockedKingsHeart then
        TryUnlock(mod.Items.KingsHeart)
        hasUnlockedKingsHeart = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPlayerUpdate)

local function OnNewRun_KingsHeart(_, reenter)
    if reenter then return end 

    hasUnlockedKingsHeart = false
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewRun_KingsHeart)
