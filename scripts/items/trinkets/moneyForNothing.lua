local MOD = RegisterMod("MoneyForNothing", 1)
local ITEM_ID = Isaac.GetItemIdByName("Money for Nothing")
local TrinketID = Isaac.GetTrinketIdByName("Money for Nothing")
local hasTakenItem = false
local trinketDropped = false

-- This callback is triggered when a player picks up an item
function MOD:onPickupItem(player, pickup)
    if player:HasTrinket(TrinketID) then
        -- If the player has already taken an item, prevent further pickups
        if hasTakenItem then
            pickup:Remove()  -- Remove the item from the room
        else
            hasTakenItem = true  -- Mark that the player has taken an item
        end
    end
end
MOD:AddCallback(ModCallbacks.MC_POST_PICKUP, MOD.onPickupItem)

-- This callback is triggered when the player picks up the trinket
function MOD:onTrinketPickup(player)
    if player:HasTrinket(TrinketID) then
        trinketDropped = false  -- Reset the flag when trinket is picked up
        -- Make all shop items free when trinket is picked up
        for _, item in pairs(Isaac.GetRoomEntities()) do
            if item.Type == EntityType.ENTITY_PICKUP and item.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                item.Price = 0  -- Set the price to 0 to make the item free
            end
        end
    end
end
MOD:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, MOD.onTrinketPickup) -- This checks when the trinket is picked up for the first time

-- This callback is triggered after the shop room is opened
function MOD:onShopOpened()
    if trinketDropped then
        -- If the trinket is dropped, make the shop empty (no items)
        for _, item in pairs(Isaac.GetRoomEntities()) do
            if item.Type == EntityType.ENTITY_PICKUP and item.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                item:Remove()  -- Remove the item from the shop
            end
        end
    else
        -- Make all shop items free if the player has the trinket
        if Isaac.GetPlayer(0):HasTrinket(TrinketID) then
            for _, item in pairs(Isaac.GetRoomEntities()) do
                if item.Type == EntityType.ENTITY_PICKUP and item.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                    item.Price = 0  -- Set the price to 0 to make the item free
                end
            end
        end
    end
end
MOD:AddCallback(ModCallbacks.MC_POST_SHOP, MOD.onShopOpened)

-- This callback is triggered after a devil deal room is opened
function MOD:onDevilDealOpened()
    if Isaac.GetPlayer(0):HasTrinket(TrinketID) and not trinketDropped then
        -- Make all Devil Deal items free if the player has the trinket
        for _, item in pairs(Isaac.GetRoomEntities()) do
            if item.Type == EntityType.ENTITY_PICKUP and item.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                item.Price = 0  -- Set the price to 0 to make the item free
            end
        end
    end
end
MOD:AddCallback(ModCallbacks.MC_POST_DEVIL, MOD.onDevilDealOpened)

-- This callback resets the item-taking flag when moving to a new room
function MOD:onPlayerUpdate(player)
    -- Reset the item-taking flag when moving to a new room
    if player:GetRoom():GetType() == RoomType.ROOM_SHOP or player:GetRoom():GetType() == RoomType.ROOM_DEVIL then
        hasTakenItem = false
    end
end
MOD:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, MOD.onPlayerUpdate)

-- This callback tracks when the trinket is dropped
function MOD:onTrinketDrop(player)
    if not player:HasTrinket(TrinketID) then
        -- The player has dropped the trinket, so set the flag
        trinketDropped = true
        -- Once dropped, make the shop empty (remove all items) but leave the devil deal alone
        if player:GetRoom():GetType() == RoomType.ROOM_SHOP then
            for _, item in pairs(Isaac.GetRoomEntities()) do
                if item.Type == EntityType.ENTITY_PICKUP and item.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                    item:Remove()  -- Remove the item from the shop
                end
            end
        end
    end
end
MOD:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, MOD.onTrinketDrop)