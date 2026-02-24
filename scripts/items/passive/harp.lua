---@class ModReference
local mod = DiesIraeMod
local Harp = {}

mod.CollectibleType.COLLECTIBLE_THE_HARP = Isaac.GetItemIdByName("The Harp")

local function GetTotalValidCollectibles(player)
    local total = 0

    for id = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
        if id ~= mod.CollectibleType.COLLECTIBLE_THE_HARP
        and id ~= mod.CollectibleType.COLLECTIBLE_HARP_STRING then
            total = total + player:GetCollectibleNum(id)
        end
    end

    return total
end

function Harp:OnHarpEvaluateCache(player, flag)
    if flag ~= CacheFlag.CACHE_DAMAGE then return end

    if player:GetPlayerType() ~= mod.Players.David then
        return
    end
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_THE_HARP) then
        return
    end

    local totalItems = GetTotalValidCollectibles(player)
    local multiplier = 1 + (totalItems * 0.15)

    player.Damage = player.Damage * multiplier
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Harp.OnHarpEvaluateCache)
