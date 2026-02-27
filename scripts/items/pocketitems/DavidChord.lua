local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local DavidChord = {}

------------------------------------------------------------
-- MODE DETECTION
------------------------------------------------------------
local function IsGreedMode()
    return game:IsGreedMode()
end

------------------------------------------------------------
-- NORMAL MODE DATA STRUCTURE
------------------------------------------------------------
local function GetNormalChordData(floor)
    local save = mod.SaveManager.GetRunSave()
    if not save then return nil end
    save.DavidChordData = save.DavidChordData or {}
    local key = "floor_" .. tostring(floor)
    save.DavidChordData[key] = save.DavidChordData[key] or {
        used = false,
        effect0Data = nil,
        frozenTime = nil,
        frozenRoomIndex = nil,
        disabledRooms = 0,
        disabledActive = false,
        mantleActive = false,
        treasureMapActive = false,
        treasureMapEndTime = 0,
    }
    return save.DavidChordData[key]
end

------------------------------------------------------------
-- GREED MODE DATA STRUCTURE
------------------------------------------------------------
local function GetGreedChordData(floor)
    local save = mod.SaveManager.GetRunSave()
    if not save then return nil end
    save.DavidGreedChordData = save.DavidGreedChordData or {}
    local key = "floor_" .. tostring(floor)
    save.DavidGreedChordData[key] = save.DavidGreedChordData[key] or {
        mantleActive = false,
        nextShopItemFree = false,
        activeUseAllowed = false,
        coinBlockActive = false,
    }
    return save.DavidGreedChordData[key]
end

------------------------------------------------------------
-- MAIN USE CARD CALLBACK
------------------------------------------------------------
function DavidChord:UseCard(card, player, flags)
    if card ~= mod.Cards.DavidChord then return end
    if player:GetPlayerType() ~= mod.Players.David then return end
    
    local floor = game:GetLevel():GetStage()
    
    if IsGreedMode() then
        DavidChord:UseCardGreed(player, floor)
    else
        DavidChord:UseCardNormal(player, floor)
    end
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, DavidChord.UseCard)

------------------------------------------------------------
-- NORMAL MODE: ROUTER
------------------------------------------------------------
function DavidChord:UseCardNormal(player, floor)
    local variant = mod:GetDavidChallengeVariant(floor)
    
    if not mod:IsDavidChallengeActive(floor) then
        game:GetHUD():ShowItemText("No Challenge Active", "", false)
        return
    end
    
    local chordData = GetNormalChordData(floor)
    chordData.used = true
    
    if variant == mod.CHALLENGES.NO_ACTIVES then
        DavidChord:NormalEffect_Challenge0(player, floor)
    elseif variant == mod.CHALLENGES.FAST_BOSS then
        DavidChord:NormalEffect_Challenge1(player, floor)
    elseif variant == mod.CHALLENGES.VISIT_ALL_SPECIAL then
        DavidChord:NormalEffect_Challenge2(player, floor)
    elseif variant == mod.CHALLENGES.NO_HEARTS then
        DavidChord:NormalEffect_Challenge3(player, floor)
    elseif variant == mod.CHALLENGES.NO_SHOOT_DELAY then
        DavidChord:NormalEffect_Challenge4(player, floor)
    elseif variant == mod.CHALLENGES.NO_RESOURCES then
        DavidChord:NormalEffect_Challenge5(player, floor)
    elseif variant == mod.CHALLENGES.NO_HIT_CHAMPIONS then
        DavidChord:NormalEffect_Challenge6(player, floor)
    elseif variant == mod.CHALLENGES.CLEAR_ALL_ROOMS then
        DavidChord:NormalEffect_Challenge7(player, floor)
    elseif variant == mod.CHALLENGES.TAKE_ALL_PEDESTALS then
        DavidChord:NormalEffect_Challenge8(player, floor)
    end
    
    sfx:Play(SoundEffect.SOUND_HOLY, 1.5)
end

------------------------------------------------------------
-- NORMAL MODE: CHALLENGE EFFECTS
------------------------------------------------------------

-- Allow active use in this room
function DavidChord:NormalEffect_Challenge0(player, floor)
    local chordData = GetNormalChordData(floor)
    chordData.effect0Data = {
        allowActiveThisRoom = true,
        roomIndex = game:GetLevel():GetCurrentRoomIndex()
    }
    
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0,
        player.Position + Vector(0, 20), Vector.Zero, player)
    
    game:GetHUD():ShowItemText("Active Use Allowed!", "", false)
end

-- Challenge 1: Freeze timer in this room
function DavidChord:NormalEffect_Challenge1(player, floor)
    local chordData = GetNormalChordData(floor)
    if not chordData then return end
    
    chordData.frozenTime = game:GetFrameCount()
    chordData.frozenRoomIndex = game:GetLevel():GetCurrentRoomIndex()
    
    game:GetHUD():ShowItemText("Timer Frozen!", "", false)
end

-- Challenge 2: Count nearby special rooms as visited
function DavidChord:NormalEffect_Challenge2(player, floor)
    local challengeData = mod:GetChallengeData(floor, mod.CHALLENGES.VISIT_ALL_SPECIAL)
    if not challengeData then return end
    
    local level = game:GetLevel()
    local rooms = level:GetRooms()
    local currentRoom = level:GetCurrentRoomDesc()
    
    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if desc and desc.Data then
            local gridDist = math.abs(desc.SafeGridIndex - currentRoom.SafeGridIndex)
            
            if gridDist > 0 and gridDist <= 14 then
                local roomType = desc.Data.Type
                
                if roomType == RoomType.ROOM_TREASURE or roomType == RoomType.ROOM_SHOP
                    or roomType == RoomType.ROOM_ARCADE or roomType == RoomType.ROOM_LIBRARY
                    or roomType == RoomType.ROOM_CURSE or roomType == RoomType.ROOM_MINIBOSS
                    or roomType == RoomType.ROOM_CHALLENGE or roomType == RoomType.ROOM_SECRET
                    or roomType == RoomType.ROOM_SUPERSECRET then
                    
                    challengeData.visitedRooms[tostring(desc.SafeGridIndex)] = true
                end
            end
        end
    end
    
    game:GetHUD():ShowItemText("Nearby Rooms Counted!", "", false)
end

-- Challenge 3: Fully heal
function DavidChord:NormalEffect_Challenge3(player, floor)
    player:AddHearts(24)
    game:GetHUD():ShowItemText("Fully Healed!", "", false)
end

-- Challenge 4: Disable shoot delay for 3 hostile rooms
function DavidChord:NormalEffect_Challenge4(player, floor)
    local chordData = GetNormalChordData(floor)
    chordData.disabledRooms = 3
    chordData.disabledActive = true
    
    game:GetHUD():ShowItemText("Delay Disabled! (3 rooms)", "", false)
end

-- Challenge 5: Open all doors
function DavidChord:NormalEffect_Challenge5(player, floor)
    local room = game:GetRoom()
    
    -- Open and unlock all doors
    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = room:GetDoor(i)
        if door then
            door:TryUnlock(player, true)
            door:Open()
            
            if door:IsRoomType(RoomType.ROOM_SECRET) or 
               door:IsRoomType(RoomType.ROOM_SUPERSECRET) then
                door:SetRoomTypes(door.TargetRoomType, door.TargetRoomType)
                door:Open()
            end
        end
    end
    
    -- Force all doors to be in open state
    Isaac.CreateTimer(function()
        for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
            local door = room:GetDoor(i)
            if door and not door:IsOpen() then
                door:Open()
            end
        end
    end, 1, 1, false)
    
    game:GetHUD():ShowItemText("All Doors Opened!", "", false)
end

-- Challenge 6: Give Holy Mantle for this room
function DavidChord:NormalEffect_Challenge6(player, floor)
    local chordData = GetNormalChordData(floor)
    chordData.mantleActive = true
    player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, false)
    game:GetHUD():ShowItemText("Holy Mantle Active!", "", false)
    sfx:Play(SoundEffect.SOUND_HOLY)
end

-- Challenge 7: Temporary Treasure Map (30 seconds)
function DavidChord:NormalEffect_Challenge7(player, floor)
    local chordData = GetNormalChordData(floor)
    chordData.treasureMapActive = true
    chordData.treasureMapEndTime = game:GetFrameCount() + 900
    player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_TREASURE_MAP, false)
    game:GetHUD():ShowItemText("Treasure Map (30s)!", "", false)
end

-- Challenge 8: Spawn extra pedestal
function DavidChord:NormalEffect_Challenge8(player, floor)
    local room = game:GetRoom()
    local pos = room:GetCenterPos() + Vector(40, 0)
    
    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        pos = ent.Position + Vector(60, 0)
        break
    end
    local itemPool = game:GetItemPool()
    local item = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, game:GetSeeds():GetStartSeed())
    
    local pedestal = Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        item,
        pos,
        Vector.Zero,
        nil
    )
    pedestal:GetData().DavidChordTemp = true
    pedestal:GetData().DavidChordFloor = floor
    
    game:GetHUD():ShowItemText("Extra Item Spawned!", "", false)
end

------------------------------------------------------------
-- GREED MODE: ROUTER
------------------------------------------------------------
function DavidChord:UseCardGreed(player, floor)
    local variant = mod:GetGreedChallengeVariant(floor)
    
    if not mod:IsGreedChallengeActive(floor) then
        game:GetHUD():ShowItemText("No Challenge Active", "", false)
        return
    end
    
    if variant == mod.GREED_CHALLENGES.FAST_WAVES then
        DavidChord:GreedEffect_Challenge0(player, floor)
    elseif variant == mod.GREED_CHALLENGES.NO_HIT_FLOOR then
        DavidChord:GreedEffect_Challenge1(player, floor)
    elseif variant == mod.GREED_CHALLENGES.LIMITED_SPENDING then
        DavidChord:GreedEffect_Challenge2(player, floor)
    elseif variant == mod.GREED_CHALLENGES.NO_SHOP then
        DavidChord:GreedEffect_Challenge3(player, floor)
    elseif variant == mod.GREED_CHALLENGES.NO_ACTIVES then
        DavidChord:GreedEffect_Challenge4(player, floor)
    elseif variant == mod.GREED_CHALLENGES.LOW_COINS then
        DavidChord:GreedEffect_LowCoins(player, floor)
    elseif variant == mod.GREED_CHALLENGES.FAST_DEVIL_WAVE then
        DavidChord:GreedEffect_Challenge6(player, floor)
    end
    
    sfx:Play(SoundEffect.SOUND_HOLY, 1.5)
end

------------------------------------------------------------
-- GREED MODE: CHALLENGE EFFECTS
------------------------------------------------------------

-- Challenge 0: Add 15 seconds to boss timer
function DavidChord:GreedEffect_Challenge0(player, floor)
    local challengeData = mod:GetGreedChallengeData(floor, mod.GREED_CHALLENGES.FAST_WAVES)
    if not challengeData then return end
    
    challengeData.bonusTime = (challengeData.bonusTime or 0) + 450  -- +15 seconds at 30fps
    
    game:GetHUD():ShowItemText("+15 Seconds", "", false)
end

-- Give Holy Mantle for this room
function DavidChord:GreedEffect_Challenge1(player, floor)
    local chordData = GetGreedChordData(floor)
    
    if not chordData.mantleActive then
        chordData.mantleActive = true
        player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, false)
        game:GetHUD():ShowItemText("Holy Mantle This Room!", "", false)
    else
        game:GetHUD():ShowItemText("Holy Mantle Already Active!", "", false)
    end
end

-- Raise spending cap from 15 to 25
function DavidChord:GreedEffect_Challenge2(player, floor)
    local challengeData = mod:GetGreedChallengeData(floor, mod.GREED_CHALLENGES.LIMITED_SPENDING)
    if not challengeData then return end

    challengeData.maxSpending = 25

    game:GetHUD():ShowItemText("Spending Cap: 25!", "", false)
end

-- Challenge 3: Spawn quality 0-2 pedestal
function DavidChord:GreedEffect_Challenge3(player, floor)
    local room = game:GetRoom()
    local pos = room:GetCenterPos()
    
    local itemPool = game:GetItemPool()
    local itemConfig = Isaac.GetItemConfig()
    local item = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, game:GetSeeds():GetStartSeed())
    local attempts = 0
    while attempts < 20 do
        local config = itemConfig:GetCollectible(item)
        if config and (config.Quality == 0 or config.Quality == 1 or config.Quality == 2) then
            break
        end
        item = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, game:GetSeeds():GetStartSeed())
        attempts = attempts + 1
    end
    
    Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        item,
        pos,
        Vector.Zero,
        nil
    )
    
    game:GetHUD():ShowItemText("Item Spawned!", "", false)
end

-- Challenge 4: Allow one active use
function DavidChord:GreedEffect_Challenge4(player, floor)
    local chordData = GetGreedChordData(floor)
    
    chordData.activeUseAllowed = true
    
    game:GetHUD():ShowItemText("Active Item Allowed!", "", false)
end

-- LOW_COINS: Block all coin pickups this room
function DavidChord:GreedEffect_LowCoins(player, floor)
    local chordData = GetGreedChordData(floor)

    if chordData.coinBlockActive then
        game:GetHUD():ShowItemText("Already Blocking Coins!", "", false)
        return
    end

    chordData.coinBlockActive = true
    game:GetHUD():ShowItemText("Coins Blocked This Room!", "", false)
end

-- Challenge 6: Add 15 seconds to devil wave timer
function DavidChord:GreedEffect_Challenge6(player, floor)
    local challengeData = mod:GetGreedChallengeData(floor, mod.GREED_CHALLENGES.FAST_DEVIL_WAVE)
    if not challengeData then return end
    
    challengeData.bonusTime = (challengeData.bonusTime or 0) + 450 
    
    game:GetHUD():ShowItemText("+15 Seconds", "", false)
end

------------------------------------------------------------
-- NORMAL MODE: Remove Treasure Map After 30 Seconds
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    local player = Isaac.GetPlayer(0)
    local floor = game:GetLevel():GetStage()
    local chordData = GetNormalChordData(floor)
    if chordData and chordData.treasureMapActive then
        if game:GetFrameCount() >= chordData.treasureMapEndTime then
            player:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_TREASURE_MAP, -1)
            chordData.treasureMapActive = false
        end
    end
end)

------------------------------------------------------------
-- NORMAL MODE: Remove Temporary Pedestals
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if IsGreedMode() then return end
    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        if ent:GetData().DavidChordTemp then
            ent:Remove()
        end
    end
end)

------------------------------------------------------------
-- NORMAL MODE: Clear mantle flag on new room
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    local floor = game:GetLevel():GetStage()
    local chordData = GetNormalChordData(floor)
    if chordData and chordData.mantleActive then
        chordData.mantleActive = false
    end
end)

------------------------------------------------------------
-- NORMAL MODE: Clear Effects on New Room
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    
    local floor = game:GetLevel():GetStage()
    local chordData = GetNormalChordData(floor)
    
    if chordData then
        -- Clear frozen timer when leaving room
        local currentRoom = game:GetLevel():GetCurrentRoomIndex()
        if chordData.frozenRoomIndex and currentRoom ~= chordData.frozenRoomIndex then
            chordData.frozenTime = nil
            chordData.frozenRoomIndex = nil
        end
        
        -- Clear mantle flag
        if chordData.mantleActive then
            chordData.mantleActive = false
        end
    end
end)

------------------------------------------------------------
-- GREED MODE: Block coin pickups LOW_COINS
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if not IsGreedMode() then return end
    if pickup.Variant ~= PickupVariant.PICKUP_COIN then return end
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    local chordData = GetGreedChordData(floor)
    if chordData and chordData.coinBlockActive then
        return true 
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if not IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

    local floor = game:GetLevel():GetStage()
    local chordData = GetGreedChordData(floor)
    if chordData and chordData.coinBlockActive then
        chordData.coinBlockActive = false
    end
end)

------------------------------------------------------------
-- GREED MODE: Free Shop Item (applied when entering the shop room)
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if not IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_SHOP then return end

    local floor = game:GetLevel():GetStage()
    local chordData = GetGreedChordData(floor)
    if not chordData or not chordData.nextShopItemFree then return end

    -- Find one purchasable shop item and make it free
    for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_SHOPITEM)) do
        if pickup.Price > 0 then
            pickup.Price = 0
            pickup.AutoUpdatePrice = false
            pickup:GetData().DavidChordFreeItem = true
            chordData.nextShopItemFree = false
            Isaac.DebugString("[DavidChord] Made shop item free (room enter)")
            break  -- Only one free item
        end
    end
end)

------------------------------------------------------------
-- Heal Broken Heart
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function()
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    
    local player = Isaac.GetPlayer(0)
    local floor = game:GetLevel():GetStage()
    local save = mod.SaveManager.GetRunSave()
    
    if IsGreedMode() then
        local floorState = save.GreedFloorChallengeState and save.GreedFloorChallengeState["floor_" .. tostring(floor)]
        
        if floorState and floorState.completed and not floorState.healUsed then
            floorState.healUsed = true 
            if player:GetBrokenHearts() > 0 then
                player:AddBrokenHearts(-1)
                sfx:Play(SoundEffect.SOUND_VAMP_GULP)
                game:GetHUD():ShowItemText("Broken Heart Healed!", "", false)
            end
        end
    else
        local chordData = GetNormalChordData(floor)
        local floorState = save.FloorChallengeState and save.FloorChallengeState["floor_" .. tostring(floor)]
        
        if floorState and floorState.completed and chordData and not chordData.used then
            if player:GetBrokenHearts() > 0 then
                player:AddBrokenHearts(-1)
                sfx:Play(SoundEffect.SOUND_VAMP_GULP)
                game:GetHUD():ShowItemText("Broken Heart Healed!", "", false)
            end
        end
    end
end)

------------------------------------------------------------
-- HELPER FUNCTIONS FOR CHALLENGES
------------------------------------------------------------

function DavidChord:GetReducedDelay(floor)
    if IsGreedMode() then return 60 end
    
    local chordData = GetNormalChordData(floor)
    if chordData and chordData.disabledActive then
        return 0 
    end
    return 60
end

-- Get timer adjustment for frozen time 
function DavidChord:GetTimerAdjustment(floor)
    if IsGreedMode() then return 0 end
    
    local chordData = GetNormalChordData(floor)
    if not chordData then return 0 end
    
    local currentRoom = game:GetLevel():GetCurrentRoomIndex()
    
    if chordData.frozenRoomIndex and currentRoom == chordData.frozenRoomIndex then
        local frozenDuration = game:GetFrameCount() - chordData.frozenTime
        return frozenDuration
    end
    
    return 0
end


------------------------------------------------------------
-- EID
------------------------------------------------------------

if EID then
    local normalChallengeDesc = {
        [0] = "Allows you to use your active item in this room",
        [1] = "{{Timer}} Freezes the challenge timer while in this room",
        [2] = "Counts nearby special rooms as visited",
        [3] = "{{Heart}} Fully heals you",
        [4] = "Disables the shoot delay for the next 3 hostile rooms",
        [5] = "{{Key}} Opens all doors in the current room",
        [6] = "Gives you Holy Mantle for this room",
        [7] = "Gives Treasure Map effect for 30 seconds",
        [8] = "Spawns an extra pedestal (disappears on room change)",
    }
    
    local greedChallengeDesc = {
        [0] = "Adds 15 seconds to the boss timer",
        [1] = "Gives you Holy Mantle for this room",
        [2] = "{{Coin}} Raises spending cap from 15 to 25",
        [3] = "Spawns a quality 0-2 item pedestal",
        [4] = "Allows you to use your active item once",
        [5] = "Blocks coin pickups for this room",
        [6] = "Adds 15 seconds to the devil wave timer",
    }

    EID:addDescriptionModifier("David's Chord Dynamic", function(descObj)
        return descObj.ObjType == EntityType.ENTITY_PICKUP
            and descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD
            and descObj.ObjSubType == mod.Cards.DavidChord
    end, function(descObj)
        local level = game:GetLevel()
        local floor = level:GetStage()
        
        local isGreed = IsGreedMode()
        
        local save = mod.SaveManager.GetRunSave()
        if not save then
            descObj.Description = "{{Warning}} No active challenge"
            return descObj
        end
        
        local stateKey = isGreed and "GreedFloorChallengeState" or "FloorChallengeState"
        local floorKey = "floor_" .. tostring(floor)
        local floorState = save[stateKey] and save[stateKey][floorKey]
        
        if not floorState then
            descObj.Description = "{{Warning}} No active challenge"
            return descObj
        end
        
        if floorState.completed then
            descObj.Description = "{{Checkmark}} Challenge already completed"
            return descObj
        end
        
        if floorState.failed then
            descObj.Description = "Challenge already failed"
            return descObj
        end
        
        if not floorState.active then
            descObj.Description = "{{Warning}} No active challenge"
            return descObj
        end
        
        local variant = floorState.variant
        local challengeTable = isGreed and greedChallengeDesc or normalChallengeDesc
        local effectDesc = challengeTable[variant] or "Unknown challenge effect"
        
        local chordKey = isGreed and "DavidGreedChordData" or "DavidChordData"
        local chordData = save[chordKey] and save[chordKey][floorKey]
        local alreadyUsed = false
        
        if isGreed then
            alreadyUsed = false 
        else
            alreadyUsed = chordData and chordData.used
        end
        
        if alreadyUsed then
            descObj.Description = "Already used this floor!#" .. 
                                  effectDesc .. " {{ColorGray}}(already applied){{CR}}"
        else
            descObj.Description = effectDesc .. "#Completing a challenge without using David's chord heals a broken heart"
        end
        
        return descObj
    end)
end

return DavidChord