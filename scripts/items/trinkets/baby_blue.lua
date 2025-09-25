local BabyBlue = {}
local TrinketID = Isaac.GetTrinketIdByName("Baby Blue")

-- Replace red heart pickups with soul/black hearts
function BabyBlue:OnPickupInit(pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end

    local player = Isaac.GetPlayer(0)
    if not player:HasTrinket(TrinketID) then return end

    -- Only convert full or half red hearts
    if pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_HALF then
        local rng = RNG()
        rng:SetSeed(pickup.InitSeed, 35)

        local isGolden = player:HasTrinket(TrinketID + TrinketType.TRINKET_GOLDEN_FLAG)
        local chance = isGolden and 0.05 or 0

        if rng:RandomFloat() < chance then
            -- 5% chance to become a black heart
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, true, true, false)
        else
            -- Otherwise becomes a soul heart
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, true, true, false)
        end
    end
end

-- Initialization function to register the callback and EID
function BabyBlue:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, BabyBlue.OnPickupInit)

    if EID then
        EID:addTrinket(
            TrinketID,
            "All red heart drops become Soul Hearts.#Golden: 5% of them become Black Hearts.",
            "Baby Blue",
            "en_us"
        )
    end
end

return BabyBlue
