local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local DavidChord = {}

local SPRITE_AURA = "gfx/characters/313_holymantle.anm2"

------------------------------------------------------------
-- MODE DETECTION
------------------------------------------------------------
local function IsGreedMode()
    return game:IsGreedMode()
end

------------------------------------------------------------
-- NORMAL MODE DATA
------------------------------------------------------------
local function GetNormalChordData(floor)
    local save = mod.SaveManager.GetRunSave()
    if not save then return nil end
    
    save.DavidChordData = save.DavidChordData or {}
    
    local key = "floor_" .. tostring(floor)
    save.DavidChordData[key] = save.DavidChordData[key] or {
        used = false,
        effect0Data = nil,
        -- Holy Mantle data
        mantleActive = false,
        mantleAura = nil,
        mantleGlow = nil,
    }
    
    return save.DavidChordData[key]
end

------------------------------------------------------------
-- GREED MODE DATA
------------------------------------------------------------
local function GetGreedChordData(floor)
    local save = mod.SaveManager.GetRunSave()
    if not save then return nil end
    
    save.DavidGreedChordData = save.DavidGreedChordData or {}
    
    local key = "floor_" .. tostring(floor)
    save.DavidGreedChordData[key] = save.DavidGreedChordData[key] or {
        effect1WaveProtection = false,
        effect1WaveNumber = nil,
        effect2FreeItemUsed = false,
        effect4ActiveUsed = false,
        -- Holy Mantle data
        mantleActive = false,
        mantleAura = nil,
        mantleGlow = nil,
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
-- NORMAL MODE IMPLEMENTATION
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
    end
    
    sfx:Play(SoundEffect.SOUND_HOLY, 1.5)
end

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

function DavidChord:NormalEffect_Challenge1(player, floor)
    local chordData = GetNormalChordData(floor)
    if not chordData then return end

    chordData.frozenTime = game:GetFrameCount()
    chordData.frozenRoomIndex = game:GetLevel():GetCurrentRoomIndex()
    
    game:GetHUD():ShowItemText("Timer Frozen!", "", false)
end

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

function DavidChord:NormalEffect_Challenge3(player, floor)
    local brokenHearts = player:GetBrokenHearts()
    for i = 1, brokenHearts do
        player:AddBrokenHearts(-1)
    end
    
    player:AddHearts(24)
    game:GetHUD():ShowItemText("Fully Healed!", "", false)
end

function DavidChord:NormalEffect_Challenge4(player, floor)
    local chordData = GetNormalChordData(floor)
    chordData.disabledRooms = 3
    chordData.disabledActive = true
    
    game:GetHUD():ShowItemText("Delay Disabled! (3 rooms)", "", false)
end

function DavidChord:NormalEffect_Challenge5(player, floor)
    local room = game:GetRoom()
    
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
    
    Isaac.CreateTimer(function()
        for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
            local door = room:GetDoor(i)
            if door and not door:IsOpen() then
                door:Open()
            end
        end
    end, 5, 0, false) 
    
    game:GetHUD():ShowItemText("All Doors Opened!", "", false)
    sfx:Play(SoundEffect.SOUND_DOOR_HEAVY_OPEN)
end

function DavidChord:NormalEffect_Challenge6(player, floor)
    local chordData = GetNormalChordData(floor)
    
    chordData.mantleActive = true
    
    if not chordData.mantleAura then
        local s = Sprite()
        s:Load(SPRITE_AURA, true)
        s:Play("Shimmer")
        chordData.mantleAura = s
    end

    if not chordData.mantleGlow then
        local s = Sprite()
        s:Load(SPRITE_AURA, true)
        s:Play("HeadDown")
        chordData.mantleGlow = s
    end
    
    game:GetHUD():ShowItemText("Holy Mantle Active!", "", false)
    sfx:Play(SoundEffect.SOUND_VAMP_GULP)
end

------------------------------------------------------------
-- GREED MODE IMPLEMENTATION
------------------------------------------------------------
function DavidChord:UseCardGreed(player, floor)
    local variant = mod:GetGreedDavidChallengeVariant(floor)
    
    if not mod:IsGreedDavidChallengeActive(floor) then
        game:GetHUD():ShowItemText("No Challenge Active", "", false)
        return
    end
    
    if variant == mod.GREED_CHALLENGES.FAST_WAVES then
        DavidChord:GreedEffect_Challenge0(player, floor)
    elseif variant == mod.GREED_CHALLENGES.NO_HIT_WAVE then
        DavidChord:GreedEffect_Challenge1(player, floor)
    elseif variant == mod.GREED_CHALLENGES.FREE_SHOP_ITEM then
        DavidChord:GreedEffect_Challenge2(player, floor)
    elseif variant == mod.GREED_CHALLENGES.RESOURCE_LIMIT then
        DavidChord:GreedEffect_Challenge3(player, floor)
    elseif variant == mod.GREED_CHALLENGES.ACTIVE_ONLY_ONCE then
        DavidChord:GreedEffect_Challenge4(player, floor)
    end
    
    sfx:Play(SoundEffect.SOUND_HOLY, 1.5)
end

-- GREED MODE EFFECTS 
function DavidChord:GreedEffect_Challenge0(player, floor)
    local challengeData = mod:GetGreedChallengeData(floor, mod.GREED_CHALLENGES.FAST_WAVES)
    if not challengeData then return end
    
    challengeData.bonusTime = (challengeData.bonusTime or 0) + 300 
    
    game:GetHUD():ShowItemText("+10 Seconds", "", false)
end

function DavidChord:GreedEffect_Challenge1(player, floor)
    local chordData = GetGreedChordData(floor)
    local challengeData = mod:GetGreedChallengeData(floor, mod.GREED_CHALLENGES.NO_HIT_WAVE)
    
    if not challengeData then return end
    
    local waveNumber = challengeData.currentWave or 1
    
    chordData.effect1WaveProtection = true
    chordData.effect1WaveNumber = waveNumber
    chordData.mantleActive = true

    if not chordData.mantleAura then
        local s = Sprite()
        s:Load(SPRITE_AURA, true)
        s:Play("Shimmer")
        chordData.mantleAura = s
    end
    
    if not chordData.mantleGlow then
        local s = Sprite()
        s:Load(SPRITE_AURA, true)
        s:Play("HeadDown")
        chordData.mantleGlow = s
    end
    
    game:GetHUD():ShowItemText("Holy Mantle This Wave!", "", false)
end

function DavidChord:GreedEffect_Challenge2(player, floor)
    local chordData = GetGreedChordData(floor)
    
    chordData.effect2FreeItemActive = true
    chordData.effect2FreeItemUsed = false
    
    game:GetHUD():ShowItemText("Next Shop Item Free!", "", false)
end

function DavidChord:GreedEffect_Challenge3(player, floor)
    player:AddCoins(5)
    player:AddBombs(2)
    player:AddKeys(2)
    
    game:GetHUD():ShowItemText("Resources Refilled!", "", false)
end

function DavidChord:GreedEffect_Challenge4(player, floor)
    local chordData = GetGreedChordData(floor)
    
    chordData.effect4ActiveAllowed = true
    chordData.effect4ActiveUsed = false
    
    game:GetHUD():ShowItemText("Active Item Allowed!", "", false)
end

------------------------------------------------------------
-- NORMAL MODE: HOLY MANTLE DAMAGE PREVENTION
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source)
    if IsGreedMode() then return end
    
    local player = entity:ToPlayer()
    if not player or player:GetPlayerType() ~= mod.Players.David then return end
    
    local floor = game:GetLevel():GetStage()
    local chordData = GetNormalChordData(floor)
    
    if not chordData or not chordData.mantleActive then return end
    if player:HasInvincibility() then return end
    if (flags & DamageFlag.DAMAGE_RED_HEARTS) ~= 0 then return end
    
    chordData.mantleActive = false
    chordData.mantleAura = nil
    chordData.mantleGlow = nil
    
    local breakFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 11, player.Position, Vector.Zero, player)
    breakFX:ToEffect():FollowParent(player)
    
    game:GetHUD():ShowItemText("Mantle Broken!", "", false)
    sfx:Play(SoundEffect.SOUND_SHELLGAME)
    
    player:SetMinDamageCooldown(50)
    
    return false
end, EntityType.ENTITY_PLAYER)

------------------------------------------------------------
-- GREED MODE: HOLY MANTLE 
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source)
    if not IsGreedMode() then return end
    
    local player = entity:ToPlayer()
    if not player or player:GetPlayerType() ~= mod.Players.David then return end
    
    local floor = game:GetLevel():GetStage()
    local chordData = GetGreedChordData(floor)
    
    if not chordData or not chordData.effect1WaveProtection then return end
    if player:HasInvincibility() then return end
    if (flags & DamageFlag.DAMAGE_RED_HEARTS) ~= 0 then return end
    
    local challengeData = mod:GetGreedChallengeData(floor, mod.GREED_CHALLENGES.NO_HIT_WAVE)
    if not challengeData then return end
    
    local currentWave = challengeData.currentWave or 1
    
    if chordData.effect1WaveNumber == currentWave then
        chordData.effect1WaveProtection = false
        chordData.mantleActive = false
        chordData.mantleAura = nil
        chordData.mantleGlow = nil
        
        local breakFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 11, player.Position, Vector.Zero, player)
        breakFX:ToEffect():FollowParent(player)
        
        game:GetHUD():ShowItemText("Mantle Broken!", "", false)
        sfx:Play(SoundEffect.SOUND_SHELLGAME)
        
        player:SetMinDamageCooldown(50)

        return false
    end
end, EntityType.ENTITY_PLAYER)

------------------------------------------------------------
-- RENDER HOLY MANTLE
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    
    local player = Isaac.GetPlayer(0)
    local floor = game:GetLevel():GetStage()
    local chordData = IsGreedMode() and GetGreedChordData(floor) or GetNormalChordData(floor)
    
    if not chordData then return end
    
    if chordData.mantleActive and chordData.mantleAura and chordData.mantleGlow then
        local pos = Isaac.WorldToScreen(player.Position) - game.ScreenShakeOffset
        
        chordData.mantleAura:Update()
        chordData.mantleAura:RenderLayer(0, pos)
        
        chordData.mantleGlow:Update()
        chordData.mantleGlow:RenderLayer(1, pos)
    end
end)

------------------------------------------------------------
-- GREED MODE: FREE ITEM PICKUP
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if not IsGreedMode() then return end
    
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= mod.Players.David then return end
    
    local floor = game:GetLevel():GetStage()
    local chordData = GetGreedChordData(floor)
    
    if not chordData or not chordData.effect2FreeItemActive then return end
    if chordData.effect2FreeItemUsed then return end
    
    if pickup.Price > 0 then
        pickup.Price = 0
        pickup.AutoUpdatePrice = false
        chordData.effect2FreeItemUsed = true
        chordData.effect2FreeItemActive = false
        
        sfx:Play(SoundEffect.SOUND_THUMBSUP)
    end
end)

------------------------------------------------------------
-- GREED MODE: TRACK ACTIVE ITEM USAGE
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemID, _, player)
    if not IsGreedMode() then return end
    if player:GetPlayerType() ~= mod.Players.David then return end
    
    local floor = game:GetLevel():GetStage()
    local chordData = GetGreedChordData(floor)
    
    if chordData and chordData.effect4ActiveAllowed and not chordData.effect4ActiveUsed then
        chordData.effect4ActiveUsed = true
        chordData.effect4ActiveAllowed = false
        game:GetHUD():ShowItemText("Active Used!", "", false)
    end
end)

------------------------------------------------------------
-- NORMAL MODE: ROOM TRACKING
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    
    local floor = game:GetLevel():GetStage()
    local chordData = GetNormalChordData(floor)
    local room = game:GetRoom()
    
    if chordData and chordData.effect0Data then
        local currentRoom = game:GetLevel():GetCurrentRoomIndex()
        if currentRoom ~= chordData.effect0Data.roomIndex then
            chordData.effect0Data = nil
        end
    end
    
    if chordData and chordData.disabledActive and chordData.disabledRooms then
        if room:GetType() == RoomType.ROOM_DEFAULT or 
           room:GetType() == RoomType.ROOM_BOSS or
           room:GetType() == RoomType.ROOM_MINIBOSS or
           room:GetType() == RoomType.ROOM_CHALLENGE or
           room:GetType() == RoomType.ROOM_CURSE then

            local hasEnemies = false
            for _, entity in ipairs(Isaac.GetRoomEntities()) do
                if entity:IsVulnerableEnemy() and entity:IsActiveEnemy(false) then
                    hasEnemies = true
                    break
                end
            end
            
            if hasEnemies then
                chordData.disabledRooms = chordData.disabledRooms - 1
                
                if chordData.disabledRooms <= 0 then
                    chordData.disabledActive = false
                    game:GetHUD():ShowItemText("Delay Restored", "", false)
                end
            end
        end
    end
    
    if chordData and chordData.frozenTime then
        local currentRoom = game:GetLevel():GetCurrentRoomIndex()
        if currentRoom ~= chordData.frozenRoomIndex then
            chordData.frozenTime = nil
            chordData.frozenRoomIndex = nil
        end
    end
    
    if chordData and chordData.mantleActive then
        chordData.mantleActive = false
        chordData.mantleAura = nil
        chordData.mantleGlow = nil
    end
end)

------------------------------------------------------------
-- GREED MODE: RESET ON NEW FLOOR 
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if not IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

end)

------------------------------------------------------------
-- HEAL BROKEN HEART IF COMPLETED WITHOUT USING IT
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function()
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    
    local player = Isaac.GetPlayer(0)
    local floor = game:GetLevel():GetStage()
    local save = mod.SaveManager.GetRunSave()
    
    if IsGreedMode() then
        local floorState = save.GreedFloorChallengeState and save.GreedFloorChallengeState["floor_" .. tostring(floor)]
        
        if floorState and floorState.completed then
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
-- HELPER FUNCTIONS 
------------------------------------------------------------
function DavidChord:GetReducedDelay(floor)
    if IsGreedMode() then return 60 end
    
    local chordData = GetNormalChordData(floor)
    if chordData and chordData.disabledActive then
        return 0
    end
    return 60
end

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

function DavidChord:IsActiveUseAllowed(floor)
    if not IsGreedMode() then return false end
    
    local chordData = GetGreedChordData(floor)
    if not chordData then return false end
    
    return chordData.effect4ActiveAllowed and not chordData.effect4ActiveUsed
end

function DavidChord:IsMantleActive(floor, currentWave)
    if not IsGreedMode() then return false end
    
    local chordData = GetGreedChordData(floor)
    if not chordData then return false end
    
    return chordData.effect1WaveProtection and chordData.effect1WaveNumber == currentWave
end

function DavidChord:GetBonusTime(floor)
    if not IsGreedMode() then return 0 end
    
    local challengeData = mod:GetGreedChallengeData(floor, mod.GREED_CHALLENGES.FAST_WAVES)
    if not challengeData then return 0 end
    
    return challengeData.bonusTime or 0
end

function DavidChord:OnWaveEnd(floor, waveNumber)
    if not IsGreedMode() then return end
    
    local chordData = GetGreedChordData(floor)
    if not chordData then return end
    
    if chordData.effect1WaveNumber == waveNumber then
        chordData.effect1WaveProtection = false
        chordData.mantleActive = false
        chordData.mantleAura = nil
        chordData.mantleGlow = nil
    end
end

return DavidChord