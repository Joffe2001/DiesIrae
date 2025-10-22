local mod = DiesIraeMod

local GoodVibes = {}

function GoodVibes:UseItem()
    local entities = Isaac.GetRoomEntities()
    local transformed = false

    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_HEART then
            local subtype = entity.SubType
            local pos = entity.Position

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
        SFXManager():Play(178) 
    else
        SFXManager():Play(267)
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, GoodVibes.UseItem, mod.Items.GoodVibes)