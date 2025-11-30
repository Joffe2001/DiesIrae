local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")

local SCAMMER_BUM = mod.Entities.FAMILIAR_ScammerBum.Var
local SCAMMER_ITEM_CHANCE = 0.10

---@class scammerBum
local scammerBum = {}
scammerBum.Item = mod.Items.ScammerBum

scammerBum.Accepts = {
    [PickupVariant.PICKUP_COIN] = true
}

scammerBum.ReachDistance = 20

function scammerBum.OnInit(fam)
    fam:GetSprite():Play("IdleDown", true)
end

function scammerBum.Reward(fam)
    local rng = fam:GetDropRNG()
    return rng:RandomFloat() < SCAMMER_ITEM_CHANCE
end

function scammerBum.DoReward(fam)
    local rng = fam:GetDropRNG()
    local itemPool = Game():GetItemPool() 
    local shopPool = ItemPoolType.POOL_SHOP
    local itemId = itemPool:GetCollectible(shopPool, false)

    if itemId then
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_SHOPITEM,
            itemId,
            Isaac.GetFreeNearPosition(fam.Position, 20),
            Vector.Zero,
            fam
        )
    end
end

function scammerBum.CheckForAcceptableItem(fam)
    local data = fam:GetData()
    if not data.TargetPickup or not data.TargetPickup:Exists() then
        local best, _ = bumUtils.FindPickupAnywhere(fam, scammerBum.Accepts)
        if best then
            data.TargetPickup = best
            best:Remove()

            if scammerBum.Reward(fam) then
                scammerBum.DoReward(fam)
            end
        end
    end
end

bumUtils.RegisterBum(SCAMMER_BUM, scammerBum)

return scammerBum
