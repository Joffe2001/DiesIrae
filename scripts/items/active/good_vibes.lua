local GoodVibes = {}
GoodVibes.COLLECTIBLE_ID = Enums.Items.GoodVibes

function GoodVibes:UseItem()
    local entities = Isaac.GetRoomEntities()
    local transformed = false

    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_HEART then
            local subtype = entity.SubType
            local pos = entity.Position

            -- Check each subtype and spawn soul hearts accordingly
            if subtype == HeartSubType.HEART_HALF then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, pos, Vector.Zero, nil)
                entity:Remove()
                transformed = true

            elseif subtype == HeartSubType.HEART_FULL then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, pos, Vector.Zero, nil)
                entity:Remove()
                transformed = true

            elseif subtype == HeartSubType.HEART_DOUBLEPACK then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, pos + Vector(-5, 0), Vector.Zero, nil)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, pos + Vector(5, 0), Vector.Zero, nil)
                entity:Remove()
                transformed = true
            end
        end
    end

    if transformed then
        SfxManager:Play(178) 
    else
        SfxManager:Play(267)
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

function GoodVibes:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, GoodVibes.UseItem, GoodVibes.COLLECTIBLE_ID)

    if EID then
        EID:addCollectible(
            GoodVibes.COLLECTIBLE_ID,
            "Transforms all red heart pickups in the room into soul hearts. Half red → half soul, double red → two soul hearts.",
            "Good Vibes",
            "en_us"
        )
    end
end

return GoodVibes
