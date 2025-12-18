local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")
local sfx = SFXManager()

local FAIR_BUM = mod.Entities.FAMILIAR_FairBum.Var

---@class FairBum
local fairBum = {}

fairBum.Item = mod.Items.FairBum
fairBum.FollowDistance = 40
fairBum.PushFromIdlePlayer = true

fairBum.CoinChances = {
    [CoinSubType.COIN_PENNY]        = 0.10,
    [CoinSubType.COIN_NICKEL]       = 0.50,
    [CoinSubType.COIN_DIME]         = 1.00,
    [CoinSubType.COIN_DOUBLEPACK]  = 0.20,
    [CoinSubType.COIN_LUCKYPENNY]   = 0.40,
    [CoinSubType.COIN_STICKYNICKEL] = 0.25,
    [CoinSubType.COIN_GOLDEN]       = 1.00,
}

fairBum.KeyChances = {
    [KeySubType.KEY_NORMAL]      = 0.15,
    [KeySubType.KEY_DOUBLEPACK] = 0.35,
    [KeySubType.KEY_CHARGED]    = 0.50,
    [KeySubType.KEY_GOLDEN]     = 1.00,
}

fairBum.BombChances = {
    [BombSubType.BOMB_NORMAL]      = 0.15,
    [BombSubType.BOMB_DOUBLEPACK] = 0.35,
    [BombSubType.BOMB_TROLL]      = 0.10,
    [BombSubType.BOMB_GOLDEN]     = 1.00,
    [BombSubType.BOMB_GIGA]       = 1.00,
}

local function GetCounts(player)
    return {
        [PickupVariant.PICKUP_COIN] = player:GetNumCoins(),
        [PickupVariant.PICKUP_KEY]  = player:GetNumKeys(),
        [PickupVariant.PICKUP_BOMB] = player:GetNumBombs(),
    }
end

local function GetLeastTypes(player)
    local c = GetCounts(player)
    local min = math.min(c[PickupVariant.PICKUP_COIN], c[PickupVariant.PICKUP_KEY], c[PickupVariant.PICKUP_BOMB])

    local t = {}
    for k, v in pairs(c) do
        if v == min then
            table.insert(t, k)
        end
    end
    return t
end

function fairBum.OnUpdate(fam)
    local player = fam.Player
    if not player then return end

    local counts = GetCounts(player)
    local max = math.max(
        counts[PickupVariant.PICKUP_COIN],
        counts[PickupVariant.PICKUP_KEY],
        counts[PickupVariant.PICKUP_BOMB]
    )
    if
        counts[PickupVariant.PICKUP_COIN] == counts[PickupVariant.PICKUP_KEY] and
        counts[PickupVariant.PICKUP_KEY]  == counts[PickupVariant.PICKUP_BOMB]
    then
        fairBum.Accepts = nil
        return
    end

    local accepts = {}
    for variant, amount in pairs(counts) do
        if amount == max and amount > 0 then
            accepts[variant] = true
        end
    end

    fairBum.Accepts = accepts
end

function fairBum.Reward(fam)
    local pickup = fam:GetData().TargetPickup
    if not pickup then return false end

    local rng = fam:GetDropRNG()
    local chance = 0

    if pickup.Variant == PickupVariant.PICKUP_COIN then
        chance = fairBum.CoinChances[pickup.SubType] or 0.1
        sfx:Play(SoundEffect.SOUND_PENNYPICKUP)

    elseif pickup.Variant == PickupVariant.PICKUP_KEY then
        chance = fairBum.KeyChances[pickup.SubType] or 0.15
        sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)

    elseif pickup.Variant == PickupVariant.PICKUP_BOMB then
        chance = fairBum.BombChances[pickup.SubType] or 0.15
        sfx:Play(SoundEffect.SOUND_FETUS_LAND)
    end

    return rng:RandomFloat() < chance
end

function fairBum.DoReward(fam)
    local player = fam.Player
    if not player then return end

    local least = GetLeastTypes(player)
    if #least == 0 then return end

    local rng = fam:GetDropRNG()
    local variant = least[rng:RandomInt(#least) + 1]
    local pos = Isaac.GetFreeNearPosition(fam.Position, 20)

    if variant == PickupVariant.PICKUP_COIN then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, pos, Vector.Zero, fam)

    elseif variant == PickupVariant.PICKUP_KEY then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, pos, Vector.Zero, fam)

    elseif variant == PickupVariant.PICKUP_BOMB then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, pos, Vector.Zero, fam)
    end
end

bumUtils.RegisterBum(FAIR_BUM, fairBum)

return fairBum