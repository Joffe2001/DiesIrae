local mod = DiesIraeMod
local game = Game()

local DavidUtils = include("scripts/core/david_challenges_utils")

-----------------------------------------------------------------
---                       Missed challenge                   ----
-----------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local floor = level:GetStage()
    local startRoom = level:GetStartingRoomIndex()
    local roomIndex = level:GetCurrentRoomIndex()

    local pdata = player:GetData()
    pdata.LastRoomIndex = pdata.LastRoomIndex or roomIndex

    local lastRoomIndex = pdata.LastRoomIndex
    pdata.LastRoomIndex = roomIndex

    if floor < 2 then return end
    if lastRoomIndex ~= startRoom then return end
    if roomIndex == startRoom then return end

    local plates = DavidPlates and DavidPlates[floor]
    local plateData = plates and plates[startRoom]
    if not plateData then return end
    if plateData.wasPressed then return end

    pdata.MissedPlateFloors = pdata.MissedPlateFloors or {}
    if pdata.MissedPlateFloors[floor] then return end

    pdata.MissedPlateFloors[floor] = true

    local plates = DavidPlates and DavidPlates[floor]
    local plateData = plates and plates[startRoom]
    if not plateData then return end
    if plateData.wasPressed then return end

    pdata.MissedPlateFloors = pdata.MissedPlateFloors or {}
    if pdata.MissedPlateFloors[floor] then return end

    pdata.MissedPlateFloors[floor] = true
    plateData.missed = true

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local pdata = player:GetData()
    if not pdata.MissedPlateFloors then return end

    local missedFloors = 0
    for _ in pairs(pdata.MissedPlateFloors) do
        missedFloors = missedFloors + 1
    end
    if missedFloors == 0 then return end

    if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed - 0.03 * missedFloors
    elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage - 0.15 * missedFloors
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay + 0.2 * missedFloors
    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed - 0.1 * missedFloors
    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck - 0.2 * missedFloors
    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange - 0.15 * 40 * missedFloors
    end
end)

-----------------------------------------------------------------
---                       CHALLENGE 1                        ----
-----------------------------------------------------------------
-- Frame 1 = Variant 21

-----------------------------------------------------------------
---   CHALLENGE 2 : Enter every special room on the floor    ----
-----------------------------------------------------------------
local CHALLENGE_ENTER_SPECIALS = 2

local SPECIAL_ROOMS = {
    [RoomType.ROOM_SHOP] = true,
    [RoomType.ROOM_TREASURE] = true,
    [RoomType.ROOM_BOSS] = true,
    [RoomType.ROOM_CURSE] = true,
    [RoomType.ROOM_SACRIFICE] = true,
    [RoomType.ROOM_DEVIL] = true,
    [RoomType.ROOM_ANGEL] = true,
    [RoomType.ROOM_ARCADE] = true,
    [RoomType.ROOM_LIBRARY] = true,
    [RoomType.ROOM_PLANETARIUM] = true
}
local VisitedSpecialRooms = {}

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local floor = level:GetStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_ENTER_SPECIALS then return end

    local room = game:GetRoom()
    local roomType = room:GetType()

    if not SPECIAL_ROOMS[roomType] then return end

    VisitedSpecialRooms[floor] = VisitedSpecialRooms[floor] or {}
    VisitedSpecialRooms[floor][roomType] = true
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local completedFloor = game:GetLevel():GetStage() - 1
    if completedFloor < 1 then return end

    if not mod:IsDavidChallengeActive(completedFloor) then return end
    if mod:GetDavidChallengeVariant(completedFloor) ~= CHALLENGE_ENTER_SPECIALS then return end

    local level = game:GetLevel()
    local rooms = level:GetRooms()
    local visited = VisitedSpecialRooms[completedFloor] or {}

    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if SPECIAL_ROOMS[desc.Data.Type] and not visited[desc.Data.Type] then
            return
        end
    end

    mod:CompleteDavidChallenge(completedFloor)
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    VisitedSpecialRooms = {}
end)


-----------------------------------------------------------------
---        CHALLENGE 3- Don't pick up any hearts             ----
-----------------------------------------------------------------
local CHALLENGE_NO_HEARTS = 3

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= 3 then return end

    if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end

    if pickup:IsDead() then
        mod:FailDavidChallenge(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local completedFloor = level:GetStage() - 1
    if completedFloor < 1 then return end

    if not mod:IsDavidChallengeActive(completedFloor) then return end
    if mod:GetDavidChallengeVariant(completedFloor) ~= CHALLENGE_NO_HEARTS then return end

    mod:CompleteDavidChallenge(completedFloor)
end)



-----------------------------------------------------------------
--- CHALLENGE 4: Don't fire for 2 seconds after entering a room.----
-----------------------------------------------------------------
local CHALLENGE_NO_FIRE_DELAY = 4

local NO_FIRE_FRAMES = 120

--What is happening in this room?
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_FIRE_DELAY then return end

    local pdata = player:GetData()
    pdata.NoFireRoomActive = true
end)

--Do not open fire!! yet.
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_FIRE_DELAY then return end

    local pdata = player:GetData()
    if not pdata.NoFireRoomActive then return end

    local room = game:GetRoom()

    if room:GetFrameCount() >= NO_FIRE_FRAMES then
        pdata.NoFireRoomActive = false
        return
    end

    if player:GetFireDirection() ~= Direction.NO_DIRECTION then
        mod:FailDavidChallenge(player, floor)
        pdata.NoFireRoomActive = false
    end
end)

--Well done, you have learned patience.
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local prevFloor = game:GetLevel():GetStage() - 1
    if prevFloor < 1 then return end

    if not mod:IsDavidChallengeActive(prevFloor) then return end
    if mod:GetDavidChallengeVariant(prevFloor) ~= CHALLENGE_NO_FIRE_DELAY then return end

    mod:CompleteDavidChallenge(prevFloor)
end)

-----------------------------------------------------------------
---CHALLENGE 5: Don't use keys, bombs, coins the entire floor----
-----------------------------------------------------------------
local CHALLENGE_NO_RESOURCES = 5

local LastResources = {
    coins = {},
    keys  = {},
    bombs = {}
}

-- Bomb usage
mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bomb)
    local player = bomb.SpawnerEntity and bomb.SpawnerEntity:ToPlayer()
    if not player then return end
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_RESOURCES then return end

    mod:FailDavidChallenge(player, floor)
end)

-- Track pickup usage
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_RESOURCES then return end

    LastResources.coins[floor] = LastResources.coins[floor] or player:GetNumCoins()
    LastResources.keys[floor]  = LastResources.keys[floor]  or player:GetNumKeys()
    LastResources.bombs[floor] = LastResources.bombs[floor] or player:GetNumBombs()

    local coins = player:GetNumCoins()
    local keys  = player:GetNumKeys()
    local bombs = player:GetNumBombs()

    if coins < LastResources.coins[floor]
        or keys < LastResources.keys[floor]
        or bombs < LastResources.bombs[floor]
    then
        mod:FailDavidChallenge(player, floor)
        return
    end

    LastResources.coins[floor] = coins
    LastResources.keys[floor]  = keys
    LastResources.bombs[floor] = bombs
end)

-- Complete challenge
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local completedFloor = game:GetLevel():GetStage() - 1
    if completedFloor < 1 then return end

    if not mod:IsDavidChallengeActive(completedFloor) then return end
    if mod:GetDavidChallengeVariant(completedFloor) ~= CHALLENGE_NO_RESOURCES then return end

    mod:CompleteDavidChallenge(completedFloor)
end)

-- Cleanup
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    LastResources = {
        coins = {},
        keys  = {},
        bombs = {}
    }
end)
-----------------------------------------------------------------
---                       CHALLENGE 6                        ----
-----------------------------------------------------------------
-- Frame 6 = Variant 26

-----------------------------------------------------------------
---        CHALLENGE 7 : Don't get hit. Chapion doubled      ----
-----------------------------------------------------------------
local CHALLENGE_NO_HIT = 7
local EXTRA_CHAMPION_CHANCE = 0.15

-- Check if David got hit
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity)
    local player = entity:ToPlayer()
    if not player then return end
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local floor = level:GetStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_HIT then return end

    mod:FailDavidChallenge(player, floor)
end)

-- Increase champions rate!
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if not npc:IsActiveEnemy(false) or npc:IsBoss() then return end

    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local floor = level:GetStage()

    if not mod:IsDavidChallengeActive(floor) then return end
    if mod:GetDavidChallengeVariant(floor) ~= CHALLENGE_NO_HIT then return end

    if npc:IsChampion() then return end

    local rng = npc:GetDropRNG()
    if rng:RandomFloat() < EXTRA_CHAMPION_CHANCE then
        npc:MakeChampion(rng:RandomInt(25), -1)
    end
end)

-- The challenge is completed
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local prevFloor = game:GetLevel():GetStage() - 1
    if prevFloor < 1 then return end

    if not mod:IsDavidChallengeActive(prevFloor) then return end
    if mod:GetDavidChallengeVariant(prevFloor) ~= CHALLENGE_NO_HIT then return end

    mod:CompleteDavidChallenge(prevFloor)
end)


-----------------------------------------------------------------
---                       CHALLENGE 8                        ----
-----------------------------------------------------------------
-- Frame 8 = Variant 28

-----------------------------------------------------------------
---                       CHALLENGE 9                        ----
-----------------------------------------------------------------
-- Frame 9 = Variant 29

