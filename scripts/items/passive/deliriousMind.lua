local mod = DiesIraeMod
local DeliriousMind = {}
testtesttesttest
mod.Items

mod.CollectibleType.COLLECTIBLE_DELIRIOUS_MIND = Isaac.GetItemIdByName("Delirious Mind")

local VANILLA_MAX_ID = CollectibleType.NUM_COLLECTIBLES - 1
local playerItemCache = {}
local bonusStats = {}

local function IsVanillaItem(itemID)
    return itemID <= VANILLA_MAX_ID
end

local MAX_ITEM_ID = Isaac.GetItemConfig():GetCollectibles().Size - 1

function DeliriousMind:OnPlayerUpdate(player)
    local id = player.Index
    playerItemCache[id] = playerItemCache[id] or {}
    bonusStats[id] = bonusStats[id] or { tears = 0, damage = 0 }

    for itemID = 1, MAX_ITEM_ID do
        local hasItem = player:HasCollectible(itemID)
        local hadItem = playerItemCache[id][itemID]

        if hasItem and not hadItem then
            if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_DELIRIOUS_MIND)
            and not IsVanillaItem(itemID) then

                bonusStats[id].tears = bonusStats[id].tears + 0.15
                bonusStats[id].damage = bonusStats[id].damage + 0.15

                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end
        end

        playerItemCache[id][itemID] = hasItem
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, DeliriousMind.OnPlayerUpdate)

function DeliriousMind:OnEvaluateCache(player, flag)
    local id = player.Index
    if not bonusStats[id] then return end

    if flag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay - (bonusStats[id].tears * 3)
    end

    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + bonusStats[id].damage
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DeliriousMind.OnEvaluateCache)
