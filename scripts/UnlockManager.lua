local g = Game()
local save = require("savedata")

local Manager = {}

-- Map unlocks to items/trinkets
local itemToUnlock = {
    [Isaac.GetItemIdByName("Army of Lovers")]        = { Unlock = "MomsHeart" },
    [Isaac.GetItemIdByName("The Bad Touch")]         = { Unlock = "Isaac" },
    [Isaac.GetItemIdByName("Little Lies")]           = { Unlock = "Satan" },
    [Isaac.GetItemIdByName("Paranoid Android")]      = { Unlock = "Lamb" },
    [Isaac.GetItemIdByName("Sh-boom!!")]             = { Unlock = "MegaSatan" },
    [Isaac.GetItemIdByName("Universal")]             = { Unlock = "BossRush" },
    [Isaac.GetItemIdByName("Everybody's Changing")]  = { Unlock = "Hush" },
    [Isaac.GetItemIdByName("U2")]                    = { Unlock = "Beast" },
    [Isaac.GetItemIdByName("Killer Queen")]          = { Unlock = "Corpse" },
    [Isaac.GetItemIdByName("Ring of Fire")]          = { Unlock = "Greedier" },
    [Isaac.GetItemIdByName("Helter Skelter")]        = { Unlock = "Delirium" },
}

local trinketToUnlock = {
    [Isaac.GetTrinketIdByName("Baby Blue")]  = { Unlock = "BlueBaby" },
    [Isaac.GetTrinketIdByName("Wonder of You")] = { Unlock = "Greed" },
}

function Manager.postPlayerInit(player)
    if not save.UnlockData.PlayerDavid then
        save.UnlockData.PlayerDavid = {
            MomsHeart = { Unlock = false },
            Isaac = { Unlock = false },
            BlueBaby = { Unlock = false },
            Satan = { Unlock = false },
            Lamb = { Unlock = false },
            MegaSatan = { Unlock = false },
            BossRush = { Unlock = false },
            Hush = { Unlock = false },
            Beast = { Unlock = false },
            Corpse = { Unlock = false },
            Greed = { Unlock = false },
            Greedier = { Unlock = false },
            Delirium = { Unlock = false },
        }
    end

    if g:GetFrameCount() > 0 then return end

    for item, tab in pairs(itemToUnlock) do
        if not save.UnlockData.PlayerDavid[tab.Unlock].Unlock then
            g:GetItemPool():RemoveCollectible(item)
        end
    end

    for trinket, tab in pairs(trinketToUnlock) do
        if not save.UnlockData.PlayerDavid[tab.Unlock].Unlock then
            g:GetItemPool():RemoveTrinket(trinket)
        end
    end
end

function Manager.postPickupInit(pickup)
    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local tab = itemToUnlock[pickup.SubType]
        if tab and not save.UnlockData.PlayerDavid[tab.Unlock].Unlock then
            local pool = g:GetItemPool():GetPoolForRoom(g:GetRoom():GetType(), g:GetLevel():GetCurrentRoomDesc().SpawnSeed)
            local newItem = g:GetItemPool():GetCollectible(pool, true, pickup.InitSeed)
            g:GetItemPool():RemoveCollectible(pickup.SubType)
            pickup:Morph(pickup.Type, pickup.Variant, newItem, true, true, true)
        end
    elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
        local tab = trinketToUnlock[pickup.SubType]
        if tab and not save.UnlockData.PlayerDavid[tab.Unlock].Unlock then
            g:GetItemPool():RemoveTrinket(pickup.SubType)
            pickup:Morph(pickup.Type, pickup.Variant, g:GetItemPool():GetTrinket(), true, true, true)
        end
    end
end

function Manager.postPlayerUpdate(player)
    for item, tab in pairs(itemToUnlock) do
        if player:HasCollectible(item) and not save.UnlockData.PlayerDavid[tab.Unlock].Unlock then
            player:RemoveCollectible(item)
            local newItem = g:GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, true, player.InitSeed)
            player:AddCollectible(newItem)
        end
    end

    for trinket, tab in pairs(trinketToUnlock) do
        if player:HasTrinket(trinket) and not save.UnlockData.PlayerDavid[tab.Unlock].Unlock then
            player:TryRemoveTrinket(trinket)
            player:AddTrinket(g:GetItemPool():GetTrinket())
        end
    end
end

return Manager
