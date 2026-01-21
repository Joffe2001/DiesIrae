local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")
local sfx = SFXManager()

local TAROT_BUM = mod.Entities.FAMILIAR_TarotBum.Var

---@type TarotBum
local tarotBum = {}

tarotBum.Item = mod.Items.TarotBum

tarotBum.Accepts = function(fam, pickup)

    if pickup.Variant ~= PickupVariant.PICKUP_TAROTCARD then return false end
    if pickup.Price and pickup.Price > 0 then return false end

    local subtype = pickup.SubType

    for _, card in ipairs(mod.Pools.TarotCards) do
        if card == subtype then
            return true
        end
    end
    for _, card in ipairs(mod.Pools.ReverseCards) do
        if card == subtype then
            return true
        end
    end

    return false
end

tarotBum.FollowDistance = 40
tarotBum.ReachDistance  = 20


tarotBum.BaseRewardChance  = 0.25
tarotBum.StackRewardChance = true

local function IsInPool(pool, card)
    for _, c in ipairs(pool) do
        if c == card then
            return true
        end
    end
    return false
end

function tarotBum.OnInit(fam)
    local data = fam:GetData()
    data.CardsCollected = 0
end

function tarotBum.Reward(fam)
    local data   = fam:GetData()
    local pickup = data.TargetPickup
    if not pickup then return false end

    data.PickupStack = (data.PickupStack or 0) + 1
    local chance = bumUtils.GetCurrentRewardChance(fam, tarotBum)
    if chance > 1 then chance = 1 end

    if fam:GetDropRNG():RandomFloat() >= chance then
        return false
    end

    local rng = fam:GetDropRNG()
    local subtype = pickup.SubType
    local pos = Isaac.GetFreeNearPosition(fam.Position, 10)

    if subtype == Card.CARD_JOKER then
        local heartType = HeartSubType.HEART_RED
        local rand = rng:RandomInt(4)
        if rand == 0 then
            heartType = HeartSubType.HEART_SOUL
        elseif rand == 1 then
            heartType = HeartSubType.HEART_ROTTEN
        elseif rand == 2 then
            heartType = HeartSubType.HEART_BLACK
        elseif rand == 3 then
            heartType = HeartSubType.HEART_ETERNAL
        end
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, heartType, pos, Vector.Zero, fam)

    elseif subtype == Card.CARD_HOLY then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL, pos, Vector.Zero, fam)

    elseif IsInPool(mod.Pools.TarotCards, subtype) then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, pos, Vector.Zero, fam)

    elseif IsInPool(mod.Pools.ReverseCards, subtype) then
        local heartType = HeartSubType.HEART_ROTTEN
        if rng:RandomFloat() < 0.3 then
            heartType = HeartSubType.HEART_BLACK
        end
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, heartType, pos, Vector.Zero, fam)

    else
        return false
    end

    data.CardsCollected = (data.CardsCollected or 0) + 1
    data.PickupStack = 0
    return true
end

function tarotBum.DoReward(fam)
    tarotBum.Reward(fam)
end

bumUtils.RegisterBum(TAROT_BUM, tarotBum)
return tarotBum
