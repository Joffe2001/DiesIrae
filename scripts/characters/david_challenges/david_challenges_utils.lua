local mod = DiesIraeMod
local game = Game()

------------------------------------------------------------
-- INTERNAL DATA STORAGE (handled via SaveManager)
------------------------------------------------------------
local function GetFloorChallengeState()
    local save = mod.SaveManager.GetRunSave()
    if not save then return {} end

    save.FloorChallengeState = save.FloorChallengeState or {}
    return save.FloorChallengeState
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

    -- New handler groups (for unified callback architecture)
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
    local state = GetFloorChallengeState()[floor]
    if not state or not state.active then
        return nil
    end

    return player, floor
end

function mod:GetChallengeData(floor, variant)
    local state = GetFloorChallengeState()[floor]
    if not state then return nil end
    state.data = state.data or {}
    state.data[variant] = state.data[variant] or {}
    return state.data[variant]
end

function mod:IsDavidChallengeActive(floor)
    local s = GetFloorChallengeState()[floor]
    return s and s.active
end

function mod:GetDavidChallengeVariant(floor)
    local s = GetFloorChallengeState()[floor]
    return s and s.variant
end

function mod:GetActiveChallengeState()
    local player, floor = mod:GetActiveDavid()
    if not player then return nil, nil, nil end
    
    local variant = mod:GetDavidChallengeVariant(floor)
    local state = GetFloorChallengeState()[floor]
    
    return state, floor, variant, player
end

------------------------------------------------------------
-- START A NEW CHALLENGE (called by plates!)
------------------------------------------------------------
function mod:StartDavidChallenge(floor, variant)
    if not variant then return end
    if mod:GetCompletedDavidChallengeCount() >= 4 then return end

    local all = GetFloorChallengeState()
    if all[floor] then return end

    all[floor] = {
        active = true,
        variant = variant,
        failed = false,
        completed = false,
        pendingReward = false,
        rewardSpawned = false,
        blockBossReward = false,
        data = {},
    }

    if ChallengeHandlers.OnStart[variant] then
        ChallengeHandlers.OnStart[variant](floor)
    end
end

------------------------------------------------------------
-- FAIL CHALLENGE
------------------------------------------------------------
function mod:FailDavidChallenge(player, floor)
    local all = GetFloorChallengeState()
    local state = all[floor]
    if not state or state.failed or state.completed then return end

    state.failed = true
    state.active = false
    state.blockBossReward = true

    player:AddBrokenHearts(2)
    game:GetHUD():ShowItemText("Challenge failed")
    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)
    player:AnimateSad()

    local variant = state.variant
    if ChallengeHandlers.OnFail[variant] then
        ChallengeHandlers.OnFail[variant](player, floor)
    end
end

------------------------------------------------------------
-- COMPLETE CHALLENGE
------------------------------------------------------------
function mod:CompleteDavidChallenge(floor)
    local all = GetFloorChallengeState()
    local state = all[floor]
    if not state or state.failed or state.completed then return end

    state.completed = true
    state.active = false
    state.pendingReward = true

    local variant = state.variant
    if ChallengeHandlers.OnComplete[variant] then
        ChallengeHandlers.OnComplete[variant](floor)
    end
end

------------------------------------------------------------
-- COUNT COMPLETED CHALLENGES
------------------------------------------------------------
function mod:GetCompletedDavidChallengeCount()
    local count = 0
    for _, s in pairs(GetFloorChallengeState()) do
        if s.completed then count = count + 1 end
    end
    return count
end

------------------------------------------------------------
-- REWARD DROP (next starting room)
------------------------------------------------------------
local function TrySpawnChallengeReward(player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    if level:GetCurrentRoomIndex() ~= level:GetStartingRoomIndex() then return end

    local all = GetFloorChallengeState()
    for _, state in pairs(all) do
        if state.pendingReward and not state.rewardSpawned then
            state.pendingReward = false
            state.rewardSpawned = true

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                mod.Items.HarpString,
                game:GetRoom():GetCenterPos() + Vector(0, 40),
                Vector.Zero,
                player
            )

            game:GetHUD():ShowItemText("Challenge completed")
            SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
            player:AnimateHappy()
            return
        end
    end
end

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------
local function WasBossDefeatedThisFloor()
    local rooms = game:GetLevel():GetRooms()
    for i = 0, rooms.Size - 1 do
        local d = rooms:Get(i)
        if d and d.Data and d.Data.Type == RoomType.ROOM_BOSS and d.Clear then
            return true
        end
    end
    return false
end

------------------------------------------------------------
-- CANCEL CHALLENGE
------------------------------------------------------------
function mod:CancelDavidChallenge(floor)
    local all = GetFloorChallengeState()
    local state = all[floor]
    if not state or state.failed or state.completed then return end

    local variant = state.variant
    if ChallengeHandlers.OnCleanup[variant] then
        ChallengeHandlers.OnCleanup[variant](floor)
    end

    state.active = false
end


------------------------------------------------------------
-- CORE CALLBACK DISPATCHER
------------------------------------------------------------

-- LEVEL SELECT (end-of-floor evaluation)
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function()
    local state, floor, variant, player = mod:GetActiveChallengeState()
    if not state then return end

    if ChallengeHandlers.OnLevelSelect[variant] then
        ChallengeHandlers.OnLevelSelect[variant](player, floor)
    end

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

    local variant = mod:GetDavidChallengeVariant(floor)
    local f = ChallengeHandlers.OnNewRoom[variant]
    if f then f(player, floor) end
end)

-- UPDATE
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local state, floor, variant, player = mod:GetActiveChallengeState()
    if not state then return end

    local f = ChallengeHandlers.OnUpdate[variant]
    if f then f(player, floor) end
end)

-- RENDER
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local state, floor, variant, player = mod:GetActiveChallengeState()
    if not state then return end

    local f = ChallengeHandlers.OnRender[variant]
    if f then f(player, floor) end
end)

------------------------------------------------------------
-- SPECIAL EVENT DISPATCH (for complicated challenges)
------------------------------------------------------------

-- PLAYER DAMAGE
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source)
    local player, floor = mod:GetActiveDavid()
    if not player then return end

    -- If player takes damage
    if entity:ToPlayer() and entity:ToPlayer():GetPlayerType() == mod.Players.David then
        local variant = mod:GetDavidChallengeVariant(floor)
        local f = ChallengeHandlers.OnPlayerDamage[variant]
        if f then f(entity:ToPlayer(), floor, amount, flags, source) end
    end

    -- If any entity takes damage (for hit/miss logic)
    local variant = mod:GetDavidChallengeVariant(floor)
    local f = ChallengeHandlers.OnEntityDamage[variant]
    if f then f(entity, amount, flags, source, player, floor) end
end)

-- NPC KILL
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    local player, floor = mod:GetActiveDavid()
    if not player then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    local f = ChallengeHandlers.OnNPCKill[variant]
    if f then f(npc, player, floor) end
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
    if f then return f(pickup, player, floor) end
end)

-- FIRE TEAR
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local player, floor = mod:GetActiveDavid()
    if not player then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    local f = ChallengeHandlers.OnFireTear[variant]
    if f then f(player, tear, floor) end
end)

-- LASER INIT
mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, function(_, laser)
    local player, floor = mod:GetActiveDavid()
    if not player then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    local f = ChallengeHandlers.OnInitLaser[variant]
    if f then f(player, laser, floor) end
end)

-- KNIFE INIT
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_INIT, function(_, knife)
    local player, floor = mod:GetActiveDavid()
    if not player then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    local f = ChallengeHandlers.OnInitKnife[variant]
    if f then f(player, knife, floor) end
end)

-- USE ITEM
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemID, _, player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local p2, floor = mod:GetActiveDavid()
    if not p2 then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    local f = ChallengeHandlers.OnUseItem[variant]
    if f then f(player, floor, itemID) end
end)

-- USE CARD
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local p2, floor = mod:GetActiveDavid()
    if not p2 then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    local f = ChallengeHandlers.OnUseCard[variant]
    if f then f(player, floor, cardID) end
end)

-- USE PILL
mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, pillEffect, player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local p2, floor = mod:GetActiveDavid()
    if not p2 then return end

    local variant = mod:GetDavidChallengeVariant(floor)
    local f = ChallengeHandlers.OnUsePill[variant]
    if f then f(player, floor, pillEffect) end
end)

------------------------------------------------------------
-- RESET ON GAME START
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    local save = mod.SaveManager.GetRunSave()
    save.FloorChallengeState = {}
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
