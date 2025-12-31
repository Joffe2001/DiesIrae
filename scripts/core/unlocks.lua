---@diagnostic disable: inject-field
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
---                  Elijah Unlock                 ---
------------------------------------------------------
local beggarsPaidThisRun = 0

function OnSlotUpdate_Elijah(_, slot)
    if beggarsPaidThisRun >= 3 then return end

    local spr = slot:GetSprite()

    if spr:IsFinished("Teleport") then
        RegisterBeggarPaid(slot)
    end

    if spr:IsFinished("Disappear") then
        RegisterBeggarPaid(slot)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, OnSlotUpdate_Elijah)

function RegisterBeggarPaid(slot)
    local v = slot.Variant
    if v == SlotVariant.BEGGAR
    or v == SlotVariant.KEY_MASTER
    or v == SlotVariant.BOMB_BUM
    or v == SlotVariant.ROTTEN_BEGGAR
    or v == SlotVariant.BATTERY_BUM
    or v == SlotVariant.DEVIL_BEGGAR
    then
        beggarsPaidThisRun = beggarsPaidThisRun + 1

        if beggarsPaidThisRun >= 3 then
            TryUnlock(mod.Achievements.Elijah)
        end
    end
end

local function OnNewRun_Elijah(_, reenter)
    if not reenter then
        beggarsPaidThisRun = 0
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewRun_Elijah)

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
        TryUnlock(mod.Achievements.KingsHeart)
        hasUnlockedKingsHeart = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPlayerUpdate)

local function OnNewRun_KingsHeart(_, reenter)
    if reenter then return end 

    hasUnlockedKingsHeart = false
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewRun_KingsHeart)

------------------------------------------------------
---            Unlock SlingShot                   ---
------------------------------------------------------
local slingshotUnlocked = false

local function CheckSlingShotUnlock(player)
    if slingshotUnlocked then return end
    if mod:GetCompletedDavidChallengeCount() >= 1 then
        TryUnlock(mod.Achievements.SlingShot)
        slingshotUnlocked = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    if player:GetPlayerType() ~= mod.Players.David then return end
    CheckSlingShotUnlock(player)
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, reenter)
    if reenter then return end
    slingshotUnlocked = false
end)

------------------------------------------------------
---              Unlock Devil's Heart              ---
------------------------------------------------------
local hasUnlockedDevilsHeart = false
local tookDevilDealFatal = false 

local function OnPlayerDamaged_Devil(_, entity, amount, flags, source)
    local player = entity:ToPlayer()
    if not player then return end
    tookDevilDealFatal = false

    if flags & DamageFlag.DAMAGE_RED_HEARTS ~= 0 then
        if amount >= player:GetHearts() + player:GetSoulHearts() then
            tookDevilDealFatal = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, OnPlayerDamaged_Devil, EntityType.ENTITY_PLAYER)

local function OnEntityKill_Devil(_, entity)
    local player = entity:ToPlayer()
    if not player then return end
    if hasUnlockedDevilsHeart then return end

    if tookDevilDealFatal then
        TryUnlock(mod.Achievements.DevilsHeart)
        hasUnlockedDevilsHeart = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, OnEntityKill_Devil, EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, reenter)
    if reenter then return end
    hasUnlockedDevilsHeart = false
    tookDevilDealFatal = false
end)

------------------------------------------------------
---         Unlock Michelin Star                  ---
------------------------------------------------------
local michelinUnlocked = false

local function CheckMichelinUnlock(player)
    if michelinUnlocked then return end
    if mod:GetCompletedDavidChallengeCount() >= 4 then
        TryUnlock(mod.Achievements.MichelinStar)
        michelinUnlocked = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    if player:GetPlayerType() ~= mod.Players.David then return end
    CheckMichelinUnlock(player)
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, reenter)
    if reenter then return end
    michelinUnlocked = false
end)

------------------------------------------------------
---                 Unlock PTSD                    ---
------------------------------------------------------
local hasUnlockedPTSD = false
local lastBossDamage = false 

local function OnPlayerDamaged_PTSD(_, entity, amount, flags, source)
    local player = entity:ToPlayer()
    if not player then return end
    lastBossDamage = false

    if source and source.Entity and source.Entity:IsBoss() then
        lastBossDamage = true
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, OnPlayerDamaged_PTSD, EntityType.ENTITY_PLAYER)

local function OnEntityKill_PTSD(_, entity)
    local player = entity:ToPlayer()
    if not player then return end  
    if hasUnlockedPTSD then return end

    local stage = Game():GetLevel():GetStage()
    if stage ~= LevelStage.STAGE1_1 then return end

    if lastBossDamage then
        TryUnlock(mod.Achievements.PTSD)
        hasUnlockedPTSD = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, OnEntityKill_PTSD, EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, reenter)
    if reenter then return end
    hasUnlockedPTSD = false
    lastBossDamage = false
end)
------------------------------------------------------
---            Unlock Ultra Secret Map             ---
------------------------------------------------------
local visitedUSR = {}
local ultraUnlockDone = false

local function OnNewRun_USR(_, reenter)
    if reenter then return end
    visitedUSR = {}
    ultraUnlockDone = false
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewRun_USR)

local function OnPostNewRoom_USR()
    if ultraUnlockDone then return end

    local level = Game():GetLevel()
    local desc = level:GetCurrentRoomDesc()
    if not desc or not desc.Data then return end

    if desc.Data.Type == RoomType.ROOM_ULTRASECRET then
        local idx = level:GetCurrentRoomIndex()
        if not idx then return end

        visitedUSR[idx] = true

        local count = 0
        for _ in pairs(visitedUSR) do
            count = count + 1
        end

        if count >= 2 then
            TryUnlock(mod.Achievements.UltraSecretMap)
            ultraUnlockDone = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OnPostNewRoom_USR)

------------------------------------------------------
---         Unlock Creatine Overdose               ---
------------------------------------------------------
local creatineUnlocked = false
local function CheckCreatineUnlock(player)
    if creatineUnlocked then return end

    if player:GetCollectibleNum(mod.Items.ProteinPowder, false) >= 2 then
        TryUnlock(mod.Achievements.CreatineOverdose)
        creatineUnlocked = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    CheckCreatineUnlock(player)
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, reenter)
    if reenter then return end
    creatineUnlocked = false
end)

------------------------------------------------------
---         Unlock Stab Wound                      ---
------------------------------------------------------
local tookDamage_StabWound = false
local inHeartFight = false
local StabWoundUnlocked = false

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, reenter)
    if reenter then return end
    tookDamage_StabWound = false
    inHeartFight = false
    StabWoundUnlocked = false
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, dmg, flags, source)
    if ent.Type == EntityType.ENTITY_PLAYER then
        tookDamage_StabWound = true
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    inHeartFight = false

    local room = Game():GetRoom()
    local roomType = room:GetType()
    if roomType ~= RoomType.ROOM_BOSS then return end

    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if ent:IsActiveEnemy() then
            if ent.Type == EntityType.ENTITY_MOMS_HEART
            -- we sure about this one ?
            ---@diagnostic disable-next-line: undefined-field
            or ent.Type == EntityType.ENTITY_IT_LIVES then

                inHeartFight = true
                return
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if StabWoundUnlocked then return end
    if not inHeartFight then return end
    if tookDamage_StabWound then return end

    local room = Game():GetRoom()

    if room:GetAliveEnemiesCount() == 0 then
        TryUnlock(mod.Achievements.StabWound)
        StabWoundUnlocked = true
    end
end)

------------------------------------------------------
---                 Unlock Cheater                 --- SECRET
------------------------------------------------------
local CHEATER_BOSSES = {
    [EntityType.ENTITY_HUSH] = true,
    [EntityType.ENTITY_MEGA_SATAN] = true,
    [EntityType.ENTITY_DELIRIUM] = true,
}

local cheaterStartFrame = nil
local cheaterActive = false
local cheaterUnlocked = false

function mod:Cheater_OnNewRoom()
    if Game():GetRoom():IsClear() then return end
    if cheaterUnlocked then return end

    local room = Game():GetRoom()
    local roomType = room:GetType()

    if roomType ~= RoomType.ROOM_BOSS then return end

    for _, e in ipairs(Isaac.GetRoomEntities()) do
        if CHEATER_BOSSES[e.Type] then
            cheaterStartFrame = Game():GetFrameCount()
            cheaterActive = true
            return
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.Cheater_OnNewRoom)


function mod:Cheater_OnEntityKill(entity)
    if not cheaterActive or cheaterUnlocked then return end

    if not CHEATER_BOSSES[entity.Type] then return end

    local now = Game():GetFrameCount()
    local elapsed = now - (cheaterStartFrame or now)

    if elapsed <= 60 * 30 then 
        TryUnlock(mod.Achievements.Cheater)
        cheaterUnlocked = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.Cheater_OnEntityKill)


function mod:Cheater_OnNewRun(_, reenter)
    if reenter then return end
    cheaterStartFrame = nil
    cheaterActive = false
    cheaterUnlocked = false
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.Cheater_OnNewRun)

------------------------------------------------------
---              Unlock Speedrun1                  --- SECRET
------------------------------------------------------
local levelStartTime = 0
local SPEEDRUN_TIME_LIMIT = 30 
local hasUnlockedSpeedrun1 = false

local function OnNewLevel_Speedrun1()
    local level = Game():GetLevel()

    if level:GetStage() == LevelStage.STAGE1_1 then
        levelStartTime = Isaac.GetTime() 
        hasUnlockedSpeedrun1 = false
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, OnNewLevel_Speedrun1)


local function OnNPCDeath_Speedrun1(_, npc)
    if hasUnlockedSpeedrun1 then return end
    if not npc:IsBoss() then return end
    local level = Game():GetLevel()
    if level:GetStage() ~= LevelStage.STAGE1_1 then return end

    local elapsed = (Isaac.GetTime() - levelStartTime) / 1000

    if elapsed <= SPEEDRUN_TIME_LIMIT then
        TryUnlock(mod.Achievements.Speedrun1)
        hasUnlockedSpeedrun1 = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, OnNPCDeath_Speedrun1)

------------------------------------------------------
---                 Unlock Wimter                  --- SECRET
------------------------------------------------------
local wimterUnlocked = false
local function CheckwimterUnlock(player)
    if wimterUnlocked then return end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_URANUS)
    and player:HasCollectible(CollectibleType.COLLECTIBLE_FREEZER_BABY)
    and player:HasCollectible(CollectibleType.COLLECTIBLE_CUBE_BABY) then
        TryUnlock(mod.Achievements.Wimter)
        wimterUnlocked = true
    end
end

local function OnPlayerUpdate_wimter(_, player)
    CheckwimterUnlock(player)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, OnPlayerUpdate_wimter)

local function OnNewRun_wimter(_, reenter)
    if reenter then return end
    wimterUnlocked = false
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewRun_wimter)

------------------------------------------------------
---                 Unlock function                ---
------------------------------------------------------
function mod:DebugUnlock(cmd, params)
    if cmd ~= "DIunlock" then
        return 
    end

    local pdata = Isaac.GetPersistentGameData()
    local argument = params:lower():gsub("^%s+", ""):gsub("%s+$", "")

    if argument == "unlockall" then
        for name, id in pairs(mod.Achievements) do
            if id and id > 0 then
                pdata:TryUnlock(id)
                print("[DI] Unlocked: " .. name)
            end
        end
        print("[DI] All achievements unlocked.")
        return
    end

    for name, id in pairs(mod.Achievements) do
        local alias = name:lower():gsub("_", " ")
        if argument == name:lower() or argument == alias then
            pdata:TryUnlock(id)
            print("[DI] Unlocked: " .. name)
            return
        end
    end
    print("[DI] ERROR: Achievement '" .. params .. "' not found.")
end
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, mod.DebugUnlock)
