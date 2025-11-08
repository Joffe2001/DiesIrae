local mod = DiesIraeMod
local game = Game()

function mod:UseRewrappingPaper(_, _, player, _, _)
    local mysteryGiftID = CollectibleType.COLLECTIBLE_MYSTERY_GIFT
    local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)

    for _, ent in ipairs(pickups) do
        local pickup = ent:ToPickup()
        local data = pickup:GetData()

        if pickup.SubType ~= mysteryGiftID and not data.GiftSpawned and pickup.SubType > 0 then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mysteryGiftID, true, true, true)
            data.GiftSpawned = true
        end
    end

    return true
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseRewrappingPaper, mod.Items.RewrappingPaper)
