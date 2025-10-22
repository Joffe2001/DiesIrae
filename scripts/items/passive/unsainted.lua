local mod = DiesIraeMod

local Unsainted = {}
local game = Game()

function Unsainted:onGetCollectible(pool, decrease, seed)
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.Items.Unsainted) then
        return nil
    end

    local itemPool = game:GetItemPool()
    local devilItem = itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, decrease, seed, CollectibleType.COLLECTIBLE_NULL)

    if devilItem == CollectibleType.COLLECTIBLE_NULL then
        devilItem = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, decrease, seed, CollectibleType.COLLECTIBLE_NULL)
    end

    if devilItem == CollectibleType.COLLECTIBLE_NULL then
        devilItem = itemPool:GetCollectible(ItemPoolType.POOL_ALL, decrease, seed, CollectibleType.COLLECTIBLE_NULL)
    end

    return devilItem
end

function Unsainted:onPickupInit(pickup)
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.Items.Unsainted) then return end

    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local item = pickup:ToPickup()
        item.Price = PickupPrice.PRICE_ONE_HEART
        item.AutoUpdatePrice = false
        local data = item:GetData()
        data.BrokenHeartPrice = true
    end
end

function Unsainted:onPickup(player, pickup)
    if not player:HasCollectible(mod.Items.Unsainted) then return end

    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local data = pickup:GetData()
        if data.BrokenHeartPrice then
            player:AddBrokenHearts(1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, Unsainted.onGetCollectible)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Unsainted.onPickupInit, PickupVariant.PICKUP_COLLECTIBLE)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLECT, Unsainted.onPickup)

if EID then
    EID:assignTransformation("collectible", mod.Items.Unsainted, "Isaac's sinful Playlist")
end
