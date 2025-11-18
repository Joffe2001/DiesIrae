local mod = DiesIraeMod
local SatansNail = {}

function SatansNail:OnUse(itemID, rng, player, flags, slot, varData)
    if itemID ~= mod.Cards.SatansNail then return end
    local room = Game():GetRoom()
    local pos = room:FindFreePickupSpawnPosition(player.Position, 40, true)

    Isaac.Spawn(
        EntityType.ENTITY_SLOT,
        SlotVariant.SLOT_DEMON_BEGGAR,
        0,
        room:FindFreePickupSpawnPosition(pos, 20, true),
        Vector.Zero,
        player
    )

    local devilPool = ItemPoolType.POOL_DEVIL
    local itemID = Game():GetItemPool():GetCollectible(devilPool, true, rng:Next(), CollectibleType.COLLECTIBLE_NULL)

    Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        itemID,
        room:FindFreePickupSpawnPosition(pos, 60, true),
        Vector.Zero,
        player
    )
    return true
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, SatansNail.OnUse)
