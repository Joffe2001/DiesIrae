local RottenFood = {}
RottenFood.TRINKET_ID = Isaac.GetTrinketIdByName("Rotten Food")
local game = Game()

-- Called when a heart pickup is initialized
function RottenFood:onPickup(pickup)
    local player = game:GetPlayer(0)
    
    -- Check if the pickup is a heart and the player has the Rotten Food trinket
    if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_HEART then
        if player:HasTrinket(RottenFood.TRINKET_ID) then
            -- If it's a Red Heart, change it to a Rotten Heart
            if pickup.SubType == HeartSubType.HEART_RED then
                -- Spawn a Rotten Heart instead of the regular Red Heart
                local rottenHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, pickup.Position, Vector.Zero, nil)
                rottenHeart:ToPickup().PlaySound = false  -- Optional: prevent sound on pickup
                
                -- Remove the original red heart pickup
                pickup:Remove()
            end
        end
    end
end

-- Init callbacks
function RottenFood:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, RottenFood.onPickup)

    if EID then
        EID:addTrinket(
            RottenFood.TRINKET_ID,
            "All red heart pickups are converted into Rotten Hearts.",
            "Rotten Food",
            "en_us"
        )
    end
end

return RottenFood
