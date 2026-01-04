local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")
local sfx = SFXManager()
local RED_BUM = mod.Entities.FAMILIAR_RedBum.Var
local BASE_CHANCE = 0.10

---@class RedBum
local redBum = {}

redBum.Item = mod.Items.RedBum

redBum.Accepts = {
    [PickupVariant.PICKUP_KEY] = true
}

redBum.FollowDistance = 40
redBum.ReachDistance  = 20

function redBum.OnInit(fam)
    fam:GetData().KeysEaten = 0
end

function redBum.OnUpdate(fam)
	fam:followParent()
end

function redBum.Reward(fam)
    local data   = fam:GetData()
    local rng    = fam:GetDropRNG()
    local pickup = fam:GetData().TargetPickup
    if not pickup then return false end

    local subtype = pickup.SubType
    sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 1.0, 0, false, 1.0)

    if subtype == KeySubType.KEY_GOLDEN then
        data.ForceDoubleDrop = true
        return true
    end

    if subtype == KeySubType.KEY_DOUBLEPACK then
        data.KeysEaten = (data.KeysEaten or 0) + 2
        local chance = BASE_CHANCE * (2 ^ (data.KeysEaten - 1))
        if chance > 1 then chance = 1 end
        return rng:RandomFloat() < chance
    end

    if subtype == KeySubType.KEY_CHARGED then
        data.KeysEaten = (data.KeysEaten or 0)
        return rng:RandomFloat() < 0.5
    end

    data.KeysEaten = (data.KeysEaten or 0) + 1

    local chance = BASE_CHANCE * (2 ^ (data.KeysEaten - 1))
    if chance > 1 then chance = 1 end

    return rng:RandomFloat() < chance
end

function redBum.DoReward(fam)
    local data = fam:GetData()

    local pos = Isaac.GetFreeNearPosition(fam.Position, 20)

    if data.ForceDoubleDrop then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, pos, Vector.Zero, fam)

        if fam:GetDropRNG():RandomFloat() < 0.5 then
            local pos2 = Isaac.GetFreeNearPosition(fam.Position, 20)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, pos2, Vector.Zero, fam)
        end

        data.ForceDoubleDrop = false
        return
    end
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, pos, Vector.Zero, fam)

    data.KeysEaten = 0
end

bumUtils.RegisterBum(RED_BUM, redBum)

return redBum
