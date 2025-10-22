local mod = DiesIraeMod
local RottenFood = {}

function RottenFood:OnPickupInit(pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end

    local player = Isaac.GetPlayer(0)
    if not player:HasTrinket(mod.Trinkets.RottenFood) then return end

    if pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_HALF then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, true, true, false)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, RottenFood.OnPickupInit)
