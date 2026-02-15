local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local DavidUtils = include("scripts/characters/david_challenges/david_challenges_utils")
local DavidChord = include("scripts/items/pocketitems/DavidChord")

------------------------------------------------------------
-- CHALLENGE DEFINITIONS
------------------------------------------------------------
mod.CHALLENGES = {
    NO_ACTIVES = 0,         -- Don't use active items or consumables
    FAST_BOSS = 1,          -- Beat the boss in under 4 minutes
    VISIT_ALL_SPECIAL = 2,  -- Enter every special room
    NO_HEARTS = 3,          -- Don't pick up any hearts
    NO_SHOOT_DELAY = 4,     -- Don't shoot for 2 seconds after entering room
    NO_RESOURCES = 5,       -- Don't use keys, bombs, or coins
    NO_HIT_CHAMPIONS = 6,   -- Don't get hit, champion chance doubled
    CLEAR_ALL_ROOMS = 7,    -- Don't leave any room uncleared (doors stay open)
    TAKE_ALL_PEDESTALS = 8  -- Take all pedestals on floor (no rerolling)
}

------------------------------------------------------------
-- HELPER: Get David's Chord data
------------------------------------------------------------
local function GetChordData(floor)
    local save = mod.SaveManager.GetRunSave()
    if not save or not save.DavidChordData then return nil end
    
    local key = "floor_" .. tostring(floor)
    return save.DavidChordData[key]
end

------------------------------------------------------------
-- CHALLENGE 0: NO ACTIVES OR CONSUMABLES
------------------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.NO_ACTIVES, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_ACTIVES)
        data.failed = false
    end,

    OnUseItem = function(player, floor, itemID)
        local chordData = GetChordData(floor)
        if chordData and chordData.effect0Data and chordData.effect0Data.allowActiveThisRoom then
            local currentRoom = game:GetLevel():GetCurrentRoomIndex()
            if currentRoom == chordData.effect0Data.roomIndex then
                return
            end
        end
        
        DavidUtils.Fail(player, floor)
    end,

    OnUseCard = function(player, floor, cardID)
        if cardID == mod.Cards.DavidChord then
            return
        end
    
        DavidUtils.Fail(player, floor)
    end,

    OnUsePill = function(player, floor, pillEffect)
        DavidUtils.Fail(player, floor)
    end,

    OnRender = function(player, floor)
        Isaac.RenderText("No Actives/Consumables!", 80, 20, 1, 1, 0.3, 1)
    end,
})

------------------------------------------------------------
-- CHALLENGE 1: FAST BOSS (BEAT UNDER 4 MINUTES)
------------------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.FAST_BOSS, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.FAST_BOSS)
        data.startTime = Game():GetFrameCount()
        data.timeLimit = 60 * 30 * 4  -- 4 minutes at 30 FPS
    end,

    OnUpdate = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.FAST_BOSS)
        
        local elapsed = Game():GetFrameCount() - data.startTime
        local timerAdjustment = DavidChord:GetTimerAdjustment(floor)
        elapsed = elapsed - timerAdjustment
        
        if elapsed >= data.timeLimit then
            DavidUtils.Fail(player, floor)
        end
    end,

    OnNewRoom = function(player, floor)
        local room = game:GetRoom()
        if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() then
            DavidUtils.Complete(floor)
        end
    end,

    OnRender = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.FAST_BOSS)
        
        local elapsed = Game():GetFrameCount() - data.startTime
        local timerAdjustment = DavidChord:GetTimerAdjustment(floor)
        elapsed = elapsed - timerAdjustment
        
        local remaining = data.timeLimit - elapsed
        local seconds = math.floor(remaining / 30)
        local minutes = math.floor(seconds / 60)
        seconds = seconds % 60
        
        local color = remaining < 1800 and {1, 0.3, 0.3, 1} or {1, 1, 1, 1}
        
        local chordData = GetChordData(floor)
        local frozenText = ""
        if chordData and chordData.frozenTime then
            local currentRoom = game:GetLevel():GetCurrentRoomIndex()
            if chordData.frozenRoomIndex == currentRoom then
                frozenText = " [FROZEN]"
                color = {0.3, 1, 1, 1}
            end
        end
        
        Isaac.RenderText(
            string.format("Time: %d:%02d%s", minutes, seconds, frozenText),
            80, 20, color[1], color[2], color[3], color[4]
        )
    end,
})

DavidUtils.Register(mod.CHALLENGES.VISIT_ALL_SPECIAL, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.VISIT_ALL_SPECIAL)
        data.visitedRooms = {}
        data.requiredRooms = {}
        
        local level = game:GetLevel()
        local rooms = level:GetRooms()
        
        for i = 0, rooms.Size - 1 do
            local desc = rooms:Get(i)
            if desc and desc.Data then
                local roomType = desc.Data.Type
                
                if roomType == RoomType.ROOM_TREASURE
                    or roomType == RoomType.ROOM_SHOP
                    or roomType == RoomType.ROOM_ARCADE
                    or roomType == RoomType.ROOM_LIBRARY
                    or roomType == RoomType.ROOM_CURSE
                    or roomType == RoomType.ROOM_MINIBOSS
                    or roomType == RoomType.ROOM_CHALLENGE
                    or roomType == RoomType.ROOM_SECRET
                    or roomType == RoomType.ROOM_DICE
                    or roomType == RoomType.ROOM_PLANETARIUM
                    or roomType == RoomType.ROOM_SUPERSECRET then

                    local roomKey = tostring(desc.SafeGridIndex)
                    
                    local alreadyAdded = false
                    for _, existingRoom in ipairs(data.requiredRooms) do
                        if existingRoom == roomKey then
                            alreadyAdded = true
                            break
                        end
                    end
                    
                    if not alreadyAdded then
                        table.insert(data.requiredRooms, roomKey)
                    end
                end
            end
        end
        
        Isaac.DebugString(string.format("Challenge 2: Found %d special rooms to visit", #data.requiredRooms))
    end,

    OnNewRoom = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.VISIT_ALL_SPECIAL)
        local level = game:GetLevel()
        local room = game:GetRoom()
        
        local currentRoomDesc = level:GetCurrentRoomDesc()
        if not currentRoomDesc or not currentRoomDesc.Data then return end
        
        local roomType = currentRoomDesc.Data.Type
        local currentRoomKey = tostring(currentRoomDesc.SafeGridIndex)
        
        local isRequiredRoom = false
        for _, requiredKey in ipairs(data.requiredRooms) do
            if requiredKey == currentRoomKey then
                isRequiredRoom = true
                break
            end
        end
        
        if isRequiredRoom then
            data.visitedRooms[currentRoomKey] = true
            
            local visitedCount = 0
            for _ in pairs(data.visitedRooms) do
                visitedCount = visitedCount + 1
            end
            
            Isaac.DebugString(string.format("Visited %d/%d special rooms", visitedCount, #data.requiredRooms))
            
            if visitedCount >= #data.requiredRooms then
                DavidUtils.Complete(floor)
            end
        end
    end,

    OnRender = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.VISIT_ALL_SPECIAL)
        
        local visitedCount = 0
        for _ in pairs(data.visitedRooms) do
            visitedCount = visitedCount + 1
        end
        
        Isaac.RenderText(
            string.format("Visit All Special! (%d/%d)", visitedCount, #data.requiredRooms),
            80, 20, 1, 1, 0.3, 1
        )
    end,
})

------------------------------------------------------------
-- CHALLENGE 3: NO HEARTS (don't pick up any hearts)
------------------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.NO_HEARTS, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_HEARTS)
        data.failed = false
    end,

    OnPickupCollision = function(pickup, player, floor)
        local variant = pickup.Variant
        
        if variant == PickupVariant.PICKUP_HEART
            or variant == PickupVariant.PICKUP_SOUL
            or variant == PickupVariant.PICKUP_BLACK_HEART
            or variant == PickupVariant.PICKUP_ETERNAL_HEART
            or variant == PickupVariant.PICKUP_GOLDEN_HEART
            or variant == PickupVariant.PICKUP_BONE_HEART
            or variant == PickupVariant.PICKUP_ROTTEN_HEART then
            
            DavidUtils.Fail(player, floor)
            return false
        end
    end,

    OnRender = function(player, floor)
        Isaac.RenderText("Don't Pick Up Hearts!", 80, 20, 1, 0.3, 0.3, 1)
    end,
})

------------------------------------------------------------
-- CHALLENGE 4: NO SHOOT DELAY 
------------------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.NO_SHOOT_DELAY, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_SHOOT_DELAY)
        data.roomEnterTime = Game():GetFrameCount()
        data.delayFrames = 60  -- 2 seconds at 30 FPS
    end,

    OnNewRoom = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_SHOOT_DELAY)
        data.roomEnterTime = Game():GetFrameCount()
    end,

    OnFireTear = function(player, tear, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_SHOOT_DELAY)
        local elapsed = Game():GetFrameCount() - data.roomEnterTime
        
        local delayFrames = DavidChord:GetReducedDelay(floor)
        
        if elapsed < delayFrames then
            DavidUtils.Fail(player, floor)
        end
    end,

    OnInitLaser = function(player, laser, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_SHOOT_DELAY)
        local elapsed = Game():GetFrameCount() - data.roomEnterTime
        
        local delayFrames = DavidChord:GetReducedDelay(floor)
        
        if elapsed < delayFrames then
            DavidUtils.Fail(player, floor)
        end
    end,

    OnInitKnife = function(player, knife, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_SHOOT_DELAY)
        local elapsed = Game():GetFrameCount() - data.roomEnterTime
        
        local delayFrames = DavidChord:GetReducedDelay(floor)
        
        if elapsed < delayFrames then
            DavidUtils.Fail(player, floor)
        end
    end,

    OnRender = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_SHOOT_DELAY)
        local elapsed = Game():GetFrameCount() - data.roomEnterTime
        
        local delayFrames = DavidChord:GetReducedDelay(floor)
        local chordData = GetChordData(floor)
        
        local remaining = math.max(0, delayFrames - elapsed)
        local seconds = remaining / 30
        
        if remaining > 0 then
            Isaac.RenderText(
                string.format("Don't Shoot! %.1fs", seconds),
                80, 20, 1, 0.3, 0.3, 1
            )
        else
            local activeText = ""
            if chordData and chordData.disabledActive and chordData.disabledRooms then
                activeText = string.format(" [DISABLED: %d rooms]", chordData.disabledRooms)
            end
            Isaac.RenderText("No Shoot Delay" .. activeText, 80, 20, 0.3, 1, 0.3, 1)
        end
    end,
})

------------------------------------------------------------
-- CHALLENGE 5: NO RESOURCES (keys, bombs, coins)
------------------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.NO_RESOURCES, {
    OnStart = function(floor)
        local player = Isaac.GetPlayer(0)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_RESOURCES)
        data.startKeys = player:GetNumKeys()
        data.startBombs = player:GetNumBombs()
        data.startCoins = player:GetNumCoins()

        data.hasGoldenBomb = player:HasGoldenBomb()
        data.hasGoldenKey = player:HasGoldenKey()
    end,

    OnUpdate = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_RESOURCES)
        
        local currentGoldenBomb = player:HasGoldenBomb()
        local currentGoldenKey = player:HasGoldenKey()
        
        local normalKeys = player:GetNumKeys()
        local normalBombs = player:GetNumBombs()
        
        if currentGoldenKey or data.hasGoldenKey then
        else
            if normalKeys < data.startKeys then
                DavidUtils.Fail(player, floor)
                return
            end
        end
        
        if currentGoldenBomb or data.hasGoldenBomb then
        else
            if normalBombs < data.startBombs then
                DavidUtils.Fail(player, floor)
                return
            end
        end
        
        if player:GetNumCoins() < data.startCoins then
            DavidUtils.Fail(player, floor)
            return
        end
        
        -- Update tracked amounts if resources increased
        data.startKeys = math.max(data.startKeys, normalKeys)
        data.startBombs = math.max(data.startBombs, normalBombs)
        data.startCoins = math.max(data.startCoins, player:GetNumCoins())
        
        if currentGoldenBomb then
            data.hasGoldenBomb = true
        end
        if currentGoldenKey then
            data.hasGoldenKey = true
        end
    end,

    OnRender = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_RESOURCES)
        local text = "Don't Use Resources!"
        
        if data.hasGoldenKey or player:HasGoldenKey() then
            text = text .. " [Golden Key OK]"
        end
        if data.hasGoldenBomb or player:HasGoldenBomb() then
            text = text .. " [Golden Bomb OK]"
        end
        
        Isaac.RenderText(text, 80, 20, 1, 1, 0.3, 1)
    end,
})

------------------------------------------------------------
-- CHALLENGE 6: NO HIT + CHAMPION CHANCE DOUBLED 
------------------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.NO_HIT_CHAMPIONS, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_HIT_CHAMPIONS)
        data.failed = false
    end,

    OnPlayerDamage = function(player, floor, amount, flags, source)
        local chordData = GetChordData(floor)
        if chordData and chordData.mantleActive then
            return
        end
        DavidUtils.Fail(player, floor)
    end
})

-- Double champion chance
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if game:IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    
    local floor = game:GetLevel():GetStage()
    local variant = DavidUtils.GetVariant(floor)
    
    if variant == mod.CHALLENGES.NO_HIT_CHAMPIONS then
        if not npc:IsChampion() and math.random() < 0.15 then
            npc:MakeChampion(npc:GetDropRNG():Next(), -1)
        end
    end
end)

------------------------------------------------------------
-- CHALLENGE 7: DON'T LEAVE ROOMS UNCLEARED
------------------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.CLEAR_ALL_ROOMS, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.CLEAR_ALL_ROOMS)
        data.visitedRooms = {}
        data.failed = false
    end,

    OnNewRoom = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.CLEAR_ALL_ROOMS)
        local level = game:GetLevel()
        local room = game:GetRoom()
        local roomIndex = level:GetCurrentRoomIndex()
        
        -- Check if we left a room uncleared
        for visitedIndex, wasCleared in pairs(data.visitedRooms) do
            if visitedIndex ~= roomIndex and not wasCleared then
                -- Check if that room is now cleared
                local desc = level:GetRoomByIdx(visitedIndex)
                if desc and not desc.Clear then
                    -- Left a room uncleared!
                    DavidUtils.Fail(player, floor)
                    return
                end
            end
        end
        
        -- Mark current room as visited
        data.visitedRooms[roomIndex] = room:IsClear()
    end,

    OnRender = function(player, floor)
        Isaac.RenderText("Clear All Rooms!", 80, 20, 1, 1, 0.3, 1)
    end,
})

-- Update room cleared status
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
    if game:IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    
    local floor = game:GetLevel():GetStage()
    local variant = DavidUtils.GetVariant(floor)
    
    if variant == mod.CHALLENGES.CLEAR_ALL_ROOMS then
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.CLEAR_ALL_ROOMS)
        local level = game:GetLevel()
        local roomIndex = level:GetCurrentRoomIndex()
        
        -- Mark this room as cleared
        data.visitedRooms[roomIndex] = true
    end
end)

------------------------------------------------------------
-- CHALLENGE 8: TAKE ALL PEDESTALS (NO REROLLING)
------------------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.TAKE_ALL_PEDESTALS, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.TAKE_ALL_PEDESTALS)
        data.pedestalsOnFloor = {}
        data.pedestalsTaken = {}
        data.rerolled = false
        
        -- Scan for all pedestals on the floor
        local level = game:GetLevel()
        for i = 0, level:GetRoomCount() - 1 do
            local roomDesc = level:GetRoomByIdx(i)
            if roomDesc and roomDesc.Data then
                local roomType = roomDesc.Data.Type
                
                -- Skip devil rooms and ultra secret rooms
                if roomType ~= RoomType.ROOM_DEVIL and roomType ~= RoomType.ROOM_ULTRA_SECRET then
                    -- We'll track pedestals as we encounter them
                end
            end
        end
    end,

    OnNewRoom = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.TAKE_ALL_PEDESTALS)
        local room = game:GetRoom()
        local roomType = room:GetType()
        
        -- Skip devil rooms and ultra secret rooms
        if roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_ULTRA_SECRET then
            return
        end
        
        -- Track pedestals in this room
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PICKUP then
                local pickup = entity:ToPickup()
                if pickup and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                    local key = tostring(entity.InitSeed)
                    if not data.pedestalsOnFloor[key] then
                        data.pedestalsOnFloor[key] = {
                            subType = pickup.SubType,
                            taken = false
                        }
                    end
                end
            end
        end
    end,

    OnRender = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.TAKE_ALL_PEDESTALS)
        
        if data.rerolled then
            Isaac.RenderText("Take All Pedestals! (REROLLED!)", 80, 20, 1, 0.3, 0.3, 1)
            return
        end
        
        local totalPedestals = 0
        local takenPedestals = 0
        for _, pedestal in pairs(data.pedestalsOnFloor) do
            totalPedestals = totalPedestals + 1
            if pedestal.taken then
                takenPedestals = takenPedestals + 1
            end
        end
        
        Isaac.RenderText(
            string.format("Take All Pedestals! (%d/%d)", takenPedestals, totalPedestals),
            80, 20, 1, 1, 0.3, 1
        )
    end,
})

-- Track pedestal collection and rerolls
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if game:IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
    
    local floor = game:GetLevel():GetStage()
    local variant = DavidUtils.GetVariant(floor)
    
    if variant == mod.CHALLENGES.TAKE_ALL_PEDESTALS then
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.TAKE_ALL_PEDESTALS)
        local key = tostring(pickup.InitSeed)
        local room = game:GetRoom()
        local roomType = room:GetType()
        
        -- Skip devil and ultra secret rooms
        if roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_ULTRA_SECRET then
            return
        end
        
        -- Track if pedestal was taken
        if data.pedestalsOnFloor[key] then
            if pickup:IsShopItem() then
                -- Only count as taken if actually purchased (price = 0)
                if pickup.Price == 0 and not pickup:CanReroll() then
                    data.pedestalsOnFloor[key].taken = true
                end
            else
                -- Free pedestal - check if it's gone
                if not pickup:CanReroll() then
                    data.pedestalsOnFloor[key].taken = true
                end
            end
            
            -- Detect reroll (subType changed)
            if data.pedestalsOnFloor[key].subType ~= pickup.SubType then
                data.rerolled = true
                local player = Isaac.GetPlayer(0)
                DavidUtils.Fail(player, floor)
            end
        end
    end
end)

-- Complete challenge when leaving floor if all pedestals taken
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function()
    if game:IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    
    local floor = game:GetLevel():GetStage()
    local variant = DavidUtils.GetVariant(floor)
    
    if variant == mod.CHALLENGES.TAKE_ALL_PEDESTALS then
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.TAKE_ALL_PEDESTALS)
        
        if data.rerolled then
            return  -- Already failed
        end
        
        -- Check if all pedestals were taken
        local allTaken = true
        for _, pedestal in pairs(data.pedestalsOnFloor) do
            if not pedestal.taken then
                allTaken = false
                break
            end
        end
        
        if not allTaken then
            local player = Isaac.GetPlayer(0)
            DavidUtils.Fail(player, floor)
        end
    end
end)