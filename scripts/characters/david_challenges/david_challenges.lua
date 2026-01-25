local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local DavidUtils = require("scripts.characters.david_challenges.david_challenges_utils")

-------------------------------------------------
-- CONSTANTS
-------------------------------------------------
mod.CHALLENGES = {
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
-- MISSED PLATE PENALTY (runs independently)
-------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

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
    if player:GetPlayerType() ~= mod.Players.David then return end
    
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
DavidUtils.Register(mod.CHALLENGES.NO_HIT_BOSS, {
    OnStart = function(floor)
        -- Swap boss room to custom Bloat room
        if game:GetLevel():GetStage() < LevelStage.STAGE3_1 then return end

        local level = game:GetLevel()
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
    end,

    OnPlayerDamage = function(player, floor, amount, flags, source)
        if game:GetRoom():GetType() == RoomType.ROOM_BOSS then
            DavidUtils.Fail(player, floor)
        end
    end,

    OnUpdate = function(player, floor)
        local room = game:GetRoom()
        if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() then
            DavidUtils.Complete(floor)
        end
    end,
})

-------------------------------------------------
-- CHALLENGE 2: ENTER ALL SPECIAL ROOMS (FIXED)
-------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.ENTER_SPECIALS, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.ENTER_SPECIALS)
        data.spawned = {}
        data.visited = {}
        data.completed = false
        
        -- Scan for special rooms at start
        local rooms = game:GetLevel():GetRooms()
        for i = 0, rooms.Size - 1 do
            local desc = rooms:Get(i)
            if desc and desc.Data and COUNTABLE_ROOMS[desc.Data.Type] 
               and desc.RoomIndex and desc.RoomIndex >= 0 then
                data.spawned[desc.RoomIndex] = true
            end
        end
        
        print("DEBUG [ENTER_SPECIALS]: Found " .. mod:CountKeys(data.spawned) .. " special rooms at start")
    end,

    OnNewRoom = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.ENTER_SPECIALS)
        if data.completed then return end
        
        -- Mark current room as visited if it's a countable room
        local roomIndex = game:GetLevel():GetCurrentRoomIndex()
        if data.spawned[roomIndex] then
            if not data.visited[roomIndex] then
                data.visited[roomIndex] = true
                print("DEBUG [ENTER_SPECIALS]: Visited room " .. roomIndex .. " (" .. mod:CountKeys(data.visited) .. "/" .. mod:CountKeys(data.spawned) .. ")")
            end
        end
        
        -- Check if all spawned rooms have been visited
        for idx in pairs(data.spawned) do
            if not data.visited[idx] then
                return -- Still have rooms to visit
            end
        end
        
        -- All rooms visited!
        data.completed = true
        DavidUtils.Complete(floor)
    end,

    OnLevelSelect = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.ENTER_SPECIALS)
        if not data.completed then
            DavidUtils.Fail(player, floor)
        end
    end,
    
    OnRender = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.ENTER_SPECIALS)
        local visited = mod:CountKeys(data.visited or {})
        local total = mod:CountKeys(data.spawned or {})
        Isaac.RenderText(
            "Special Rooms: " .. visited .. " / " .. total,
            60, 20, 1, 1, 1, 1
        )
    end,
})

-------------------------------------------------
-- CHALLENGE 3: NO HEARTS --WORKING
-------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.NO_HEARTS, {
    OnPickupCollision = function(pickup, player, floor)
        if pickup.Variant == PickupVariant.PICKUP_HEART then
            DavidUtils.Fail(player, floor)
            return true
        end
    end,
})

-------------------------------------------------
-- CHALLENGE 4: NO FIRE DELAY --WORKING
-------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.NO_FIRE_DELAY, {
    OnNewRoom = function(player, floor)
        local room = game:GetRoom()
        if room:IsClear() then return end
        
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_FIRE_DELAY)
        data.noFireTimer = 120
    end,

    OnUpdate = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_FIRE_DELAY)
        if not data.noFireTimer then return end

        data.noFireTimer = data.noFireTimer - 1
        
        if data.noFireTimer <= 0 then
            data.noFireTimer = nil
            
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
            DavidUtils.Fail(player, floor)
            data.noFireTimer = nil
        end
    end,
})

-------------------------------------------------
-- CHALLENGE 5: NO RESOURCES USE
-------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.NO_RESOURCES, {
    OnStart = function(floor)
        local player = Isaac.GetPlayer(0)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_RESOURCES)
        data.lastCoins = player:GetNumCoins()
        data.lastKeys = player:GetNumKeys()
        data.lastBombs = player:GetNumBombs()
    end,

    OnUpdate = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_RESOURCES)
        
        -- Check for regular resource usage
        if player:GetNumCoins() < data.lastCoins or 
           player:GetNumKeys() < data.lastKeys or 
           player:GetNumBombs() < data.lastBombs then
            DavidUtils.Fail(player, floor)
            return
        end

        data.lastCoins = player:GetNumCoins()
        data.lastKeys = player:GetNumKeys()
        data.lastBombs = player:GetNumBombs()
    end,
})

-- Detect golden bomb/key usage 
mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bomb)
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end
    
    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= mod.CHALLENGES.NO_RESOURCES then return end
    
    -- Check if it's a golden bomb
    if bomb.Variant == BombVariant.BOMB_GOLDEN then
        DavidUtils.Fail(player, floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end
    
    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= mod.CHALLENGES.NO_RESOURCES then return end
    
    local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_RESOURCES)
    
    -- Store current key count
    local currentKeys = player:GetNumKeys()
    if not data.lastKeyCheck then
        data.lastKeyCheck = currentKeys
        return
    end
    
    if currentKeys == data.lastKeyCheck and player:GetNumKeys() < data.lastKeys then
        -- Golden key was used
        DavidUtils.Fail(player, floor)
    end
    
    data.lastKeyCheck = currentKeys
end)

-------------------------------------------------
-- CHALLENGE 6: DON'T MISS MORE THAN 200 SHOTS (Need further testing)
-------------------------------------------------
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

DavidUtils.Register(mod.CHALLENGES.NO_MISS, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_MISS)
        data.shots = 0
        data.misses = 0
        data.pending = {}
    end,

    OnFireTear = function(player, tear, floor)
        if RoomHasValidTargets(player) then
            local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_MISS)
            data.shots = data.shots + 1
            table.insert(data.pending, {frames = 0, hit = false})
        end
    end,

    OnInitLaser = function(player, laser, floor)
        if RoomHasValidTargets(player) then
            local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_MISS)
            data.shots = data.shots + 1
            table.insert(data.pending, {frames = 0, hit = false})
        end
    end,

    OnInitKnife = function(player, knife, floor)
        if RoomHasValidTargets(player) then
            local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_MISS)
            data.shots = data.shots + 1
            table.insert(data.pending, {frames = 0, hit = false})
        end
    end,

    OnEntityDamage = function(entity, amount, flags, source, player, floor)
        if not source.Entity then return end
        if not IsValidTarget(entity, player) then return end

        local srcType = source.Entity.Type
        if srcType ~= EntityType.ENTITY_TEAR and 
           srcType ~= EntityType.ENTITY_LASER and 
           srcType ~= EntityType.ENTITY_KNIFE then
            return
        end

        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_MISS)
        for _, shot in ipairs(data.pending) do
            if not shot.hit then
                shot.hit = true
                break
            end
        end
    end,

    OnUpdate = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_MISS)
        
        for i = #data.pending, 1, -1 do
            local shot = data.pending[i]
            shot.frames = shot.frames + 1

            if shot.frames > 15 then
                if not shot.hit then
                    data.misses = data.misses + 1
                end
                table.remove(data.pending, i)
            end
        end

        if data.misses > 200 then
            DavidUtils.Fail(player, floor)
        end
    end,

    OnRender = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.NO_MISS)
        Isaac.RenderText(
            "Shots: " .. data.shots .. " | Misses: " .. data.misses .. "/200",
            60, 20, 1, 1, 1, 1
        )
    end,
})

-------------------------------------------------
-- CHALLENGE 7: NO HIT (CHAMPIONS) --WORKING
-------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.NO_HIT, {
    OnPlayerDamage = function(player, floor, amount, flags, source)
        DavidUtils.Fail(player, floor)
    end,
})

-- Champion spawning
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if not npc:IsActiveEnemy(false) or npc:IsBoss() then return end
    if game:GetRoom():GetFrameCount() > 1 then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= mod.CHALLENGES.NO_HIT then return end

    local rng = npc:GetDropRNG()
    if rng and rng:RandomFloat() < 0.30 then
        npc:MakeChampion(rng:RandomInt(25), -1)
    end
end)

-------------------------------------------------
-- CHALLENGE 8: COLLECT 10 DAVID'S CHORDS (FIXED)
-------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.COLLECT_CHORDS, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.COLLECT_CHORDS)
        data.collected = 0
        print("DEBUG [COLLECT_CHORDS]: Challenge started on floor " .. floor)
    end,

    OnNPCKill = function(npc, player, floor)
        if npc:IsBoss() then return end -- Bosses don't drop chords
        if not npc:IsVulnerableEnemy() then return end

        local rng = npc:GetDropRNG()
        if rng:RandomFloat() < 0.15 then
            print("DEBUG [COLLECT_CHORDS]: Spawning chord at " .. tostring(npc.Position))
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
    end,

    OnRender = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.COLLECT_CHORDS)
        Isaac.RenderText(
            "David's Chords: " .. data.collected .. " / 10",
            60, 20, 1, 1, 1, 1
        )
    end,
})

-- Chord pickup logic
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    local sprite = pickup:GetSprite()
    if sprite and not sprite:IsPlaying("Appear") then
        sprite:Play("Appear", true)
    end
    print("DEBUG [PICKUP_INIT]: David's Chord spawned")
end, mod.Entities.PICKUP_DavidChord.Var)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local sprite = pickup:GetSprite()
    if not sprite then return end
    
    if sprite:IsFinished("Appear") then
        sprite:Play("Idle", true)
    end

    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= mod.CHALLENGES.COLLECT_CHORDS then return end

    if pickup.Position:Distance(player.Position) < 20 then
        if not sprite:IsPlaying("Collect") then
            sprite:Play("Collect", true)
            sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK)
            
            local data = DavidUtils.GetData(floor, mod.CHALLENGES.COLLECT_CHORDS)
            data.collected = data.collected + 1
            
            print("DEBUG [COLLECT_CHORDS]: Collected chord #" .. data.collected)

            if data.collected >= 10 then
                DavidUtils.Complete(floor)
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
    if not player or player:GetPlayerType() ~= mod.Players.David then
        return true
    end
end, mod.Entities.PICKUP_DavidChord.Var)

-- Fail if boss dies without enough chords
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsBoss() then return end

    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= mod.CHALLENGES.COLLECT_CHORDS then return end

    local data = DavidUtils.GetData(floor, mod.CHALLENGES.COLLECT_CHORDS)
    if data.collected < 10 then
        DavidUtils.Fail(player, floor)
    end
end)

-------------------------------------------------
-- CHALLENGE 9: FAST BOSS (BEAT UNDER 4 MINUTES) --WORKING
-------------------------------------------------
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

DavidUtils.Register(mod.CHALLENGES.FAST_BOSS, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.FAST_BOSS)
        data.timer = 30 * 240 -- 4 minutes at 30fps
        
        local player = Isaac.GetPlayer(0)
        if MIND_STAGES[floor] then
            GiveTemporaryMind(player)
        else
            RemoveTemporaryMind(player)
        end
    end,

    OnUpdate = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.FAST_BOSS)
        if not data.timer then return end

        data.timer = data.timer - 1
        
        if data.timer <= 0 then
            data.timer = nil
            RemoveTemporaryMind(player)
            DavidUtils.Fail(player, floor)
            return
        end

        local room = game:GetRoom()
        if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() then
            data.timer = nil
            RemoveTemporaryMind(player)
            DavidUtils.Complete(floor)
        end
    end,

    OnRender = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.FAST_BOSS)
        if not data.timer then return end

        local seconds = math.floor(data.timer / 30)
        local minutes = math.floor(seconds / 60)
        local remainingSeconds = seconds % 60

        Isaac.RenderText(
            string.format("Time: %d:%02d", minutes, remainingSeconds),
            60, 20, 1, 1, 1, 1
        )
    end,

    OnCleanup = function(floor)
        local player = Isaac.GetPlayer(0)
        RemoveTemporaryMind(player)
    end,
})

-------------------------------------------------
-- CHALLENGE 10: DO NOT USE ACTIVE/CONSUMABLES --WORKING
-------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.NO_USE, {
    OnUseItem = function(player, floor, itemID)
        DavidUtils.Fail(player, floor)
    end,

    OnUseCard = function(player, floor, cardID)
        DavidUtils.Fail(player, floor)
    end,

    OnUsePill = function(player, floor, pillEffect)
        DavidUtils.Fail(player, floor)
    end,
})

-------------------------------------------------
-- CHALLENGE 11: KILL 20 ENEMIES WHILE STANDING STILL (FIXED)
-------------------------------------------------
DavidUtils.Register(mod.CHALLENGES.STILL_KILLS, {
    OnStart = function(floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.STILL_KILLS)
        data.isStill = false
        data.stillKills = 0
        data.lastPos = nil
        data.stillFrames = 0
        data.completed = false
    end,

    OnUpdate = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.STILL_KILLS)
        if data.completed then return end

        if not data.lastPos then
            data.lastPos = player.Position
            return
        end

        local distSq = player.Position:DistanceSquared(data.lastPos)

        if distSq <= 0.5 then
            data.stillFrames = data.stillFrames + 1
            
            if data.stillFrames >= 15 then
                data.isStill = true
            end
        else
            data.stillFrames = 0
            data.isStill = false
        end

        data.lastPos = player.Position
    end,

    OnNPCKill = function(npc, player, floor)
        if not npc:IsVulnerableEnemy() then return end
        if npc:IsBoss() then return end -- Don't count boss kills

        local data = DavidUtils.GetData(floor, mod.CHALLENGES.STILL_KILLS)
        if data.completed then return end
        if not data.isStill then 
            print("DEBUG [STILL_KILLS]: Enemy killed but player not standing still")
            return 
        end

        data.stillKills = data.stillKills + 1
        print("DEBUG [STILL_KILLS]: Still kill count: " .. data.stillKills)
        sfx:Play(SoundEffect.SOUND_POWERUP1)

        if data.stillKills >= 20 then
            data.completed = true
            DavidUtils.Complete(floor)
            game:GetHUD():ShowItemText("Standing Still Complete!")
        end
    end,

    OnRender = function(player, floor)
        local data = DavidUtils.GetData(floor, mod.CHALLENGES.STILL_KILLS)

        local kills = data.stillKills
        local counterText = "Still Kills: " .. kills .. " / 20"
        
        local r, g, b = 1, 1, 1
        if data.completed then
            r, g, b = 0, 1, 0
        end
        
        Isaac.RenderText(counterText, 60, 20, r, g, b, 1)

        if data.completed then
            Isaac.RenderText("COMPLETED", 60, 35, 0, 1, 0, 1)
        elseif data.isStill then
            Isaac.RenderText("STANDING STILL", 60, 35, 0, 1, 0, 1)
        else
            local progress = math.floor((data.stillFrames / 15) * 100)
            Isaac.RenderText("Hold still: " .. progress .. "%", 60, 35, 1, 1, 0, 0.6)
        end
    end,
})

-- Fail if boss dies without enough kills
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsBoss() then return end

    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    if not DavidUtils.IsActive(floor) then return end
    if DavidUtils.GetVariant(floor) ~= mod.CHALLENGES.STILL_KILLS then return end

    local data = DavidUtils.GetData(floor, mod.CHALLENGES.STILL_KILLS)
    if data.stillKills < 20 then
        DavidUtils.Fail(player, floor)
    end
end)
