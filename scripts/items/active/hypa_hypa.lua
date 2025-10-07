local mod = DiesIraeMod

local HypaHypa = {}

---@param player EntityPlayer
function HypaHypa:UseItem(_, _, player)
    if RNG():RandomFloat() <= 0.1 then
        local itemConfig = Isaac.GetItemConfig()
        local quality4Items = {}

        for i = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
            local item = itemConfig:GetCollectible(i)
            if item and item.Quality == 4 and not item.Hidden then
                table.insert(quality4Items, i)
            end
        end

        if #quality4Items > 0 then
            local chosen = quality4Items[RNG():RandomInt(#quality4Items) + 1]
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, chosen, player.Position, Vector.Zero, nil)
        end
    else
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_POOP, player.Position, Vector.Zero, nil)
    end

    return {
        Discharge = false,
        Remove = true,
        ShowAnim = true
    }
end

---@param collectible CollectibleType
function HypaHypa:OnGetItem(collectible)
    if collectible == mod.Items.HypaHypa then
        local pickupIndex = 0
        local entities = Isaac.GetRoomEntities()
        for _, entity in pairs(entities) do
            local pickup = entity:ToPickup()
            if pickup then
                local collectibleCycle = pickup:GetCollectibleCycle()
                for _, item in pairs(collectibleCycle) do
                    if item == mod.Items.HypaHypa then
                        pickupIndex = pickup:SetNewOptionsPickupIndex()
                    end
                end
            end
        end
        local itemPool = Game():GetItemPool()
        local room = Game():GetRoom()
        local altOptionEntity = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            itemPool:GetCollectible(itemPool:GetLastPool(), true), 
            room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
        local altOptionPickup = altOptionEntity:ToPickup()
        if altOptionPickup then
            altOptionPickup:SetForceBlind(true)
            altOptionPickup.OptionsPickupIndex = pickupIndex
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, HypaHypa.UseItem, mod.Items.HypaHypa)
