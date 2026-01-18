local mod = DiesIraeMod
local game = Game()

local DavidUtils = include("scripts/characters/david_challenges/david_challenges_utils")

-------------------------------------------------
-- MISSED PLATE PENALTY
-------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local floor = level:GetStage()
    local startRoom = level:GetStartingRoomIndex()
    local roomIndex = level:GetCurrentRoomIndex()

    if floor < 2 then return end

    local pdata = player:GetData()
    pdata.LastRoomIndex = pdata.LastRoomIndex or roomIndex

    local lastRoom = pdata.LastRoomIndex
    pdata.LastRoomIndex = roomIndex

    if lastRoom ~= startRoom then return end
    if roomIndex == startRoom then return end

    local plateData = DavidPlates
        and DavidPlates[floor]
        and DavidPlates[floor][startRoom]

    if not plateData or plateData.wasPressed then return end

    pdata.MissedPlateFloors = pdata.MissedPlateFloors or {}
    if pdata.MissedPlateFloors[floor] then return end

    pdata.MissedPlateFloors[floor] = true
    plateData.missed = true

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
    if player:GetPlayerType() ~= mod.Players.David then return end
    local pdata = player:GetData()
    if not pdata.MissedPlateFloors then return end

    local missed = 0
    for _ in pairs(pdata.MissedPlateFloors) do missed = missed + 1 end
    if missed == 0 then return end

    if flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed - 0.03 * missed
    elseif flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage - 0.15 * missed
    elseif flag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay + 0.2 * missed
    elseif flag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed - 0.1 * missed
    elseif flag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck - 0.2 * missed
    elseif flag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange - 6 * missed
    end
end)

-------------------------------------------------
-- CHALLENGE 1: NO HIT BOSS
-------------------------------------------------
local CHALLENGE_NO_HIT_BOSS = 1

local function SwapChallengeBossRoom()
    local level = game:GetLevel()
    local floor = level:GetStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_HIT_BOSS then return end
    if level:GetStage() < LevelStage.STAGE3_1 then return end

    local rooms = level:GetRooms()

    for i = 0, rooms.Size - 1 do
        local roomDesc = rooms:Get(i)
        local data = roomDesc.Data

        if data and data.Type == RoomType.ROOM_BOSS then
            local newRoom = RoomConfigHolder.GetRandomRoom(
                roomDesc.SpawnSeed,
                false,
                StbType.SPECIAL_ROOMS,
                RoomType.ROOM_BOSS,
                data.Shape,
                0,
                9999,
                0,
                10,
                0,
                7
            )
            
            if newRoom then
                roomDesc.Data = newRoom
            end
            break
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SwapChallengeBossRoom)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity)
    local player = entity:ToPlayer()
    if not player or player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_HIT_BOSS then return end

    if game:GetRoom():GetType() == RoomType.ROOM_BOSS then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_HIT_BOSS then return end

    local room = game:GetRoom()
    if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() then
        mod:CompleteDavidChallenge(floor)
    end
end)

-------------------------------------------------
-- CHALLENGE 2: ENTER ALL SPECIAL ROOMS
-------------------------------------------------
local CHALLENGE_ENTER_SPECIALS = 2

local COUNTABLE_ROOMS = {
    [RoomType.ROOM_SHOP]        = true,
    [RoomType.ROOM_TREASURE]   = true,
    [RoomType.ROOM_CURSE]      = true,
    [RoomType.ROOM_SACRIFICE]  = true,
    [RoomType.ROOM_ARCADE]     = true,
    [RoomType.ROOM_LIBRARY]    = true,
    [RoomType.ROOM_PLANETARIUM]= true,
    [RoomType.ROOM_ISAACS]     = true,
    [RoomType.ROOM_MINIBOSS]   = true
}

local VisitedSpecialRooms = {}
local SpecialChallengeCompleted = {}
local SpawnedSpecialRooms = {}

local function UpdateSpawnedSpecialRooms(floor)
    SpawnedSpecialRooms[floor] = SpawnedSpecialRooms[floor] or {}

    local rooms = game:GetLevel():GetRooms()
    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if desc and desc.Data and COUNTABLE_ROOMS[desc.Data.Type] and desc.RoomIndex and desc.RoomIndex >= 0 then
            SpawnedSpecialRooms[floor][desc.RoomIndex] = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local floor = game:GetLevel():GetStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_ENTER_SPECIALS then return end

    SpawnedSpecialRooms[floor] = {}
    VisitedSpecialRooms[floor] = {}
    SpecialChallengeCompleted[floor] = false

    UpdateSpawnedSpecialRooms(floor)
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local floor = game:GetLevel():GetStage()

    if DavidUtils.GetVariant(floor) ~= CHALLENGE_ENTER_SPECIALS then return end

    UpdateSpawnedSpecialRooms(floor)

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_ENTER_SPECIALS then return end
    if SpecialChallengeCompleted[floor] then return end

    local spawned = SpawnedSpecialRooms[floor]
    if not spawned then return end

    local roomIndex = game:GetLevel():GetCurrentRoomIndex()
    if spawned[roomIndex] then
        VisitedSpecialRooms[floor][roomIndex] = true
    end
    
    for idx, _ in pairs(spawned) do
        if not VisitedSpecialRooms[floor][idx] then
            return
        end
    end
    
    SpecialChallengeCompleted[floor] = true
    mod:CompleteDavidChallenge(floor)
end)

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function()
    local floor = game:GetLevel():GetStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_ENTER_SPECIALS then return end
    if SpecialChallengeCompleted[floor] then return end

    mod:FailDavidChallenge(Isaac.GetPlayer(0), floor)
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        SpawnedSpecialRooms = {}
        VisitedSpecialRooms = {}
        SpecialChallengeCompleted = {}
    end
end)

-------------------------------------------------
-- CHALLENGE 3: NO HEARTS 
-------------------------------------------------
local CHALLENGE_NO_HEARTS = 3

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end

    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_HEARTS then return end

    if pickup:IsDead() then
        mod:FailDavidChallenge(player, floor)
    end
end)

-------------------------------------------------
-- CHALLENGE 4: NO FIRE DELAY
-------------------------------------------------
local CHALLENGE_NO_FIRE_DELAY = 4
local NO_FIRE_FRAMES = 120

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_FIRE_DELAY then return end

    local room = game:GetRoom()
    if room:IsClear() then return end

    local pdata = player:GetData()
    pdata.NoFireTimer = NO_FIRE_FRAMES
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_FIRE_DELAY then return end

    local pdata = player:GetData()
    if not pdata.NoFireTimer then return end

    pdata.NoFireTimer = pdata.NoFireTimer - 1
    if pdata.NoFireTimer <= 0 then
        pdata.NoFireTimer = nil
    
        local effect = Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.POOF01,
            0,
            player.Position,
            Vector.Zero,
            player
        )
        effect.SpriteScale = Vector(0.7, 0.7)
    
        game:GetHUD():ShowItemText("You may fire")
        SFXManager():Play(SoundEffect.SOUND_UNLOCK00)
        return
    end

    if player:GetFireDirection() ~= Direction.NO_DIRECTION then
        mod:FailDavidChallenge(player, floor)
        pdata.NoFireTimer = nil
    end
end)

-------------------------------------------------
-- CHALLENGE 5: NO RESOURCES
-------------------------------------------------
local CHALLENGE_NO_RESOURCES = 5
local LastResources = {}

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_RESOURCES then return end

    LastResources[floor] = LastResources[floor] or {
        coins = player:GetNumCoins(),
        keys = player:GetNumKeys(),
        bombs = player:GetNumBombs()
    }

    local last = LastResources[floor]
    if player:GetNumCoins() < last.coins
        or player:GetNumKeys() < last.keys
        or player:GetNumBombs() < last.bombs then
        mod:FailDavidChallenge(player, floor)
    end

    last.coins = player:GetNumCoins()
    last.keys = player:GetNumKeys()
    last.bombs = player:GetNumBombs()
end)

-----------------------------------------------------------------
--- CHALLENGE 6: Don't miss more than 100 shots on the floor
-----------------------------------------------------------------
local CHALLENGE_NO_MISS = 6
local MAX_MISSES = 100

local ShotsThisFloor = {}
local HitsThisFloor  = {}

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source)
    if not entity:IsVulnerableEnemy() then return end

    local player = source.Entity and source.Entity:ToPlayer()
    if not player or player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_MISS then return end

    HitsThisFloor[floor] = (HitsThisFloor[floor] or 0) + 1
end)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_MISS then return end

    ShotsThisFloor[floor] = (ShotsThisFloor[floor] or 0) + 1
end)

mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, function(_, laser)
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_MISS then return end

    local laserData = laser:GetData()
    if not laserData.CountedShot then
        ShotsThisFloor[floor] = (ShotsThisFloor[floor] or 0) + 1
        laserData.CountedShot = true
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_INIT, function(_, knife)
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_MISS then return end

    local knifeData = knife:GetData()
    if not knifeData.CountedShot then
        ShotsThisFloor[floor] = (ShotsThisFloor[floor] or 0) + 1
        knifeData.CountedShot = true
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_MISS then return end

    local shots = ShotsThisFloor[floor] or 0
    local hits = HitsThisFloor[floor] or 0
    local misses = shots - hits

    if misses > MAX_MISSES then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_MISS then return end

    local shots = ShotsThisFloor[floor] or 0
    local hits = HitsThisFloor[floor] or 0
    local misses = shots - hits

    local text = "Misses: " .. misses .. "/" .. MAX_MISSES
    Isaac.RenderText(text, 60, 20, 1, 1, 1, 1)
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    ShotsThisFloor = {}
    HitsThisFloor  = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        ShotsThisFloor = {}
        HitsThisFloor  = {}
    end
end)

-------------------------------------------------
-- CHALLENGE 7: NO HIT (CHAMPIONS)
-------------------------------------------------
local CHALLENGE_NO_HIT = 7
local EXTRA_CHAMPION_CHANCE = 0.30

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity)
    local player = entity:ToPlayer()
    if not player or player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if DavidUtils.GetVariant(floor) == CHALLENGE_NO_HIT then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if not npc:IsActiveEnemy(false) or npc:IsBoss() then return end

    local room = game:GetRoom()
    if room:GetFrameCount() > 1 then return end

    local floor = game:GetLevel():GetStage()
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_HIT then return end

    local rng = npc:GetDropRNG()
    if not rng then return end 

    if rng:RandomFloat() < EXTRA_CHAMPION_CHANCE then
        local champVariant = rng:RandomInt(25)
        npc:MakeChampion(champVariant, -1)
    end
end)

-----------------------------------------------------------------
--- CHALLENGE 8: Collect 10 David's Chords
-----------------------------------------------------------------
local CHALLENGE_COLLECT_CHORDS = 8
local REQUIRED_CHORDS = 10
local CHORD_DROP_CHANCE = 0.5
local CHORD_LIFETIME = 12 * 30

local function GetCollectedChords()
    local save = mod.SaveManager.GetRunSave()
    save.CollectedChords = save.CollectedChords or 0
    return save.CollectedChords
end

local function SetCollectedChords(value)
    local save = mod.SaveManager.GetRunSave()
    save.CollectedChords = value
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        SetCollectedChords(0)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local floor = game:GetLevel():GetStage()
    if mod:IsDavidChallengeActive(floor) and mod:GetDavidChallengeVariant(floor) == CHALLENGE_COLLECT_CHORDS then
        SetCollectedChords(0)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsActiveEnemy(false) or npc:IsBoss() then return end

    local floor = game:GetLevel():GetStage()
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_COLLECT_CHORDS then return end

    local rng = RNG()
    rng:SetSeed(npc.InitSeed, 1)
    if rng:RandomFloat() >= CHORD_DROP_CHANCE then return end

    local pickup = Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        mod.Entities.PICKUP_DavidChord.Var,
        0,
        npc.Position,
        Vector.Zero,
        nil
    ):ToPickup()

    if pickup then
        pickup.Timeout = CHORD_LIFETIME
        pickup:GetSprite():Play("Idle", true)
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.Variant ~= mod.Entities.PICKUP_DavidChord.Var then return end

    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= mod.Players.David then
        return true
    end

    local floor = game:GetLevel():GetStage()
    
    pickup:Remove()
    
    local newCount = GetCollectedChords() + 1
    SetCollectedChords(newCount)

    if newCount >= REQUIRED_CHORDS then
        mod:CompleteDavidChallenge(floor)
    end
    
    return true
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_COLLECT_CHORDS then return end

    local count = GetCollectedChords()
    local text = "Chords: " .. count .. "/" .. REQUIRED_CHORDS
    Isaac.RenderText(text, 60, 20, 1, 1, 1, 1)
end)

-------------------------------------------------
-- CHALLENGE 9: FAST BOSS
-------------------------------------------------
local CHALLENGE_FAST_BOSS = 9
local FAST_BOSS_FRAMES = 30 * 180

local MIND_STAGES = {
    [LevelStage.STAGE2_1] = true,
    [LevelStage.STAGE2_2] = true,
    [LevelStage.STAGE3_1] = true,
}

local function GiveTemporaryMind(player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MIND) then
        return
    end

    local pdata = player:GetData()
    if pdata.TempMind then return end

    player:AddCollectible(CollectibleType.COLLECTIBLE_MIND, 0, false)
    pdata.TempMind = true
end

local function RemoveTemporaryMind(player)
    local pdata = player:GetData()
    if not pdata.TempMind then return end

    player:RemoveCollectible(CollectibleType.COLLECTIBLE_MIND)
    pdata.TempMind = nil
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local stage = level:GetStage()

    if not DavidUtils.IsActive(stage) then
        RemoveTemporaryMind(player)
        return
    end

    if DavidUtils.GetVariant(stage) ~= CHALLENGE_FAST_BOSS then
        RemoveTemporaryMind(player)
        return
    end

    local pdata = player:GetData()
    pdata.FastBossTimer = FAST_BOSS_FRAMES

    if MIND_STAGES[stage] then
        GiveTemporaryMind(player)
    else
        RemoveTemporaryMind(player)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local stage = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(stage) then return end
    if DavidUtils.GetVariant(stage) ~= CHALLENGE_FAST_BOSS then return end

    local pdata = player:GetData()
    if not pdata.FastBossTimer then return end

    pdata.FastBossTimer = pdata.FastBossTimer - 1
    if pdata.FastBossTimer <= 0 then
        pdata.FastBossTimer = nil
        RemoveTemporaryMind(player)
        mod:FailDavidChallenge(player, stage)
        return
    end

    local room = game:GetRoom()
    if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() then
        pdata.FastBossTimer = nil
        RemoveTemporaryMind(player)
        mod:CompleteDavidChallenge(stage)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local stage = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(stage) then return end
    if DavidUtils.GetVariant(stage) ~= CHALLENGE_FAST_BOSS then return end

    local pdata = player:GetData()
    if not pdata.FastBossTimer then return end

    local seconds = math.floor(pdata.FastBossTimer / 30)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60

    local text = string.format("Time: %d:%02d", minutes, remainingSeconds)
    Isaac.RenderText(text, 60, 20, 1, 1, 1, 1)
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        local player = Isaac.GetPlayer(0)
        if player then
            RemoveTemporaryMind(player)
        end
    end
end)

-------------------------------------------------
-- CHALLENGE 10: Do not use active or consumables
-------------------------------------------------
local CHALLENGE_NO_USE = 10

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, _, _, _)
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_USE then return end

    local player = PlayerManager.GetPlayers()[1]
    if player then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _)
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_USE then return end

    local player = PlayerManager.GetPlayers()[1]
    if player then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, _)
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_USE then return end

    local player = PlayerManager.GetPlayers()[1]
    if player then
        mod:FailDavidChallenge(player, floor)
    end
end)

-------------------------------------------------
-- CHALLENGE 11: Kill 20 enemies while standing still
-------------------------------------------------
local CHALLENGE_STILL_KILLS = 11
local REQUIRED_STILL_KILLS = 20

local StillKills = {}
local LastPos = {}

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsVulnerableEnemy() or npc:IsBoss() then return end

    local player = Isaac.GetPlayer(0)
    local floor = game:GetLevel():GetStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_STILL_KILLS then return end

    LastPos[floor] = LastPos[floor] or player.Position
    local standingStill = player.Position:DistanceSquared(LastPos[floor]) < 1
    LastPos[floor] = player.Position

    if standingStill then
        StillKills[floor] = (StillKills[floor] or 0) + 1
    end

    if (StillKills[floor] or 0) >= REQUIRED_STILL_KILLS then
        mod:CompleteDavidChallenge(floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsBoss() then return end

    local player = Isaac.GetPlayer(0)
    local floor = game:GetLevel():GetStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_STILL_KILLS then return end

    if (StillKills[floor] or 0) < REQUIRED_STILL_KILLS then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    StillKills = {}
    LastPos = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        StillKills = {}
        LastPos = {}
    end
end)