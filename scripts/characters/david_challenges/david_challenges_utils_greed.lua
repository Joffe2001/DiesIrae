local mod = DiesIraeMod
local game = Game()

local DavidUtils = include("scripts/characters/david_challenges/david_challenges_utils")

local function GetCurrentWave()
    return game:GetLevel().GreedModeWave
end

--TOTAL waves including boss and devil
--Greed:    1-8 normal, 9-10 boss, 11 devil
--Greedier: 1-9 normal, 10-11 boss, 12 devil
local function GetNormalWaveCount()
    return game:IsHardMode() and 9 or 8
end

local function GetTotalWaves()
    return GetNormalWaveCount()
end

local function GetFirstBossWave()
    return GetNormalWaveCount() + 1 
end

local function GetSecondBossWave()
    return GetNormalWaveCount() + 2
end

local function GetDevilWave()
    return GetNormalWaveCount() + 3
end

local function IsBossWave()
    local wave = GetCurrentWave()
    return wave == GetFirstBossWave() or wave == GetSecondBossWave()
end

local function IsDevilWave()
    local wave = GetCurrentWave()
    return wave == GetDevilWave() and not IsBossWave()
end

------------------------------------------------------------
-- BOSS WAVE COMPLETION TRACKING
------------------------------------------------------------
local bossWavesCompletedFloors = {}

local function SetBossWavesCompleted(floor)
    bossWavesCompletedFloors[floor] = true
end

local function WereBossWavesCompleted(floor)
    return bossWavesCompletedFloors[floor] == true
end

local function ResetBossWavesTracking(floor)
    bossWavesCompletedFloors[floor] = false
    if waveTimers then waveTimers[floor] = nil end
end

------------------------------------------------------------
-- CONTINUOUS TIMER SYSTEM FOR WAVES
------------------------------------------------------------
local waveTimers = {}

local function GetWaveTimer(floor)
    if not waveTimers[floor] then
        waveTimers[floor] = {
            bossWaveStartFrame  = nil,
            bossWaveEndFrame    = nil,
            bossWavesComplete   = false,
            devilWaveStartFrame = nil,
            devilWaveEndFrame   = nil,
            devilWaveComplete   = false,
        }
    end
    return waveTimers[floor]
end

local function GetBossWaveElapsedFrames(floor)
    local timer = GetWaveTimer(floor)
    if not timer.bossWaveStartFrame then return 0 end
    if timer.bossWavesComplete then
        return timer.bossWaveEndFrame - timer.bossWaveStartFrame
    end
    return game:GetFrameCount() - timer.bossWaveStartFrame
end

local function GetDevilWaveElapsedFrames(floor)
    local timer = GetWaveTimer(floor)
    if not timer.devilWaveStartFrame then return 0 end
    if timer.devilWaveComplete then
        return timer.devilWaveEndFrame - timer.devilWaveStartFrame
    end
    return game:GetFrameCount() - timer.devilWaveStartFrame
end

local function OnWaveChanged(floor, newWave, prevWave)
    local timer      = GetWaveTimer(floor)
    local firstBoss  = GetFirstBossWave()
    local secondBoss = GetSecondBossWave()
    local devilWave  = GetDevilWave()


    -- Boss waves start
    if newWave == firstBoss and not timer.bossWaveStartFrame then
        timer.bossWaveStartFrame = game:GetFrameCount()
    end

    -- Boss waves complete
    if prevWave == secondBoss and timer.bossWaveStartFrame and not timer.bossWavesComplete then
        timer.bossWaveEndFrame  = game:GetFrameCount()
        timer.bossWavesComplete = true
        local t = timer.bossWaveEndFrame - timer.bossWaveStartFrame
        SetBossWavesCompleted(floor)
    end

    -- Devil wave start
    if newWave == devilWave and not timer.devilWaveStartFrame then
        timer.devilWaveStartFrame = game:GetFrameCount()
    end
end

local function UpdateRoomClearBossCheck(floor)
    local timer      = GetWaveTimer(floor)
    local room       = game:GetRoom()
    local secondBoss = GetSecondBossWave()
    local wave       = GetCurrentWave()

    if wave == secondBoss and room:IsClear() then
        if timer.bossWaveStartFrame and not timer.bossWavesComplete then
            timer.bossWaveEndFrame  = game:GetFrameCount()
            timer.bossWavesComplete = true
            local t = timer.bossWaveEndFrame - timer.bossWaveStartFrame

            SetBossWavesCompleted(floor)
        end
    end
end

-- Checks whether the devil wave cleared.
local function UpdateRoomClearTimers(floor)
    local timer     = GetWaveTimer(floor)
    local room      = game:GetRoom()
    local devilWave = GetDevilWave()
    local wave      = GetCurrentWave()

    if wave == devilWave and room:IsClear() then
        if timer.devilWaveStartFrame and not timer.devilWaveComplete then
            timer.devilWaveEndFrame = game:GetFrameCount()
            timer.devilWaveComplete = true
            local t = timer.devilWaveEndFrame - timer.devilWaveStartFrame
        end
    end
end

------------------------------------------------------------
-- GREED-SPECIFIC SAVE DATA
------------------------------------------------------------
local function GetGreedFloorChallengeState()
    local save = mod.SaveManager.GetRunSave()
    if not save then return {} end
    save.GreedFloorChallengeState = save.GreedFloorChallengeState or {}
    return save.GreedFloorChallengeState
end

local function GetFloorKey(floor)
    return "floor_" .. tostring(floor)
end

local function GetGreedFloorState(floor)
    return GetGreedFloorChallengeState()[GetFloorKey(floor)]
end

local function SetGreedFloorState(floor, state)
    GetGreedFloorChallengeState()[GetFloorKey(floor)] = state
end

local function GetUsedGreedChallenges()
    local save = mod.SaveManager.GetRunSave()
    if not save then return {} end
    save.UsedGreedChallenges = save.UsedGreedChallenges or {}
    return save.UsedGreedChallenges
end

local function IsChallengeUsed(variant)
    return GetUsedGreedChallenges()["v" .. tostring(variant)] == true
end

local function MarkChallengeAsUsed(variant)
    GetUsedGreedChallenges()["v" .. tostring(variant)] = true
end

------------------------------------------------------------
-- HANDLER REGISTRY
------------------------------------------------------------
local GreedChallengeHandlers = {
    OnStart             = {},
    OnUpdate            = {},
    OnNewRoom           = {},
    OnRender            = {},
    OnFail              = {},
    OnComplete          = {},
    OnCleanup           = {},
    OnPlayerDamage      = {},
    OnUseItem           = {},
    OnUseCard           = {},
    OnUsePill           = {},
    OnLevelSelect       = {},
    OnFireTear          = {},
    OnInitLaser         = {},
    OnInitKnife         = {},
    OnGreedWave         = {},
    OnBossWavesComplete = {},
}

local function SafeCallHandler(handlerName, variant, ...)
    local handler = GreedChallengeHandlers[handlerName]
    if not handler then return end

    local f = handler[variant]
    if not f then return end

    local success, err = pcall(f, ...)
    if not success then
    end
end

------------------------------------------------------------
-- CORE FUNCTIONS
------------------------------------------------------------
function mod:RegisterGreedChallenge(variant, handlers)
    for k, f in pairs(handlers) do
        if GreedChallengeHandlers[k] then
            GreedChallengeHandlers[k][variant] = f
        else
            print("[Greed] WARNING: Invalid handler key:", k)
        end
    end
end

function mod:GetGreedChallengeData(floor, variant)
    local state = GetGreedFloorState(floor)
    if not state then return nil end

    state.data = state.data or {}
    local variantKey = "var_" .. tostring(variant)
    state.data[variantKey] = state.data[variantKey] or {}

    return state.data[variantKey]
end

function mod:IsGreedChallengeActive(floor)
    local s = GetGreedFloorState(floor)
    return s and s.active
end

function mod:GetGreedChallengeVariant(floor)
    local s = GetGreedFloorState(floor)
    return s and s.variant
end

function mod:GetActiveGreedChallengeState()
    local player = Isaac.GetPlayer(0)
    if not player or player:GetPlayerType() ~= mod.Players.David then
        return nil, nil, nil
    end

    if not game:IsGreedMode() then
        return nil, nil, nil
    end

    local floor = game:GetLevel():GetStage()
    local state = GetGreedFloorState(floor)
    if not state or not state.active then
        return nil, nil, nil
    end

    return state, floor, state.variant, player
end

function mod:StartGreedChallenge(floor, variant)
    if not variant then return end
    if GetGreedFloorState(floor) then return end
    if IsChallengeUsed(variant) then return end

    local state = {
        active        = true,
        variant       = variant,
        completed     = false,
        failed        = false,
        pendingReward = false,
        rewardSpawned = false,
        data          = {}
    }

    SetGreedFloorState(floor, state)
    MarkChallengeAsUsed(variant)

    SafeCallHandler("OnStart", variant, floor)


    local level = game:GetLevel()
    if level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
        SpawnGreedChallengeBackdrop(variant)
    end
end

function mod:FailGreedChallenge(player, floor)
    local state = GetGreedFloorState(floor)
    if not state or state.failed or state.completed then return end

    SafeCallHandler("OnFail", state.variant, player, floor)
    SafeCallHandler("OnCleanup", state.variant, floor)

    state.failed = true
    state.active = false

    player:AddBrokenHearts(2)
    game:GetHUD():ShowItemText("Challenge Failed!", "", false)
    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)
    player:AnimateSad()

end

function mod:CompleteGreedChallenge(floor)
    local state = GetGreedFloorState(floor)
    if not state or state.completed or state.failed then return end

    SafeCallHandler("OnComplete", state.variant, floor)
    SafeCallHandler("OnCleanup", state.variant, floor)

    state.active        = false
    state.completed     = true
    state.pendingReward = true

    local save = mod.SaveManager.GetRunSave()
    save.GreedChallengesCompleted = (save.GreedChallengesCompleted or 0) + 1

    game:GetHUD():ShowItemText("Challenge Complete!", "", false)
    SFXManager():Play(SoundEffect.SOUND_THUMBSUP)

end

function mod:CancelGreedChallenge(floor)
    local state = GetGreedFloorState(floor)
    if not state then return end

    SafeCallHandler("OnCleanup", state.variant, floor)

    state.active    = false
    state.cancelled = true

end

------------------------------------------------------------
-- BACKDROP MANAGEMENT
------------------------------------------------------------
function SpawnGreedChallengeBackdrop(variant)
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
    spr:Load("gfx/grid/David_challenges/challengesgreed.anm2", true)
    spr:Play("Idle", true)
    spr:SetFrame(variant)

    effect:GetData().IsGreedChallengeBackdrop = true
    effect:GetData().ChallengeVariant         = variant
    effect:GetData().ChallengeFloor           = game:GetLevel():GetStage()
end

local function RestoreGreedBackdropOnRoomEnter()
    local level        = game:GetLevel()
    local currentFloor = level:GetStage()

    if level:GetCurrentRoomIndex() ~= level:GetStartingRoomIndex() then return end

    local state = GetGreedFloorState(currentFloor)
    if not state or not state.active then return end

    for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT)) do
        local data = effect:GetData()
        if data.IsGreedChallengeBackdrop and data.ChallengeFloor == currentFloor then
            return
        end
    end

    SpawnGreedChallengeBackdrop(state.variant)
end

local function RemoveOldBackdrops()
    local currentFloor = game:GetLevel():GetStage()

    for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT)) do
        local data = effect:GetData()
        if data.IsGreedChallengeBackdrop and data.ChallengeFloor then
            if data.ChallengeFloor ~= currentFloor then
                effect:Remove()
            end
        end
    end
end

------------------------------------------------------------
-- AUTO-START
------------------------------------------------------------
function mod:AutoStartGreedChallenge(floor)
    if floor < 1 or floor > 5 then return end
    if GetGreedFloorState(floor) then return end

    local variant

    if floor == 1 then
        variant = mod.GREED_CHALLENGES.LOW_COINS
    else
        local rng = RNG()
        rng:SetSeed(game:GetSeeds():GetStartSeed() + floor * 1000, 35)

        local availableChallenges = {}
        for i = 0, 6 do
            if i ~= mod.GREED_CHALLENGES.LOW_COINS and not IsChallengeUsed(i) then
                table.insert(availableChallenges, i)
            end
        end

        if #availableChallenges == 0 then return end

        variant = availableChallenges[rng:RandomInt(#availableChallenges) + 1]
    end

    mod:StartGreedChallenge(floor, variant)
end

------------------------------------------------------------
-- REWARD SPAWNING
------------------------------------------------------------
local function TrySpawnGreedChallengeReward(player)
    if not player or player:GetPlayerType() ~= mod.Players.David then return end

    local level        = game:GetLevel()
    local currentFloor = level:GetStage()

    if level:GetCurrentRoomIndex() ~= level:GetStartingRoomIndex() then return end

    local allStates = GetGreedFloorChallengeState()
    for floorKey, state in pairs(allStates) do
        if state.pendingReward and not state.rewardSpawned then
            local completedFloor = tonumber(floorKey:match("%d+"))

            if completedFloor and currentFloor > completedFloor then
                state.rewardSpawned = true
                state.pendingReward = false

                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE,
                    mod.Items.HarpString,
                    game:GetRoom():GetCenterPos() + Vector(0, 40),
                    Vector.Zero,
                    player
                )

                game:GetHUD():ShowItemText("Challenge Reward!", "", false)
                SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                if player.AnimateHappy then player:AnimateHappy() end

                return
            end
        end
    end
end

------------------------------------------------------------
-- CALLBACKS
------------------------------------------------------------
local lastGreedFloor = nil

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if not game:IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

    local newFloor = game:GetLevel():GetStage()
    local player   = Isaac.GetPlayer(0)

    if lastGreedFloor and lastGreedFloor ~= newFloor then
        local prevFloor  = lastGreedFloor
        local prevState  = GetGreedFloorState(prevFloor)

        local alreadyResolved = prevState and (prevState.failed or prevState.completed or prevState.cancelled)

        if prevState and not alreadyResolved then
            SafeCallHandler("OnLevelSelect", prevState.variant, player, prevFloor)

            prevState     = GetGreedFloorState(prevFloor)
            alreadyResolved = prevState and (prevState.failed or prevState.completed or prevState.cancelled)

            if not alreadyResolved then
                if WereBossWavesCompleted(prevFloor) then
                    mod:CompleteGreedChallenge(prevFloor)
                else
                    mod:CancelGreedChallenge(prevFloor)
                end
            end
        end
    end

    lastGreedFloor = newFloor

    RemoveOldBackdrops()
    ResetBossWavesTracking(newFloor)

    mod:AutoStartGreedChallenge(newFloor)
end)

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function()
    if not game:IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

    local floor  = game:GetLevel():GetStage()
    local player = Isaac.GetPlayer(0)
    local freshState = GetGreedFloorState(floor)

    if not freshState then return end

    if freshState.failed or freshState.completed or freshState.cancelled then
        return
    end

    SafeCallHandler("OnLevelSelect", freshState.variant, player, floor)

    freshState = GetGreedFloorState(floor)
    if freshState.failed or freshState.completed or freshState.cancelled then
        return
    end

    if WereBossWavesCompleted(floor) then
        mod:CompleteGreedChallenge(floor)
    else
        -- Boss waves never beaten
        mod:CancelGreedChallenge(floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if not game:IsGreedMode() then return end

    TrySpawnGreedChallengeReward(Isaac.GetPlayer(0))

    local state, floor, variant, player = mod:GetActiveGreedChallengeState()
    if not state then return end

    RestoreGreedBackdropOnRoomEnter()
    SafeCallHandler("OnNewRoom", variant, player, floor)
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if not game:IsGreedMode() then return end
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

    local floor = game:GetLevel():GetStage()
    UpdateRoomClearTimers(floor)
    UpdateRoomClearBossCheck(floor)

    local timer = GetWaveTimer(floor)
    if timer.bossWavesComplete and not timer.bossWavesCompleteHandlerFired then
        local state, _, variant, player = mod:GetActiveGreedChallengeState()
        if state and not WereBossWavesCompleted(floor) then
            timer.bossWavesCompleteHandlerFired = true
            SafeCallHandler("OnBossWavesComplete", variant, player, floor)
        end
    end
end)

-- Wave tracking 
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if not game:IsGreedMode() then return end

    local state, floor, variant, player = mod:GetActiveGreedChallengeState()
    if not state then return end

    SafeCallHandler("OnUpdate", variant, player, floor)
end)

if ModCallbacks.MC_POST_GREED_MODE_WAVE then
    mod:AddCallback(ModCallbacks.MC_POST_GREED_MODE_WAVE, function(_, newWave)
        if not game:IsGreedMode() then return end
        if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

        local floor      = game:GetLevel():GetStage()
        local timer      = GetWaveTimer(floor)
        local prevWave   = timer.lastKnownWave or -1
        timer.lastKnownWave = newWave

        OnWaveChanged(floor, newWave, prevWave)

        local state, _, variant, player = mod:GetActiveGreedChallengeState()
        if not state then return end

        SafeCallHandler("OnGreedWave", variant, player, floor)

        if prevWave == GetSecondBossWave() and not WereBossWavesCompleted(floor) then
            timer.bossWavesCompleteHandlerFired = true
            SafeCallHandler("OnBossWavesComplete", variant, player, floor)
        end
    end)
else
    local lastWaveByFloor = {}
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
        if not game:IsGreedMode() then return end
        if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end

        local floor       = game:GetLevel():GetStage()
        local currentWave = GetCurrentWave()
        local prevWave    = lastWaveByFloor[floor] or -1

        if currentWave ~= prevWave then
            lastWaveByFloor[floor] = currentWave
            OnWaveChanged(floor, currentWave, prevWave)

            local state, _, variant, player = mod:GetActiveGreedChallengeState()
            if state then
                SafeCallHandler("OnGreedWave", variant, player, floor)

                -- Boss waves complete
                if prevWave == GetSecondBossWave() and not WereBossWavesCompleted(floor) then
                    local timer = GetWaveTimer(floor)
                    timer.bossWavesCompleteHandlerFired = true
                    SafeCallHandler("OnBossWavesComplete", variant, player, floor)
                end
            end
        end
    end)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not game:IsGreedMode() then return end

    local state, floor, variant, player = mod:GetActiveGreedChallengeState()
    if not state then return end

    SafeCallHandler("OnRender", variant, player, floor)
end)

------------------------------------------------------------
-- EVENT CALLBACKS
------------------------------------------------------------

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source)
    if not game:IsGreedMode() then return end
    local state, floor, variant = mod:GetActiveGreedChallengeState()
    if state and entity:ToPlayer() and entity:ToPlayer():GetPlayerType() == mod.Players.David then
        SafeCallHandler("OnPlayerDamage", variant, entity:ToPlayer(), floor, amount, flags, source)
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemID, _, player)
    if not game:IsGreedMode() or player:GetPlayerType() ~= mod.Players.David then return end
    local state, floor, variant = mod:GetActiveGreedChallengeState()
    if state then SafeCallHandler("OnUseItem", variant, player, floor, itemID) end
end)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player)
    if not game:IsGreedMode() or player:GetPlayerType() ~= mod.Players.David then return end
    local state, floor, variant = mod:GetActiveGreedChallengeState()
    if state then SafeCallHandler("OnUseCard", variant, player, floor, cardID) end
end)

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, pillEffect, player)
    if not game:IsGreedMode() or player:GetPlayerType() ~= mod.Players.David then return end
    local state, floor, variant = mod:GetActiveGreedChallengeState()
    if state then SafeCallHandler("OnUsePill", variant, player, floor, pillEffect) end
end)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    if not game:IsGreedMode() then return end
    local state, floor, variant, player = mod:GetActiveGreedChallengeState()
    if state then SafeCallHandler("OnFireTear", variant, player, tear, floor) end
end)

mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, function(_, laser)
    if not game:IsGreedMode() then return end
    local state, floor, variant, player = mod:GetActiveGreedChallengeState()
    if state then SafeCallHandler("OnInitLaser", variant, player, laser, floor) end
end)

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_INIT, function(_, knife)
    if not game:IsGreedMode() then return end
    local state, floor, variant, player = mod:GetActiveGreedChallengeState()
    if state then SafeCallHandler("OnInitKnife", variant, player, knife, floor) end
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not game:IsGreedMode() then return end

    if not isContinued then
        local save = mod.SaveManager.GetRunSave()
        save.GreedFloorChallengeState = {}
        save.UsedGreedChallenges      = {}
        save.GreedChallengesCompleted = 0
        bossWavesCompletedFloors      = {}
        waveTimers                    = {}

        lastGreedFloor = nil

        if PlayerManager.AnyoneIsPlayerType(mod.Players.David) then
            local floor = game:GetLevel():GetStage()
            lastGreedFloor = floor
            if floor == 1 and not GetGreedFloorState(floor) then
                mod:AutoStartGreedChallenge(floor)
            end
        end
    end
end)

------------------------------------------------------------
-- API
------------------------------------------------------------
return {
    Register   = function(variant, handlers) mod:RegisterGreedChallenge(variant, handlers) end,
    Start      = function(floor, variant) mod:StartGreedChallenge(floor, variant) end,
    Fail       = function(player, floor) mod:FailGreedChallenge(player, floor) end,
    Complete   = function(floor) mod:CompleteGreedChallenge(floor) end,
    GetData    = function(floor, variant) return mod:GetGreedChallengeData(floor, variant) end,
    IsActive   = function(floor) return mod:IsGreedChallengeActive(floor) end,
    GetVariant = function(floor) return mod:GetGreedChallengeVariant(floor) end,
    Cancel     = function(floor) mod:CancelGreedChallenge(floor) end,
    -- Wave tracking
    GetCurrentWave    = GetCurrentWave,
    GetTotalWaves     = GetTotalWaves,
    GetFirstBossWave  = GetFirstBossWave,
    GetSecondBossWave = GetSecondBossWave,
    GetDevilWave      = GetDevilWave,
    IsBossWave        = IsBossWave,
    IsDevilWave       = IsDevilWave,

    -- Timer functions
    GetBossWaveElapsedFrames  = GetBossWaveElapsedFrames,
    GetDevilWaveElapsedFrames = GetDevilWaveElapsedFrames,

    -- Boss tracking
    SetBossWavesCompleted  = SetBossWavesCompleted,
    WereBossWavesCompleted = WereBossWavesCompleted,
}