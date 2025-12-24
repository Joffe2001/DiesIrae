local mod = DiesIraeMod
local game = Game()

---@class DavidChallengeState
---@field active boolean
---@field variant integer?
---@field failed boolean
---@field completed boolean
---@field rewardSpawned boolean

---@type table<integer, DavidChallengeState>
local FloorChallengeState = {}

---@param floor integer
---@param variant integer
function mod:StartDavidChallenge(floor, variant)
    if FloorChallengeState[floor] or not variant then return end

    FloorChallengeState[floor] = {
        active = true,
        variant = variant,
        failed = false,
        completed = false,
        rewardSpawned = false,
        blockBossReward = false
    }
end

---@param player EntityPlayer
---@param floor integer
function mod:FailDavidChallenge(player, floor)
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

---@param floor integer
function mod:CompleteDavidChallenge(floor)
    local state = FloorChallengeState[floor]
    if not state or state.failed then return end

    state.completed = true
    state.active = false
    state.pendingReward = true
end

local function TrySpawnChallengeReward(player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local floor = level:GetStage()
    local room = game:GetRoom()
    if not room then return end

    local prevState = FloorChallengeState[floor - 1]
    if not prevState or not prevState.pendingReward then return end

    if level:GetCurrentRoomIndex() ~= level:GetStartingRoomIndex() then
        return
    end

    prevState.pendingReward = false
    prevState.rewardSpawned = true

    local spawnPos = room:GetCenterPos() + Vector(0, 40)

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

function mod:HasDavidChallenge(floor)
    return FloorChallengeState[floor] ~= nil
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    TrySpawnChallengeReward(Isaac.GetPlayer(0))
end)

function mod:IsDavidChallengeActive(floor)
    return FloorChallengeState[floor] and FloorChallengeState[floor].active
end

function mod:GetDavidChallengeVariant(floor)
    return FloorChallengeState[floor] and FloorChallengeState[floor].variant
end


mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    FloorChallengeState = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
    if pickup.SubType <= 0 then return end
    if game:GetRoom():GetType() ~= RoomType.ROOM_BOSS then return end

    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local floor = game:GetLevel():GetStage()
    local state = FloorChallengeState[floor]

    if not state or not state.blockBossReward then return end

    pickup:Remove()
    state.blockBossReward = false
end)

return {
    StartChallenge    = function(floor, variant) mod:StartDavidChallenge(floor, variant) end,
    FailChallenge     = function(player, floor) mod:FailDavidChallenge(player, floor) end,
    CompleteChallenge = function(floor) mod:CompleteDavidChallenge(floor) end,
    IsActive          = function(floor) return mod:IsDavidChallengeActive(floor) end,
    GetVariant        = function(floor) return mod:GetDavidChallengeVariant(floor) end,
    HasChallenge      = function(floor) return mod:HasDavidChallenge(floor) end
}
