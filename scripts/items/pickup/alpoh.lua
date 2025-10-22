local mod = DiesIraeMod
local alpoh = {}

function mod:usePieceOfHeaven(card, player, flags)
    if card == mod.Cards.alpoh then
        player:AddBrokenHearts(2)

        local itemID = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_ANGEL)
        local spawnPos = Isaac.GetFreeNearPosition(player.Position + Vector(40, 0), 40)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, spawnPos, Vector.Zero, nil)
        SFXManager():Play(SoundEffect.SOUND_HOLY, 1.0, 0, false, 1)
        return true
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.usePieceOfHeaven)

return alpoh