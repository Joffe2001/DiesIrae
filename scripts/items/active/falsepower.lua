local mod = DiesIraeMod
local FalsePower = {}

FalsePower.Quality4Items = {}
for id = 1, CollectibleType.NUM_COLLECTIBLES do
    local cfg = Isaac.GetItemConfig():GetCollectible(id)
    if cfg and cfg.Quality == 4 then
        table.insert(FalsePower.Quality4Items, id)
    end
end

local activeEffect = {}

function FalsePower:OnUse(itemID, rng, player, flags, slot)
    if itemID ~= mod.Items.FalsePower then return end

    local pIndex = player.Index

    if activeEffect[pIndex] then
        player:TryRemoveInnateCollectible(activeEffect[pIndex])
        activeEffect[pIndex] = nil
    end

    local poolList = FalsePower.Quality4Items
    if #poolList == 0 then return end

    local rolled = poolList[rng:RandomInt(#poolList) + 1]

    player:AddInnateCollectible(rolled)
    activeEffect[pIndex] = rolled

    local itemPool = Game():GetItemPool()
    for pool = 0, ItemPoolType.NUM_ITEMPOOLS - 1 do
        itemPool:RemoveCollectible(rolled)
    end

    for i, v in ipairs(FalsePower.Quality4Items) do
        if v == rolled then
            table.remove(FalsePower.Quality4Items, i)
            break
        end
    end

    return true
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, FalsePower.OnUse, mod.Items.FalsePower)

function FalsePower:OnNewRoom()
    for i = 0, Game():GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(i)
        local idx = p.Index
        if activeEffect[idx] then
            p:TryRemoveInnateCollectible(activeEffect[idx])
            activeEffect[idx] = nil
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, FalsePower.OnNewRoom)
