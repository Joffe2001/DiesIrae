local mod = DiesIraeMod
local game = Game()

---@class DavidChallengeState
---@field active boolean
---@field variant integer
---@field failed boolean
---@field completed boolean
---@field pendingReward boolean
---@field rewardSpawned boolean
---@field blockBossReward boolean

---@type table<integer, DavidChallengeState>
local FloorChallengeState = {}

local function GetFloorChallengeState()
    local save = mod.SaveManager.GetRunSave()
    if not save then
        print("WARNING: SaveManager.GetRunSave() returned nil!")
        return {}
    end
    save.FloorChallengeState = save.FloorChallengeState or {}
    return save.FloorChallengeState
end


------------------------------------------------
-- Start challenge
------------------------------------------------
function mod:StartDavidChallenge(floor, variant)
    if not variant then return end

    if mod:GetCompletedDavidChallengeCount() >= 4 then
        return
    end

    local FloorChallengeState = GetFloorChallengeState()

    if FloorChallengeState[floor] then return end

    FloorChallengeState[floor] = {
        active = true,
        variant = variant,
        failed = false,
        completed = false,
        pendingReward = false,
        rewardSpawned = false,
        blockBossReward = false
    }
end

------------------------------------------------
-- Fail challenge
------------------------------------------------
function mod:FailDavidChallenge(player, floor)
    local FloorChallengeState = GetFloorChallengeState()
    local state = FloorChallengeState[floor]
    if not state or state.failed or state.completed then return end

    state.failed = true
    state.active = false
    state.blockBossReward = true

    local pdata = player:GetData()
    pdata.NoFireRoomActive = false

    player:AddBrokenHearts(2)
    game:GetHUD():ShowItemText("Challenge failed")
    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)
    player:AnimateSad()
end

------------------------------------------------
-- Complete challenge
------------------------------------------------
function mod:CompleteDavidChallenge(floor)
    local FloorChallengeState = GetFloorChallengeState()
    local state = FloorChallengeState[floor]
    if not state or state.failed or state.completed then return end

    state.completed = true
    state.active = false
    state.pendingReward = true
end

function mod:GetCompletedDavidChallengeCount()
    local FloorChallengeState = GetFloorChallengeState()
    local count = 0
    for _, state in pairs(FloorChallengeState) do
        if state.completed then
            count = count + 1
        end
    end
    return count
end

------------------------------------------------
-- Spawn reward on start room
------------------------------------------------
local function TrySpawnChallengeReward(player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local floor = level:GetStage()
    local room = game:GetRoom()

    if not room then return end
    if level:GetCurrentRoomIndex() ~= level:GetStartingRoomIndex() then return end

    local FloorChallengeState = GetFloorChallengeState()
    local prevState
    for f, state in pairs(FloorChallengeState) do
        if state.pendingReward and not state.rewardSpawned then
            prevState = state
            break
        end
    end
    
    if not prevState or not prevState.pendingReward or prevState.rewardSpawned then
        return
    end

    prevState.pendingReward = false
    prevState.rewardSpawned = true

    local spawnPos = room:GetCenterPos() + Vector(0, 40)

    -- Spawn Harp String
    Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        mod.Items.HarpString,
        spawnPos,
        Vector.Zero,
        player
    )

    game:GetHUD():ShowItemText("Challenge completed")
    SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
    player:AnimateHappy()
end

------------------------------------------------
-- Check if the boss was defeated
------------------------------------------------
local function WasBossDefeatedThisFloor()
    local level = game:GetLevel()
    local rooms = level:GetRooms()

    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if desc
        and desc.Data
        and desc.Data.Type == RoomType.ROOM_BOSS
        and desc.Clear then
            return true
        end
    end

    return false
end

------------------------------------------------
-- Cancel the challenge
------------------------------------------------
function mod:CancelDavidChallenge(floor)
    local FloorChallengeState = GetFloorChallengeState()
    local state = FloorChallengeState[floor]
    if not state then return end
    if state.failed or state.completed then return end

    state.active = false
end

------------------------------------------------
-- CALLBACKS
------------------------------------------------
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function()
    local FloorChallengeState = GetFloorChallengeState()
    local floor = game:GetLevel():GetStage()
    local state = FloorChallengeState[floor]

    if not state or not state.active then return end
    if state.failed then return end

    if WasBossDefeatedThisFloor() then
        mod:CompleteDavidChallenge(floor)
    else
        mod:CancelDavidChallenge(floor)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    TrySpawnChallengeReward(Isaac.GetPlayer(0))
end)

-- Remove boss reward 
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
    if pickup.SubType <= 0 then return end
    if game:GetRoom():GetType() ~= RoomType.ROOM_BOSS then return end

    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local FloorChallengeState = GetFloorChallengeState()
    local floor = game:GetLevel():GetStage()
    local state = FloorChallengeState[floor]
    if not state or not state.blockBossReward then return end

    pickup:Remove()
    state.blockBossReward = false
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    local save = mod.SaveManager.GetRunSave()
    save.FloorChallengeState = {}
end)

------------------------------------------------
-- API
------------------------------------------------
function mod:IsDavidChallengeActive(floor)
    local FloorChallengeState = GetFloorChallengeState()
    return FloorChallengeState[floor] and FloorChallengeState[floor].active
end

function mod:GetDavidChallengeVariant(floor)
    local FloorChallengeState = GetFloorChallengeState()
    return FloorChallengeState[floor] and FloorChallengeState[floor].variant
end

function mod:HasDavidChallenge(floor)
    local FloorChallengeState = GetFloorChallengeState()
    return FloorChallengeState[floor] ~= nil
end

return {
    StartChallenge    = function(floor, variant) mod:StartDavidChallenge(floor, variant) end,
    FailChallenge     = function(player, floor) mod:FailDavidChallenge(player, floor) end,
    CompleteChallenge = function(floor) mod:CompleteDavidChallenge(floor) end,
    IsActive          = function(floor) return mod:IsDavidChallengeActive(floor) end,
    GetVariant        = function(floor) return mod:GetDavidChallengeVariant(floor) end,
    HasChallenge      = function(floor) return mod:HasDavidChallenge(floor) end
}