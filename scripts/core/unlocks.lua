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
    [mod.Players.Elijah] = {
        [CompletionType.MOMS_HEART] = mod.Achievements.RuneBum,
        [CompletionType.ISAAC] = mod.Achievements.PastorBum,
        [CompletionType.SATAN] = mod.Achievements.TarotBum,
        [CompletionType.LAMB] = mod.Achievements.RedBum,
        [CompletionType.MEGA_SATAN] = mod.Achievements.SacrificeTable,
        [CompletionType.BOSS_RUSH] = mod.Achievements.PillBum,
        [CompletionType.HUSH] = mod.Achievements.LostAdventurer,
        [CompletionType.BEAST] = mod.Achievements.FamiliarsBeggar,
        [CompletionType.MOTHER] = mod.Achievements.FiendDeal,
        [CompletionType.ULTRA_GREEDIER] = mod.Achievements.JYS,
        [CompletionType.DELIRIUM] = mod.Achievements.FairBum,
        [CompletionType.BLUE_BABY] = mod.Achievements.Goldsmith,
        [CompletionType.ULTRA_GREED] = mod.Achievements.ScammerBum,
        AllHardMarks = mod.Achievements.ChaosBeggar
    },
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

---------------------------------------------------------
--                   PERSONAL BEGGAR                 ---
---------------------------------------------------------
local personalBeggarTriggered = false

local function CheckElijahWinOnGameEnd(_, gameOver)
    if not gameOver then return end
    if personalBeggarTriggered then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    if player:GetPlayerType() == mod.Players.Elijah then
        TryUnlock(mod.Achievements.PersonalBeggar)
        personalBeggarTriggered = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, CheckElijahWinOnGameEnd)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinue)
    if isContinue then return end
    personalBeggarTriggered = false
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
---            Unlock Flowering Skull             ---
------------------------------------------------------
local function OnDeath_FloweringSkull(_, entity)
    local player = entity:ToPlayer()
    if not player then return end

    if player:GetActiveItem() == mod.Items.HelterSkelter then
        TryUnlock(mod.Achievements.FloweringSkull)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, OnDeath_FloweringSkull, EntityType.ENTITY_PLAYER)

------------------------------------------------------
---                 Unlock Echo                    ---
------------------------------------------------------
local enteredPlanetarium = false
local tookPlanetariumItem = false
local echoUnlocked = false

local function OnNewRun_Echo(_, reenter)
    if reenter then return end
    enteredPlanetarium = false
    tookPlanetariumItem = false
    echoUnlocked = false
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, OnNewRun_Echo)

local function OnPostNewRoom_Echo()
    if echoUnlocked then return end

    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_PLANETARIUM then
        enteredPlanetarium = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OnPostNewRoom_Echo)

function mod:OnPickup_Planetarium(pickup, collider, low)
    if echoUnlocked then return end
    
    local player = collider:ToPlayer()
    if not player then return end
    
    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local itemConfig = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
        if itemConfig then
            local itemPool = Game():GetItemPool()
            if itemPool:CanSpawnCollectible(pickup.SubType, true) then
                local room = Game():GetRoom()
                if room:GetType() == RoomType.ROOM_PLANETARIUM then
                    tookPlanetariumItem = true
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnPickup_Planetarium, PickupVariant.PICKUP_COLLECTIBLE)

local function OnPostNewLevel_Echo()
    if echoUnlocked then return end

    if enteredPlanetarium and not tookPlanetariumItem then
        TryUnlock(mod.Achievements.Echo)
        echoUnlocked = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, OnPostNewLevel_Echo)

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
---                      Beggars Unlocks          ---  
------------------------------------------------------

mod.BeggarUnlocks = {
    [mod.Entities.BEGGAR_Goldsmith.Var]         = mod.Achievements.Goldsmith,
    [mod.Entities.BEGGAR_JYS.Var]               = mod.Achievements.JYS,
    [mod.Entities.BEGGAR_Familiars.Var]         = mod.Achievements.FamiliarsBeggar,
    [mod.Entities.BEGGAR_SacrificeTable.Var]    = mod.Achievements.SacrificeTable,
    [mod.Entities.BEGGAR_Chaos.Var]             = mod.Achievements.ChaosBeggar,
    [mod.Entities.BEGGAR_Lost_Adventurer.Var]   = mod.Achievements.LostAdventurer,
}
mod.BeggarFallbacks = {
    [mod.Entities.BEGGAR_Goldsmith.Var]       = SlotVariant.BEGGAR,
    [mod.Entities.BEGGAR_JYS.Var]             = SlotVariant.BEGGAR,
    [mod.Entities.BEGGAR_Familiars.Var]       = SlotVariant.BEGGAR,
    [mod.Entities.BEGGAR_SacrificeTable.Var]  = SlotVariant.DEVIL_BEGGAR,
    [mod.Entities.BEGGAR_Chaos.Var]           = SlotVariant.DEVIL_BEGGAR,
    [mod.Entities.BEGGAR_Lost_Adventurer.Var] = SlotVariant.BEGGAR,
}

local function IsUnlocked(ach)
    return Isaac.GetPersistentGameData():Unlocked(ach)
end

function mod:PreventLockedBeggarSpawn(entityType, entityVariant, entitySubtype, gridIndex, seed)
    if entityType ~= EntityType.ENTITY_SLOT then
        return
    end

    local req = mod.BeggarUnlocks[entityVariant]
    if not req then
        return
    end

    if IsUnlocked(req) then
        return
    end
    local fallbackVariant = mod.BeggarFallbacks[entityVariant] or SlotVariant.BEGGAR

    return {
        EntityType.ENTITY_SLOT,
        fallbackVariant,
        0
    }
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, mod.PreventLockedBeggarSpawn)

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
