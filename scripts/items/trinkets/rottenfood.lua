local RottenFood = {}
RottenFood.TRINKET_ID = Enums.Items.RottenFood
local game = Game()
-- Called on each pickup's first frame
function RottenFood:onPickupUpdate(pickup)
    if pickup.FrameCount > 1 then return end
    if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end
    if pickup.SubType ~= HeartSubType.HEART_RED then return end

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(RottenFood.TRINKET_ID) then
            -- Spawn poof effect
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)

            -- Replace with Rotten Heart
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, pickup.Position, Vector.Zero, nil)

            -- Remove original Red Heart
            pickup:Remove()

            break -- one player with trinket is enough
        end
    end
end

-- Init callbacks
function RottenFood:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, RottenFood.onPickupUpdate)

    if EID then
        EID:addTrinket(
            RottenFood.TRINKET_ID,
            "Red Heart pickups are replaced with Rotten Hearts.",
            "Rotten Food",
            "en_us"
        )
    end
end

return RottenFood
