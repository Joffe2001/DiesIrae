local mod = DiesIraeMod

local Unsainted = {}
local game = Game()

---------------------------------------------------
-- Override item pools: replace with Devil results
---------------------------------------------------
function Unsainted:onGetCollectible(pool, decrease, seed)
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.Items.Unsainted) then
        return nil -- let vanilla handle
    end

    local itemPool = game:GetItemPool()

    -- Roll Devil item regardless of the requested pool
    local devilItem = itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, decrease, seed, CollectibleType.COLLECTIBLE_NULL)

    -- Fallback to Treasure pool if Devil pool is empty
    if devilItem == CollectibleType.COLLECTIBLE_NULL then
        devilItem = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, decrease, seed, CollectibleType.COLLECTIBLE_NULL)
    end

    -- Last fallback: just give something random to prevent softlock
    if devilItem == CollectibleType.COLLECTIBLE_NULL then
        devilItem = itemPool:GetCollectible(ItemPoolType.POOL_ALL, decrease, seed, CollectibleType.COLLECTIBLE_NULL)
    end

    return devilItem
end

---------------------------------------------------
-- Make all collectibles cost 2 heart containers
---------------------------------------------------
function Unsainted:onPickupInit(pickup)
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.Items.Unsainted) then return end

    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local item = pickup:ToPickup()
        item.Price = PickupPrice.PRICE_TWO_HEARTS
        item.AutoUpdatePrice = false
    end
end

---------------------------------------------------
-- Init callbacks
---------------------------------------------------
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, Unsainted.onGetCollectible)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Unsainted.onPickupInit, PickupVariant.PICKUP_COLLECTIBLE)

