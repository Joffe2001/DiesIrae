local mod = DiesIraeMod
local game = Game()

------------------------------------------------------------
-- SAVE DATA HELPERS
------------------------------------------------------------

local function GetFloorChallengeState()
    local save = mod.SaveManager.GetRunSave()
    if not save then return {} end

    save.FloorChallengeState = save.FloorChallengeState or {}
    return save.FloorChallengeState
end

local function GetFloorKey(floor)
    return "floor_" .. tostring(floor)
end

local function GetFloorState(floor)
    local allStates = GetFloorChallengeState()
    local key = GetFloorKey(floor)
    return allStates[key]
end

local function SetFloorState(floor, state)
    local allStates = GetFloorChallengeState()
    local key = GetFloorKey(floor)
    allStates[key] = state
end

------------------------------------------------------------
-- HANDLER REGISTRY
------------------------------------------------------------
local ChallengeHandlers = {
    OnStart          = {},
    OnUpdate         = {},
    OnNewRoom        = {},
    OnRender         = {},
    OnFail           = {},
    OnComplete       = {},
    OnCleanup        = {},
    OnEntityDamage   = {},
    OnPlayerDamage   = {},
    OnNPCKill        = {},
    OnPickupCollision = {},
    OnFireTear       = {},
    OnInitLaser      = {},
    OnInitKnife      = {},
    OnUseItem        = {},
    OnUseCard        = {},
    OnUsePill        = {},
    OnLevelSelect    = {},
}

------------------------------------------------------------
-- REGISTRATION
------------------------------------------------------------
function mod:RegisterDavidChallenge(variant, handlers)
    for k, f in pairs(handlers) do
        if ChallengeHandlers[k] then
            ChallengeHandlers[k][variant] = f
        else
            print("WARNING: Invalid challenge handler key:", k)
        end
    end
end

------------------------------------------------------------
-- STATE HELPERS
------------------------------------------------------------
function mod:GetActiveDavid()
    local player = Isaac.GetPlayer(0)
    if not player or player:GetPlayerType() ~= mod.Players.David then
        return nil
    end

    local floor = game:GetLevel():GetStage()
    local state = GetFloorState(floor)
    if not state or not state.active then
        return nil
    end

    return player, floor
end

function mod:GetChallengeData(floor, variant)
    local state = GetFloorState(floor)
    if not state then return nil end
    
    state.data = state.data or {}
    
    local variantKey = "var_" .. tostring(variant)
    state.data[variantKey] = state.data[variantKey] or {}
    
    return state.data[variantKey]
end

function mod:IsDavidChallengeActive(floor)
    local s = GetFloorState(floor)
    return s and s.active
end

function mod:GetDavidChallengeVariant(floor)
    local s = GetFloorState(floor)
    return s and s.variant
end

function mod:GetActiveChallengeState()
    local player, floor = mod:GetActiveDavid()
    if not player then return nil, nil, nil end
    
    local variant = mod:GetDavidChallengeVariant(floor)
    local state = GetFloorState(floor)
    
    return state, floor, variant, player
end

------------------------------------------------------------
-- BACKDROP SPAWNING
------------------------------------------------------------
local function SpawnChallengeBackdrop(variant)
    local room = game:GetRoom()
    
    local effect = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.POOF01,
        0,
        room:GetCenterPos() + Vector(-15, -40),
        Vector.Zero,
        nil
    )

    effect:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
    local spr = effect:GetSprite()
    spr:Load("gfx/grid/David_challenges/challenges.anm2", true)
    spr:Play("Idle", true)
    spr:SetFrame(variant)
    
    effect:GetData().IsChallengeBackdrop = true
    effect:GetData().ChallengeVariant = variant
    effect:GetData().ChallengeFloor = game:GetLevel():GetStage()
end

local function RestoreBackdropOnRoomEnter()
    local level = game:GetLevel()
    local currentFloor = level:GetStage()
    local roomIndex = level:GetCurrentRoomIndex()
    local startingRoom = level:GetStartingRoomIndex()
    
    if roomIndex ~= startingRoom then return end
    
    local state = GetFloorState(currentFloor)
    if not state or not state.active then return end
    
    for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT)) do
        local data = effect:GetData()
        if data.IsChallengeBackdrop and data.ChallengeFloor == currentFloor then
            return
        end
    end

    SpawnChallengeBackdrop(state.variant)
end

local function RemoveBackdropsWhenLeavingFloor()
    local currentFloor = game:GetLevel():GetStage()
    
    for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT)) do
        local data = effect:GetData()
        if data.IsChallengeBackdrop and data.ChallengeFloor then
            if data.ChallengeFloor ~= currentFloor then
                effect:Remove()
            end
        end
    end
end

------------------------------------------------------------
-- USED CHALLENGES TRACKING
------------------------------------------------------------
local function GetUsedChallenges()
    local save = mod.SaveManager.GetRunSave()
    if not save then return {} end
    
    save.UsedChallenges = save.UsedChallenges or {}
    return save.UsedChallenges
end

local function IsChallengeUsed(variant)
    local used = GetUsedChallenges()
    return used[variant] == true
end

local function MarkChallengeAsUsed(variant)
    local used = GetUsedChallenges()
    used[variant] = true
end

------------------------------------------------------------
-- START RANDOM CHALLENGE ON NEW FLOOR
------------------------------------------------------------
function mod:AutoStartRandomChallenge(floor)
    local level = game:GetLevel()
    local stage = level:GetStage()
    local stageType = level:GetStageType()
    
    if floor <= 1 then return end
    if level:IsAscent() then return end
    if stage > LevelStage.STAGE4_2 then return end
    if GetFloorState(floor) then return end
    
    local rng = RNG()
    local seed = game:GetSeeds():GetStartSeed()
    rng:SetSeed(seed + floor * 1000, 35)
    
    local availableChallenges = {}
    for i = 0, 6 do
        if not IsChallengeUsed(i) then
            table.insert(availableChallenges, i)
        end
    end
    
    if #availableChallenges == 0 then return end
    local variant = availableChallenges[rng:RandomInt(#availableChallenges) + 1]
    
    mod:StartDavidChallenge(floor, variant)
end

------------------------------------------------------------
-- START A NEW CHALLENGE
------------------------------------------------------------
function mod:StartDavidChallenge(floor, variant)
    if not variant then return end
    if mod:GetCompletedDavidChallengeCount() >= 10 then return end

    if GetFloorState(floor) then return end

    if IsChallengeUsed(variant) then return end

    SetFloorState(floor, {
        active = true,
        variant = variant,
        failed = false,
        completed = false,
        pendingReward = false,
        rewardSpawned = false,
        data = {},
    })

    MarkChallengeAsUsed(variant)

    local level = game:GetLevel()
    if level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
        SpawnChallengeBackdrop(variant)
    end

    if ChallengeHandlers.OnStart[variant] then
        ChallengeHandlers.OnStart[variant](floor)
    end
end

------------------------------------------------------------
-- FAIL CHALLENGE
------------------------------------------------------------
function mod:FailDavidChallenge(player, floor)
    local state = GetFloorState(floor)
    if not state or state.failed or state.completed then return end

    state.failed = true
    local variant = state.variant
    if ChallengeHandlers.OnFail[variant] then
        ChallengeHandlers.OnFail[variant](player, floor)
    end

    if ChallengeHandlers.OnCleanup[variant] then
        ChallengeHandlers.OnCleanup[variant](floor)
    end

    state.active = false
    player:AddBrokenHearts(2)
    game:GetHUD():ShowItemText("Challenge Failed!", "", false)
    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)
    player:AnimateSad()
end

------------------------------------------------------------
-- COMPLETE CHALLENGE
------------------------------------------------------------
function mod:CompleteDavidChallenge(floor)
    local state = GetFloorState(floor)
    if not state or state.completed or state.failed then return end

    local variant = state.variant
    if ChallengeHandlers.OnComplete[variant] then
        ChallengeHandlers.OnComplete[variant](floor)
    end

    if ChallengeHandlers.OnCleanup[variant] then
        ChallengeHandlers.OnCleanup[variant](floor)
    end

    state.active = false
    state.completed = true
    state.pendingReward = true
    
    mod:IncrementDavidChallengeCount()
    
    game:GetHUD():ShowItemText("Challenge Complete!", "", false)
    SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
end

------------------------------------------------------------
-- COMPLETION TRACKING
------------------------------------------------------------
function mod:GetCompletedDavidChallengeCount()
    local save = mod.SaveManager.GetRunSave()
    if not save then return 0 end
    
    save.DavidChallengesCompleted = save.DavidChallengesCompleted or 0
    return save.DavidChallengesCompleted
end

function mod:IncrementDavidChallengeCount()
    local save = mod.SaveManager.GetRunSave()
    if not save then return end
    
    save.DavidChallengesCompleted = (save.DavidChallengesCompleted or 0) + 1
end

------------------------------------------------------------
-- REWARD SPAWNING
------------------------------------------------------------
local function TrySpawnChallengeReward(player)
    if not player or player:GetPlayerType() ~= mod.Players.David then return end
    
    local level = game:GetLevel()
    local currentFloor = level:GetStage()
    local currentRoom = level:GetCurrentRoomIndex()
    local startingRoom = level:GetStartingRoomIndex()
    
    if currentRoom ~= startingRoom then return end
    
    local allStates = GetFloorChallengeState()
    for floorKey, state in pairs(allStates) do
        if state.pendingReward and not state.rewardSpawned then
            local completedFloor = tonumber(floorKey:match("%d+"))
            
            if completedFloor and currentFloor > completedFloor then
                -- Mark as spawned
                state.rewardSpawned = true
                state.pendingReward = false
                
                -- Spawn Harp String
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE,
                    mod.Items.HarpString,
                    game:GetRoom():GetCenterPos() + Vector(0, 40),
                    Vector.Zero,
                    player
                )
                
                game:GetHUD():ShowItemText("Challenge completed", "", false)
                SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                
                if player.AnimateHappy then
                    player:AnimateHappy()
                end
                
                return
            end
        end
    end
end

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------
local function WasBossDefeatedThisFloor()
    local level = game:GetLevel()
    local rooms = level:GetRooms()
    
    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if desc and desc.Data and desc.Data.Type == RoomType.ROOM_BOSS and desc.Clear then
            return true
        end
    end
    
    return false
end

------------------------------------------------------------
-- CANCEL CHALLENGE
------------------------------------------------------------
function mod:CancelDavidChallenge(floor)
    local state = GetFloorState(floor)
    if not state or state.failed or state.completed then return end

    local variant = state.variant
    if ChallengeHandlers.OnCleanup[variant] then
        ChallengeHandlers.OnCleanup[variant](floor)
    end

    state.active = false
    state.cancelled = true
    
end

------------------------------------------------------------
-- SAFE HANDLER CALLER
------------------------------------------------------------
local function SafeCallHandler(handlerName, variant, ...)
    local handler = ChallengeHandlers[handlerName]
    if not handler then return end
    
    local f = handler[variant]
    if not f then return end

    local success, err = pcall(f, ...)
    if not success then
        Isaac.DebugString("[David Challenges] Error in " .. handlerName .. " handler for variant " .. tostring(variant) .. ": " .. tostring(err))
        print("ERROR in challenge handler:", handlerName, variant, err)
    end
end

------------------------------------------------------------
-- CORE CALLBACK DISPATCHER
------------------------------------------------------------

-- AUTO-START CHALLENGE ON NEW LEVEL
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    RemoveBackdropsWhenLeavingFloor()
    
    local floor = game:GetLevel():GetStage()
    mod:AutoStartRandomChallenge(floor)
end)

-- LEVEL SELECT
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function()
    local state, floor, variant, player = mod:GetActiveChallengeState()
    if not state then return end

    SafeCallHandler("OnLevelSelect", variant, player, floor)

    if WasBossDefeatedThisFloor() then
        mod:CompleteDavidChallenge(floor)
    else
        mod:CancelDavidChallenge(floor)
    end
end)

-- NEW ROOM
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    TrySpawnChallengeReward(Isaac.GetPlayer(0))

    local player, floor = mod:GetActiveDavid()
    if not player then return end
    
    RestoreBackdropOnRoomEnter()

    local variant = mod:GetDavidChallengeVariant(floor)
    SafeCallHandler("OnNewRoom", variant, player, floor)
end)

-- UPDATE
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local state, floor, variant, player = mod:GetActiveChallengeState()
    if not state then return end

    SafeCallHandler("OnUpdate", variant, player, floor)
end)

-- RENDER
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local state, floor, variant, player = mod:GetActiveChallengeState()
    if not state then return end

    SafeCallHandler("OnRender", variant, player, floor)
end)

------------------------------------------------------------
-- SPECIAL EVENT DISPATCH
------------------------------------------------------------

-- PLAYER DAMAGE
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source)
    local player, floor = mod:GetActiveDavid()
    if not player then return end

    if entity:ToPlayer() and entity:ToPlayer():GetPlayerType() == mod.Players.David then
        local variant = mod:GetDavidChallengeVariant(floor)
        SafeCallHandler("OnPlayerDamage", variant, entity:ToPlayer(), floor, amount, flags, source)
    end

    local variant = mod:GetDavidChallengeVariant(floor)
    SafeCallHandler("OnEntityDamage", variant, entity, amount, flags, source, player, floor)
end)

-- NPC KILL
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    local player, floor = mod:GetActiveDavid()
    if not player then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    SafeCallHandler("OnNPCKill", variant, npc, player, floor)
end)

-- PICKUP COLLISION
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll)
    local player = coll:ToPlayer()
    if not player then return end
    if player:GetPlayerType() ~= mod.Players.David then return end

    local player2, floor = mod:GetActiveDavid()
    if not player2 then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    local f = ChallengeHandlers.OnPickupCollision[variant]
    if f then 
        local success, result = pcall(f, pickup, player, floor)
        if success then
            return result
        else
            Isaac.DebugString("[David Challenges] Error in OnPickupCollision: " .. tostring(result))
        end
    end
end)

-- FIRE TEAR
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local player, floor = mod:GetActiveDavid()
    if not player then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    SafeCallHandler("OnFireTear", variant, player, tear, floor)
end)

-- LASER INIT
mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, function(_, laser)
    local player, floor = mod:GetActiveDavid()
    if not player then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    SafeCallHandler("OnInitLaser", variant, player, laser, floor)
end)

-- KNIFE INIT
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_INIT, function(_, knife)
    local player, floor = mod:GetActiveDavid()
    if not player then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    SafeCallHandler("OnInitKnife", variant, player, knife, floor)
end)

-- USE ITEM
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemID, _, player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local p2, floor = mod:GetActiveDavid()
    if not p2 then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    SafeCallHandler("OnUseItem", variant, player, floor, itemID)
end)

-- USE CARD
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local p2, floor = mod:GetActiveDavid()
    if not p2 then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    SafeCallHandler("OnUseCard", variant, player, floor, cardID)
end)

-- USE PILL
mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, pillEffect, player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local p2, floor = mod:GetActiveDavid()
    if not p2 then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    SafeCallHandler("OnUsePill", variant, player, floor, pillEffect)
end)

------------------------------------------------------------
-- RESET ON GAME START
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        local save = mod.SaveManager.GetRunSave()
        save.FloorChallengeState = {}
        save.UsedChallenges = {}
    end
end)

------------------------------------------------------------
-- API
------------------------------------------------------------
return {
    Register  = function(v, h) mod:RegisterDavidChallenge(v, h) end,
    Start     = function(f, v) mod:StartDavidChallenge(f, v) end,
    Fail      = function(p, f) mod:FailDavidChallenge(p, f) end,
    Complete  = function(f) mod:CompleteDavidChallenge(f) end,
    GetData   = function(f, v) return mod:GetChallengeData(f, v) end,
    IsActive  = function(f) return mod:IsDavidChallengeActive(f) end,
    GetVariant= function(f) return mod:GetDavidChallengeVariant(f) end,
}