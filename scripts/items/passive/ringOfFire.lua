local mod = DiesIraeMod
local game = Game()

local saveManager = mod.SaveManager
---@class Utils
local utils = mod.Utils

local ringOfFire = {
    INITIAL_WISPS = 6,
    BASE_REWARD_CHANCE = 0.75,
    REWARD_CHANCE_BOOK_OF_VIRTUES = 1,
    WISP_CHANCE_JAR_OF_WISPS = 0.2,
    WISP_ID = {
        LV0 = 0,
        LV1 = 1,
        RED = 2,
        BLUE = 3,
        BLACK = 4,
    }
}

function ringOfFire:OnPostAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    if collectibleType == mod.Items.RingOfFire then
        ringOfFire:SpawnWisp(player, ringOfFire.INITIAL_WISPS)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, ringOfFire.OnPostAddCollectible)

function ringOfFire:OnPreRoomTriggerClear()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.RingOfFire) then
            ringOfFire:AttemptReward(player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_TRIGGER_CLEAR, ringOfFire.OnPreRoomTriggerClear)

function ringOfFire:AttemptReward(player)
    local chance = ringOfFire.BASE_REWARD_CHANCE;
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
        chance = ringOfFire.REWARD_CHANCE_BOOK_OF_VIRTUES
    end
    local rng = ringOfFire:GetRNG(player)
    if rng:RandomFloat() < chance then
        ringOfFire:Reward(player)
    end
end

function ringOfFire:Reward(player)
    local value = (player.Luck + 10) * 0.1
    value = math.max(math.min(value, 2.6), 0.5) -- make sure it's in [0.5, 2.6]

    local rng = ringOfFire:GetRNG(player)
    local numWisps = 0
    if rng:RandomFloat() < value then
        -- print('1st wisp')
        numWisps = numWisps + 1
    end
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
        if value > 1 then
            if rng:RandomFloat() < math.min(value - 1, 0.8) then
                -- print('2nd wisp')
                numWisps = numWisps + 1
            end
        end
        if value > 1.8 then
            if rng:RandomFloat() < math.min(value - 1.8) then
                -- print('3rd wisp')
                numWisps = numWisps + 1
            end
        end
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_JAR_OF_WISPS) then
        if rng:RandomFloat() < ringOfFire.WISP_CHANCE_JAR_OF_WISPS then
            -- print('4th wisp')
            numWisps = numWisps + 1
        end
    end
    ringOfFire:SpawnWisp(player, numWisps)
end

function ringOfFire:SpawnWisp(player, numWisps)
    local wispWeight = {
        LV0 = 70,
        LV1 = 9999930,
        RED = 5,
        BLUE = 1,
        BLACK = 0,
    }

    if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
        wispWeight.LV0 = 15
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC) then
        wispWeight.LV1 = 60
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_RED_CANDLE) then
        wispWeight.RED = 20
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_CANDLE) then
        wispWeight.BLUE = 15
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        wispWeight.BLACK = 25
    end

    local wispPool = {
        {wispWeight.LV0, ringOfFire.WISP_ID.LV0},
        {wispWeight.LV1, ringOfFire.WISP_ID.LV1},
        {wispWeight.RED, ringOfFire.WISP_ID.RED},
        {wispWeight.BLUE, ringOfFire.WISP_ID.BLUE},
        {wispWeight.BLACK, ringOfFire.WISP_ID.BLACK},
    }

    for _ = 1, numWisps do
        local wispID = utils.WeightedRandom(wispPool, ringOfFire:GetRNG(player))
        if wispID == ringOfFire.WISP_ID.LV0 then
            ringOfFire:SpawnWispLV0(player)
        elseif wispID == ringOfFire.WISP_ID.LV1 then
            ringOfFire:SpawnWispLV1(player)
        elseif wispID == ringOfFire.WISP_ID.RED then
            ringOfFire:SpawnWispRED(player)
        elseif wispID == ringOfFire.WISP_ID.BLUE then
            ringOfFire:SpawnWispBLUE(player)
        elseif wispID == ringOfFire.WISP_ID.BLACK then
            ringOfFire:SpawnWispBLACK(player)
        end
    end
end

function ringOfFire:SpawnWispLV0(player)
    local wispID = ringOfFire.WISP_ID.LV0
    ---@type EntityFamiliar
    local wisp = player:AddWisp(mod.Wisps.RingofFire1, player.Position)
    local data = saveManager.GetRunSave(wisp, false, false)
    data.ringOfFire = wispID
    wisp:AddToOrbit(3)
end
function ringOfFire:SpawnWispLV1(player)
    local wispID = ringOfFire.WISP_ID.LV1
    ---@type EntityFamiliar
    local wisp = player:AddWisp(mod.Wisps.RingofFire2, player.Position)
    local data = saveManager.GetRunSave(wisp, false, false)
    data.ringOfFire = wispID
    wisp:AddToOrbit(2)
end
function ringOfFire:SpawnWispRED(player)
    local wispID = ringOfFire.WISP_ID.RED
    ---@type EntityFamiliar
    local wisp = player:AddWisp(mod.Wisps.RingofFire3, player.Position)
    local data = saveManager.GetRunSave(wisp, false, false)
    data.ringOfFire = wispID
    wisp:AddToOrbit(1)
end
function ringOfFire:SpawnWispBLUE(player)
    local wispID = ringOfFire.WISP_ID.BLUE
    ---@type EntityFamiliar
    local wisp = player:AddWisp(mod.Wisps.RingofFire4, player.Position)
    local data = saveManager.GetRunSave(wisp, false, false)
    data.ringOfFire = wispID
    wisp:AddToOrbit(1)
end
function ringOfFire:SpawnWispBLACK(player)
    local wispID = ringOfFire.WISP_ID.BLACK
    ---@type EntityFamiliar
    local wisp = player:AddWisp(mod.Wisps.RingofFire5, player.Position)
    local data = saveManager.GetRunSave(wisp, false, false)
    data.ringOfFire = wispID
    wisp:AddToOrbit(1)
end

---@param wisp EntityFamiliar
function ringOfFire:OnFamiliarUpdate(wisp)
    local data = saveManager.GetRunSave(wisp, false, false)
    if data.ringOfFire ~= nil then
        local wispID = data.ringOfFire
        if wispID == ringOfFire.WISP_ID.LV0 then
        end
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, ringOfFire.OnFamiliarUpdate, FamiliarVariant.WISP)

---@param wisp EntityFamiliar
---@param collider Entity
function ringOfFire:OnFamiliarCollision(wisp, collider)
    local data = saveManager.GetRunSave(wisp, false, false)
    if data.ringOfFire ~= nil then
        local wispID = data.ringOfFire
        if collider:IsVulnerableEnemy() then
            if wispID == ringOfFire.WISP_ID.LV0 then
                local player = wisp.Player
                local numBurn = 3
                local duration = ringOfFire:GetBurnEffectDuration(numBurn)
                local baseDmgPerBurn = 5
                local stageMultiplier = 2
                local dmgPerBurn = baseDmgPerBurn + stageMultiplier * Game():GetLevel():GetStage()
                collider:AddBurn(EntityRef(player), duration, dmgPerBurn)
                return true
            elseif wispID == ringOfFire.WISP_ID.LV1 then
                local player = wisp.Player
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 0, wisp.Position, Vector.Zero, player)
                return true
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, ringOfFire.OnFamiliarCollision, FamiliarVariant.WISP)

function ringOfFire:GetRNG(player)
    return player:GetCollectibleRNG(mod.Items.RingOfFire)
end

function ringOfFire:GetBurnEffectDuration(numBurn)
    return (3 + 20 * (numBurn - 1))
end