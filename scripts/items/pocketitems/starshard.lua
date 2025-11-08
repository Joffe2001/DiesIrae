local mod = DiesIraeMod

function mod:useStarShard(card, player, flags)
    if card ~= mod.Cards.StarShard then
        return
    end

    local room = Game():GetRoom()
    local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    local hasPedestal = false

    for _, entity in ipairs(pickups) do
        local pickup = entity:ToPickup()
        if pickup and pickup.SubType > 0 then
            hasPedestal = true
            break
        end
    end

    if not hasPedestal then
        player:AddSoulHearts(2)
        SFXManager():Play(SoundEffect.SOUND_HOLY, 1.0, 0, false, 1.0)
    else
        local pool = Game():GetItemPool()
        for _, entity in ipairs(pickups) do
            local pickup = entity:ToPickup()
            if pickup and pickup.SubType > 0 then
                local newItem = pool:GetCollectible(ItemPoolType.POOL_PLANETARIUM, true, Random())
                pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true)
            end
        end
        SFXManager():Play(913, 1.0, 0, false, 1.0)
    end

    return true
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useStarShard)
