---@class ModReference
local mod = DiesIraeMod

local function GetTotalValidCollectibles(player)
    local total = 0

    for id = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
        if id ~= mod.Items.Harp
        and id ~= mod.Items.HarpString then
            total = total + player:GetCollectibleNum(id)
        end
    end

    return total
end

function mod:OnHarpEvaluateCache(player, flag)
    if flag ~= CacheFlag.CACHE_DAMAGE then return end

    if player:GetPlayerType() ~= mod.Players.David then
        return
    end
    if not player:HasCollectible(mod.Items.Harp) then
        return
    end

    local totalItems = GetTotalValidCollectibles(player)
    local multiplier = 1 + (totalItems * 0.15)

    player.Damage = player.Damage * multiplier
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnHarpEvaluateCache)
