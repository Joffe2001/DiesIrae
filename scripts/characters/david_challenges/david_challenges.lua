local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local DavidUtils = include("scripts/characters/david_challenges/david_challenges_utils")

-------------------------------------------------
-- CONSTANTS
-------------------------------------------------
local CHALLENGES = {
    NO_HIT_BOSS = 1,
    ENTER_SPECIALS = 2,
    NO_HEARTS = 3,
    NO_FIRE_DELAY = 4,
    NO_RESOURCES = 5,
    NO_MISS = 6,
    NO_HIT = 7,
    COLLECT_CHORDS = 8,
    FAST_BOSS = 9,
    NO_USE = 10,
    STILL_KILLS = 11
}


local COUNTABLE_ROOMS = {
    [RoomType.ROOM_SHOP] = true,
    [RoomType.ROOM_TREASURE] = true,
    [RoomType.ROOM_CURSE] = true,
    [RoomType.ROOM_SACRIFICE] = true,
    [RoomType.ROOM_ARCADE] = true,
    [RoomType.ROOM_LIBRARY] = true,
    [RoomType.ROOM_PLANETARIUM] = true,
    [RoomType.ROOM_ISAACS] = true,
    [RoomType.ROOM_MINIBOSS] = true
}

-------------------------------------------------
-- HELPER FUNCTIONS
-------------------------------------------------
local function GetPlayer()
    return Isaac.GetPlayer(0)
end

local function IsDavid(player)
    return player and player:GetPlayerType() == mod.Players.David
end

local function GetCurrentFloor()
    return game:GetLevel():GetStage()
end

local function GetFloorKey(floor)
    return "floor_" .. tostring(floor)
end

local function GetCurrentRoom()
    return game:GetRoom()
end

local function IsActiveChallenge(floor, variant)
    return DavidUtils.IsActive(floor) and DavidUtils.GetVariant(floor) == variant
end

-------------------------------------------------
-- MISSED PLATE PENALTY
-------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local level = game:GetLevel()
    local floor = level:GetStage()
    if floor < 2 then return end

    local startRoom = level:GetStartingRoomIndex()
    local roomIndex = level:GetCurrentRoomIndex()

    local pdata = player:GetData()
    pdata.LastRoomIndex = pdata.LastRoomIndex or roomIndex

    local lastRoom = pdata.LastRoomIndex
    pdata.LastRoomIndex = roomIndex

    if lastRoom ~= startRoom or roomIndex == startRoom then return end

    local plateData = DavidPlates and DavidPlates[floor] and DavidPlates[floor][startRoom]
    if not plateData or plateData.wasPressed then return end

    pdata.MissedPlateFloors = pdata.MissedPlateFloors or {}
    if pdata.MissedPlateFloors[floor] then return end

    pdata.MissedPlateFloors[floor] = true
    plateData.missed = true

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
    if not IsDavid(player) then return end
    
    local pdata = player:GetData()
    if not pdata.MissedPlateFloors then return end

    local missed = 0
    for _ in pairs(pdata.MissedPlateFloors) do
        missed = missed + 1
    end
    if missed == 0 then return end

    if flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed - 0.01 * missed
    elseif flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage - 0.10 * missed
    elseif flag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay + 0.1 * missed
    elseif flag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed - 0.1 * missed
    elseif flag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck - 0.2 * missed
    elseif flag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange - 3 * missed
    end
end)

-------------------------------------------------
-- CHALLENGE 1: NO HIT BOSS
-------------------------------------------------
local function SwapChallengeBossRoom()
    local level = game:GetLevel()
    local floor = level:GetStage()

    if not IsActiveChallenge(floor, CHALLENGES.NO_HIT_BOSS) then return end
    if level:GetStage() < LevelStage.STAGE3_1 then return end

    local rooms = level:GetRooms()
    for i = 0, rooms.Size - 1 do
        local roomDesc = rooms:Get(i)
        if roomDesc.Data and roomDesc.Data.Type == RoomType.ROOM_BOSS then
            local newRoom = RoomConfigHolder.GetRandomRoom(
                roomDesc.SpawnSeed, false, StbType.SPECIAL_ROOMS,
                RoomType.ROOM_BOSS, roomDesc.Data.Shape,
                0, 9999, 0, 10, 0, 7
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
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_HIT_BOSS) then return end

    if GetCurrentRoom():GetType() == RoomType.ROOM_BOSS then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_HIT_BOSS) then return end

    local room = GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() then
        mod:CompleteDavidChallenge(floor)
    end
end)

-------------------------------------------------
-- CHALLENGE 2: ENTER ALL SPECIAL ROOMS
-------------------------------------------------
local VisitedSpecialRooms = {}
local SpecialChallengeCompleted = {}
local SpawnedSpecialRooms = {}

local function UpdateSpawnedSpecialRooms(floor)
    local key = GetFloorKey(floor)
    SpawnedSpecialRooms[key] = SpawnedSpecialRooms[key] or {}

    local rooms = game:GetLevel():GetRooms()
    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if desc and desc.Data and COUNTABLE_ROOMS[desc.Data.Type] 
           and desc.RoomIndex and desc.RoomIndex >= 0 then
            SpawnedSpecialRooms[key][desc.RoomIndex] = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.ENTER_SPECIALS) then return end

    local key = GetFloorKey(floor)
    SpawnedSpecialRooms[key] = {}
    VisitedSpecialRooms[key] = {}
    SpecialChallengeCompleted[key] = false

    UpdateSpawnedSpecialRooms(floor)
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local floor = GetCurrentFloor()
    UpdateSpawnedSpecialRooms(floor)

    if not IsActiveChallenge(floor, CHALLENGES.ENTER_SPECIALS) then return end
    
    local key = GetFloorKey(floor)
    if SpecialChallengeCompleted[key] then return end

    local spawned = SpawnedSpecialRooms[key]
    if not spawned then return end

    local roomIndex = game:GetLevel():GetCurrentRoomIndex()
    if spawned[roomIndex] then
        VisitedSpecialRooms[key] = VisitedSpecialRooms[key] or {}
        VisitedSpecialRooms[key][roomIndex] = true
    end
    
    for idx in pairs(spawned) do
        if not VisitedSpecialRooms[key][idx] then
            return
        end
    end
    
    SpecialChallengeCompleted[key] = true
    mod:CompleteDavidChallenge(floor)
end)

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function()
    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.ENTER_SPECIALS) then return end
    
    local key = GetFloorKey(floor)
    if SpecialChallengeCompleted[key] then return end

    mod:FailDavidChallenge(GetPlayer(), floor)
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
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.Variant ~= PickupVariant.PICKUP_HEART then
        return
    end
    local player = collider:ToPlayer()
    if not player then
        return
    end
    if not IsDavid(player) then
        return
    end
    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_HEARTS) then
        return
    end
    mod:FailDavidChallenge(player, floor)
    return true
end)

-------------------------------------------------
-- CHALLENGE 4: NO FIRE DELAY
-------------------------------------------------
local NO_FIRE_FRAMES = 120

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_FIRE_DELAY) then return end

    local room = GetCurrentRoom()
    if room:IsClear() then return end

    player:GetData().NoFireTimer = NO_FIRE_FRAMES
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_FIRE_DELAY) then return end

    local pdata = player:GetData()
    if not pdata.NoFireTimer then return end

    pdata.NoFireTimer = pdata.NoFireTimer - 1
    
    if pdata.NoFireTimer <= 0 then
        pdata.NoFireTimer = nil
        
        local effect = Isaac.Spawn(
            EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0,
            player.Position, Vector.Zero, player
        )
        effect.SpriteScale = Vector(0.7, 0.7)
        
        game:GetHUD():ShowItemText("You may fire")
        sfx:Play(SoundEffect.SOUND_UNLOCK00)
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
local LastResources = {}

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_RESOURCES) then return end

    local key = GetFloorKey(floor)
    LastResources[key] = LastResources[key] or {
        coins = player:GetNumCoins(),
        keys = player:GetNumKeys(),
        bombs = player:GetNumBombs()
    }

    local last = LastResources[key]
    if player:GetNumCoins() < last.coins or 
       player:GetNumKeys() < last.keys or 
       player:GetNumBombs() < last.bombs then
        mod:FailDavidChallenge(player, floor)
    end

    last.coins = player:GetNumCoins()
    last.keys = player:GetNumKeys()
    last.bombs = player:GetNumBombs()
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    LastResources = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        LastResources = {}
    end
end)

-------------------------------------------------
-- CHALLENGE 6: DON'T MISS MORE THAN 100 SHOTS
-------------------------------------------------
local MAX_MISSES = 100
local ShotsThisFloor = {}
local MissesThisFloor = {}
local PendingShots = {}

local function IsValidTarget(entity, player)
    if not entity then return false end
    if entity:IsVulnerableEnemy() then return true end

    local t = entity.Type
    if t == EntityType.ENTITY_FIREPLACE or t == EntityType.ENTITY_POOP or
       t == EntityType.ENTITY_TNT or t == EntityType.ENTITY_BOMBDROP or
       t == EntityType.ENTITY_BOMB then
        return true
    end

    if t == EntityType.ENTITY_PICKUP then
        return player:HasCollectible(mod.Items.BeggarsTear)
    end

    return false
end

local function RoomHasValidTargets(player)
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if IsValidTarget(ent, player) then
            return true
        end
    end
    return false
end

local function RegisterShotAttempt(floor)
    local key = GetFloorKey(floor)
    ShotsThisFloor[key] = (ShotsThisFloor[key] or 0) + 1
    table.insert(PendingShots, {floor = floor, frames = 0, hit = false})
end

local function OnWeaponFire()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_MISS) then return end

    if RoomHasValidTargets(player) then
        RegisterShotAttempt(floor)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, OnWeaponFire)
mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, OnWeaponFire)
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_INIT, OnWeaponFire)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, _, _, source)
    if not source.Entity then return end

    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_MISS) then return end
    if not IsValidTarget(entity, player) then return end

    local srcType = source.Entity.Type
    if srcType ~= EntityType.ENTITY_TEAR and 
       srcType ~= EntityType.ENTITY_LASER and 
       srcType ~= EntityType.ENTITY_KNIFE then
        return
    end

    for _, shot in ipairs(PendingShots) do
        if not shot.hit and shot.floor == floor then
            shot.hit = true
            break
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_MISS) then return end

    local key = GetFloorKey(floor)
    
    for i = #PendingShots, 1, -1 do
        local shot = PendingShots[i]
        shot.frames = shot.frames + 1

        if shot.frames > 15 then
            if not shot.hit then
                MissesThisFloor[key] = (MissesThisFloor[key] or 0) + 1
            end
            table.remove(PendingShots, i)
        end
    end

    if (MissesThisFloor[key] or 0) > MAX_MISSES then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_MISS) then return end

    local key = GetFloorKey(floor)
    local shots = ShotsThisFloor[key] or 0
    local misses = MissesThisFloor[key] or 0

    Isaac.RenderText(
        "Shots: " .. shots .. " | Misses: " .. misses .. "/" .. MAX_MISSES,
        60, 20, 1, 1, 1, 1
    )
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    ShotsThisFloor = {}
    MissesThisFloor = {}
    PendingShots = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        ShotsThisFloor = {}
        MissesThisFloor = {}
        PendingShots = {}
    end
end)

-------------------------------------------------
-- CHALLENGE 7: NO HIT (CHAMPIONS)
-------------------------------------------------
local EXTRA_CHAMPION_CHANCE = 0.30

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity)
    local player = entity:ToPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if IsActiveChallenge(floor, CHALLENGES.NO_HIT) then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if not npc:IsActiveEnemy(false) or npc:IsBoss() then return end
    if GetCurrentRoom():GetFrameCount() > 1 then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_HIT) then return end

    local rng = npc:GetDropRNG()
    if rng and rng:RandomFloat() < EXTRA_CHAMPION_CHANCE then
        npc:MakeChampion(rng:RandomInt(25), -1)
    end
end)

-------------------------------------------------
-- CHALLENGE 8: COLLECT 10 DAVID'S CHORDS
-------------------------------------------------
local REQUIRED_CHORDS = 10
local DROP_CHANCE = 0.15
local ChordsCollected = {}

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsVulnerableEnemy() or npc:IsBoss() then return end

    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.COLLECT_CHORDS) then return end

    local rng = npc:GetDropRNG()
    if rng:RandomFloat() < DROP_CHANCE then
        local chord = Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            mod.Entities.PICKUP_DavidChord.Var,
            mod.Entities.PICKUP_DavidChord.SubType or 0,
            npc.Position, Vector.Zero, npc
        ):ToPickup()

        if chord then
            chord:GetSprite():Play("Appear", true)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    local sprite = pickup:GetSprite()
    if sprite and not sprite:IsPlaying("Appear") then
        sprite:Play("Appear", true)
    end
end, mod.Entities.PICKUP_DavidChord.Var)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local sprite = pickup:GetSprite()
    if not sprite then return end
    
    if sprite:IsFinished("Appear") then
        sprite:Play("Idle", true)
    end

    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.COLLECT_CHORDS) then return end

    if pickup.Position:Distance(player.Position) < 20 then
        if not sprite:IsPlaying("Collect") then
            sprite:Play("Collect", true)
            sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK)
            
            local key = GetFloorKey(floor)
            ChordsCollected[key] = (ChordsCollected[key] or 0) + 1

            if ChordsCollected[key] >= REQUIRED_CHORDS then
                mod:CompleteDavidChallenge(floor)
                game:GetHUD():ShowItemText("All Chords Collected!")
            end
        end
    end
end, mod.Entities.PICKUP_DavidChord.Var)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function(_, pickup)
    local sprite = pickup:GetSprite()
    if sprite and sprite:IsFinished("Collect") then
        pickup:Remove()
    end
end, mod.Entities.PICKUP_DavidChord.Var)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    local player = collider:ToPlayer()
    if not player or not IsDavid(player) then
        return true
    end
end, mod.Entities.PICKUP_DavidChord.Var)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsBoss() then return end

    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.COLLECT_CHORDS) then return end

    local key = GetFloorKey(floor)
    if (ChordsCollected[key] or 0) < REQUIRED_CHORDS then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.COLLECT_CHORDS) then return end

    local key = GetFloorKey(floor)
    local collected = ChordsCollected[key] or 0
    Isaac.RenderText(
        "David's Chords: " .. collected .. " / " .. REQUIRED_CHORDS,
        60, 20, 1, 1, 1, 1
    )
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    ChordsCollected = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        ChordsCollected = {}
    end
end)

-------------------------------------------------
-- CHALLENGE 9: FAST BOSS
-------------------------------------------------
local FAST_BOSS_FRAMES = 30 * 180
local MIND_STAGES = {
    [LevelStage.STAGE2_1] = true,
    [LevelStage.STAGE2_2] = true,
    [LevelStage.STAGE3_1] = true,
}

local function GiveTemporaryMind(player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MIND) then return end

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
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local stage = GetCurrentFloor()
    
    if not IsActiveChallenge(stage, CHALLENGES.FAST_BOSS) then
        RemoveTemporaryMind(player)
        return
    end

    player:GetData().FastBossTimer = FAST_BOSS_FRAMES

    if MIND_STAGES[stage] then
        GiveTemporaryMind(player)
    else
        RemoveTemporaryMind(player)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local stage = GetCurrentFloor()
    if not IsActiveChallenge(stage, CHALLENGES.FAST_BOSS) then return end

    local pdata = player:GetData()
    if not pdata.FastBossTimer then return end

    pdata.FastBossTimer = pdata.FastBossTimer - 1
    
    if pdata.FastBossTimer <= 0 then
        pdata.FastBossTimer = nil
        RemoveTemporaryMind(player)
        mod:FailDavidChallenge(player, stage)
        return
    end

    local room = GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() then
        pdata.FastBossTimer = nil
        RemoveTemporaryMind(player)
        mod:CompleteDavidChallenge(stage)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = GetPlayer()
    if not IsDavid(player) then return end

    local stage = GetCurrentFloor()
    if not IsActiveChallenge(stage, CHALLENGES.FAST_BOSS) then return end

    local pdata = player:GetData()
    if not pdata.FastBossTimer then return end

    local seconds = math.floor(pdata.FastBossTimer / 30)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60

    Isaac.RenderText(
        string.format("Time: %d:%02d", minutes, remainingSeconds),
        60, 20, 1, 1, 1, 1
    )
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        local player = GetPlayer()
        if player then
            RemoveTemporaryMind(player)
        end
    end
end)

-------------------------------------------------
-- CHALLENGE 10: DO NOT USE ACTIVE/CONSUMABLES
-------------------------------------------------
local function FailOnUse()
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.NO_USE) then return end

    local players = PlayerManager.GetPlayers()
    if players and players[1] then
        mod:FailDavidChallenge(players[1], floor)
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, FailOnUse)
mod:AddCallback(ModCallbacks.MC_USE_CARD, FailOnUse)
mod:AddCallback(ModCallbacks.MC_USE_PILL, FailOnUse)

-------------------------------------------------
-- CHALLENGE 11: KILL 20 ENEMIES WHILE STANDING STILL
-------------------------------------------------
local REQUIRED_STILL_KILLS = 20
local STILL_DURATION = 15 
local STILL_THRESHOLD = 0.5

local FloorData = {}

local function GetFloorData(floor)
    if not FloorData[floor] then
        FloorData[floor] = {
            isStill = false,
            stillKills = 0,
            lastPos = nil,
            stillFrames = 0,
            completed = false
        }
    end
    return FloorData[floor]
end

local function IsDavid(player)
    return player:GetPlayerType() == mod.Players.David
end

local function GetCurrentFloor()
    return game:GetLevel():GetStage()
end

local function IsActiveChallenge(floor, challengeType)
    return mod:IsDavidChallengeActive(floor) 
        and mod:GetDavidChallengeVariant(floor) == challengeType
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.STILL_KILLS) then return end

    local data = GetFloorData(floor)
    
    if data.completed then return end

    if not data.lastPos then
        data.lastPos = player.Position
        return
    end

    local distSq = player.Position:DistanceSquared(data.lastPos)

    if distSq <= STILL_THRESHOLD then
        data.stillFrames = data.stillFrames + 1
        
        if data.stillFrames >= STILL_DURATION then
            data.isStill = true
        end
    else
        data.stillFrames = 0
        data.isStill = false
    end

    data.lastPos = player.Position
end)


mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsVulnerableEnemy() then return end

    local player = Isaac.GetPlayer(0)
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.STILL_KILLS) then return end

    local data = GetFloorData(floor)

    if data.completed then return end
    if not data.isStill then return end

    data.stillKills = data.stillKills + 1
    SFXManager():Play(SoundEffect.SOUND_POWERUP1)

    if data.stillKills >= REQUIRED_STILL_KILLS then
        data.completed = true
        mod:CompleteDavidChallenge(floor)
        game:GetHUD():ShowItemText("Standing Still")
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsBoss() then return end

    local player = Isaac.GetPlayer(0)
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.STILL_KILLS) then return end

    local data = GetFloorData(floor)
    
    if data.stillKills < REQUIRED_STILL_KILLS then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = Isaac.GetPlayer(0)
    if not IsDavid(player) then return end

    local floor = GetCurrentFloor()
    if not IsActiveChallenge(floor, CHALLENGES.STILL_KILLS) then return end

    local data = GetFloorData(floor)

    -- Main counter
    local kills = data.stillKills
    local counterText = "Still Kills: " .. kills .. " / " .. REQUIRED_STILL_KILLS
    
    local r, g, b = 1, 1, 1
    if data.completed then
        r, g, b = 0, 1, 0
    end
    
    Isaac.RenderText(counterText, 60, 20, r, g, b, 1)

    -- Status indicator
    if data.completed then
        Isaac.RenderText("COMPLETED", 60, 35, 0, 1, 0, 1)
    elseif data.isStill then
        Isaac.RenderText("STANDING STILL", 60, 35, 0, 1, 0, 1)
    else
        local progress = math.floor((data.stillFrames / STILL_DURATION) * 100)
        Isaac.RenderText("Hold still: " .. progress .. "%", 60, 35, 1, 1, 0, 0.6)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    FloorData = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        FloorData = {}
    end
end)