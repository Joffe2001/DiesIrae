local Unsainted = {}
Unsainted.COLLECTIBLE_ID = Isaac.GetItemIdByName("Unsainted")
local game = Game()

---------------------------------------------------
-- Override item pools: replace with Devil results
---------------------------------------------------
function Unsainted:onGetCollectible(pool, decrease, seed)
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(Unsainted.COLLECTIBLE_ID) then
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
    if not player:HasCollectible(Unsainted.COLLECTIBLE_ID) then return end

    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local item = pickup:ToPickup()
        item.Price = PickupPrice.PRICE_TWO_HEARTS
        item.AutoUpdatePrice = false
    end
end

---------------------------------------------------
-- Init callbacks
---------------------------------------------------
function Unsainted:Init(mod)
    mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, function(_, pool, decrease, seed)
        return Unsainted:onGetCollectible(pool, decrease, seed)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
        Unsainted:onPickupInit(pickup)
    end, PickupVariant.PICKUP_COLLECTIBLE)

    if EID then
        EID:addCollectible(
            Unsainted.COLLECTIBLE_ID,
            "All item pools are {{DevilRoom}} Devil Pool.#All collectibles cost {{Heart}} {{Heart}} 2 Red Heart Containers.",
            "Unsainted",
            "en_us"
        )
    end
end

return Unsainted
