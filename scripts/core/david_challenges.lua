local mod = DiesIraeMod
local game = Game()

local DavidUtils = include("scripts/core/david_challenges_utils")

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
local BLOAT_BOSS_ROOMS = {1001,1002,1003,1004,1005,1006,1007,1008,1009}

local ForcedBossRoom = {}

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, function(_, roomDesc)
    local level = game:GetLevel()
    local floor = level:GetAbsoluteStage()

    if ForcedBossRoom[floor] then return end
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_HIT_BOSS then return end
    if roomDesc.Data.Type ~= RoomType.ROOM_BOSS then return end
    if level:GetStage() < LevelStage.STAGE3_1 then return end

    local rng = RNG()
    rng:SetSeed(roomDesc.SpawnSeed, 35)

    local targetRoomID = BLOAT_BOSS_ROOMS[rng:RandomInt(#BLOAT_BOSS_ROOMS) + 1]
    local roomCfg = RoomConfig.GetRoomByID(targetRoomID)
    if not roomCfg then return end

    ForcedBossRoom[floor] = true
    return roomCfg
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetAbsoluteStage()
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_HIT_BOSS then return end

    if game:GetRoom():GetType() == RoomType.ROOM_BOSS then
        local pdata = player:GetData()
        pdata.DavidBossStarted = pdata.DavidBossStarted or {}
        pdata.DavidBossStarted[floor] = true
    end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity)
    local player = entity:ToPlayer()
    if not player then return end
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local floor = level:GetAbsoluteStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_HIT_BOSS then return end

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSS then return end

    mod:FailDavidChallenge(player, floor)
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local floor = level:GetAbsoluteStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_HIT_BOSS then return end

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSS then return end
    if not room:IsClear() then return end

    mod:CompleteDavidChallenge(floor)
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

local SpawnedSpecialRooms = {}
local VisitedSpecialRooms = {}
local SpecialChallengeCompleted = {}

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local floor = game:GetLevel():GetStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_ENTER_SPECIALS then return end

    SpawnedSpecialRooms[floor] = {}
    VisitedSpecialRooms[floor] = {}
    SpecialChallengeCompleted[floor] = false

    local rooms = game:GetLevel():GetRooms()
    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if desc and desc.Data and COUNTABLE_ROOMS[desc.Data.Type] then
            SpawnedSpecialRooms[floor][desc.RoomIndex] = true
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local floor = game:GetLevel():GetStage()

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
--- CHALLENGE 6: Don’t miss more than 50 shots on the floor
-----------------------------------------------------------------
local CHALLENGE_NO_MISS = 6
local MAX_MISSES = 50

local MissedShots = {}

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_MISS then return end

    local data = tear:GetData()
    data.David_NoMiss_Tracked = true
    data.David_NoMiss_Hit = false
end)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider)
    local data = tear:GetData()
    if not data.David_NoMiss_Tracked then return end
    if data.David_NoMiss_Hit then return end 

    local npc = collider:ToNPC()
    if npc and npc:IsActiveEnemy(false) then
        data.David_NoMiss_Hit = true
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_UPDATE, function(_, tear)
    local data = tear:GetData()
    if not data.David_NoMiss_Tracked then return end
    if data.David_NoMiss_Hit then return end

    if tear:HasTearFlags(TearFlags.TEAR_EXPLOSIVE) then
        data.David_NoMiss_Hit = true
        return
    end

    local room = game:GetRoom()
    local grid = room:GetGridEntityFromPos(tear.Position)
    if not grid then return end

    local gridType = grid:GetType()
    if gridType == GridEntityType.GRID_POOP
        or gridType == GridEntityType.GRID_FIREPLACE
        or gridType == GridEntityType.GRID_TNT
    then
        data.David_NoMiss_Hit = true
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    if not tear:IsDead() then return end

    local data = tear:GetData()
    if not data.David_NoMiss_Tracked then return end

    if data.David_NoMiss_Hit then return end

    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end

    local floor = game:GetLevel():GetStage()
    MissedShots[floor] = (MissedShots[floor] or 0) + 1

    if MissedShots[floor] > MAX_MISSES then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not Debug then return end

    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_NO_MISS then return end

    local misses = MissedShots[floor] or 0

    Isaac.RenderText(
        "No-Miss Challenge: " .. misses .. " / " .. MAX_MISSES,
        60,
        30,
        1, 1, 1, 1
    )
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    MissedShots = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    MissedShots = {}
end)

-----------------------------------------------------------------
--- CHALLENGE 8: Collect 10 David's Chords
-----------------------------------------------------------------
local CHALLENGE_COLLECT_CHORDS = 8
local REQUIRED_CHORDS = 10
local CHORD_DROP_CHANCE = 0.5
local CHORD_LIFETIME = 12 

local CollectedChords = {}

local function GetFloorKey()
    return game:GetLevel():GetAbsoluteStage()
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local floor = GetFloorKey()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_COLLECT_CHORDS then return end

    CollectedChords[floor] = 0
end)


mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsActiveEnemy(false) then return end
    if npc:IsBoss() then return end

    local floor = GetFloorKey()
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_COLLECT_CHORDS then return end

    local room = game:GetRoom()
    local rng = RNG()
    rng:SetSeed(room:GetDecorationSeed() + npc.InitSeed, 35)

    if rng:RandomFloat() >= CHORD_DROP_CHANCE then return end

    local pickup = Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        mod.Entities.PICKUP_DavidChord.Var,
        0,
        npc.Position,
        Vector.Zero,
        nil
    )
    pickup:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    local sprite = pickup:GetSprite()
    sprite:Play("Disappear", true)

    local data = pickup:GetData()
    data.ChordTimer = CHORD_LIFETIME
    data.ChordActive = true
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if pickup.Variant ~= mod.Entities.PICKUP_DavidChord.Var then return end

    local data = pickup:GetData()
    if not data.ChordActive then return end

    data.ChordTimer = data.ChordTimer - 1

    if data.ChordTimer <= 0 then
        pickup:Remove()
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.Variant ~= mod.Entities.PICKUP_DavidChord.Var then return end

    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= mod.Players.David then
        return true
    end

    pickup:Remove()

    local floor = GetFloorKey()
    CollectedChords[floor] = (CollectedChords[floor] or 0) + 1
    if CollectedChords[floor] >= REQUIRED_CHORDS then
        mod:CompleteDavidChallenge(floor)
    end
    return true 
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        CollectedChords = {}
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

-------------------------------------------------
-- CHALLENGE 9: FAST BOSS
-------------------------------------------------
local CHALLENGE_FAST_BOSS = 9
local FAST_BOSS_FRAMES = 30 * 180

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if DavidUtils.GetVariant(floor) ~= CHALLENGE_FAST_BOSS then return end
    if not DavidUtils.IsActive(floor) then return end

    local pdata = player:GetData()
    if not pdata.FastBossTimer then
        pdata.FastBossTimer = FAST_BOSS_FRAMES
    end

    pdata.FastBossTimer = pdata.FastBossTimer - 1
    if pdata.FastBossTimer <= 0 then
        pdata.FastBossTimer = nil
        mod:FailDavidChallenge(player, floor)
        return
    end

    local room = game:GetRoom()
    if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() then
        pdata.FastBossTimer = nil
        mod:CompleteDavidChallenge(floor)
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
