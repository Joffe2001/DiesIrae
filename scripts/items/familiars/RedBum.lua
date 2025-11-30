local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")

local RED_BUM = mod.Entities.FAMILIAR_RedBum.Var
local CRACKED_KEY_CHANCE = 0.30

---@class RedBum
local redBum = {}
redBum.Item = mod.Items.RedBum

redBum.Accepts = {
    [PickupVariant.PICKUP_KEY] = true
}

redBum.ReachDistance = 20
function redBum.OnInit(fam)
    fam:GetSprite():Play("IdleDown", true)
end

function redBum.Reward(fam)
    local rng = fam:GetDropRNG()
    return rng:RandomFloat() < CRACKED_KEY_CHANCE
end

function redBum.DoReward(fam)
    Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_TAROTCARD,
        Card.CARD_CRACKED_KEY,
        Isaac.GetFreeNearPosition(fam.Position, 20),
        Vector.Zero,
        fam
    )
end

bumUtils.RegisterBum(RED_BUM, redBum)

return redBum