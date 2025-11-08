local mod = DiesIraeMod

local BabyBlue = {}

function BabyBlue:OnPickupInit(pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end

    local player = Isaac.GetPlayer(0)
    if not player:HasTrinket(mod.Trinkets.BabyBlue) then return end

    if pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_HALF then
        local rng = RNG()
        rng:SetSeed(pickup.InitSeed, 35)

        local isGolden = player:HasTrinket(mod.Trinkets.BabyBlue + TrinketType.TRINKET_GOLDEN_FLAG)
        local chance = isGolden and 0.05 or 0

        if rng:RandomFloat() < chance then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, true, true, false)
        else
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, true, true, false)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, BabyBlue.OnPickupInit)
