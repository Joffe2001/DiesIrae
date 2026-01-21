local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")
local sfx = SFXManager()
local RED_BUM = mod.Entities.FAMILIAR_RedBum.Var

---@class RedBum
local redBum = {}

redBum.Item = mod.Items.RedBum

redBum.Accepts = {
    [PickupVariant.PICKUP_KEY] = true
}

redBum.FollowDistance = 40
redBum.ReachDistance  = 20

-- Stackable rewards
redBum.BaseRewardChance  = 0.10
redBum.StackRewardChance = true

function redBum.OnInit(fam)
    local data = fam:GetData()
    data.KeysEaten = 0
end

function redBum.Reward(fam)
    local data = fam:GetData()
    local pickup = data.TargetPickup
    if not pickup then return false end

    local subtype = pickup.SubType
    sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 1.0, 0, false, 1.0)

    -- Golden keys always trigger reward
    if subtype == KeySubType.KEY_GOLDEN then
        data.ForceDoubleDrop = true
        return true
    end

    -- Calculate chance
    data.KeysEaten = (data.KeysEaten or 0) + 1
    local chance = bumUtils.GetCurrentRewardChance(fam, redBum)
    if chance > 1 then chance = 1 end

    return fam:GetDropRNG():RandomFloat() < chance
end

function redBum.DoReward(fam)
    local data = fam:GetData()
    local pos  = Isaac.GetFreeNearPosition(fam.Position, 20)
    local rng  = fam:GetDropRNG()

    if data.ForceDoubleDrop then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, pos, Vector.Zero, fam)
        if rng:RandomFloat() < 0.5 then
            local pos2 = Isaac.GetFreeNearPosition(fam.Position, 20)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, pos2, Vector.Zero, fam)
        end
        data.ForceDoubleDrop = false
        data.KeysEaten = 0
        return
    end

    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, pos, Vector.Zero, fam)
    data.KeysEaten = 0
end

bumUtils.RegisterBum(RED_BUM, redBum)
return redBum
