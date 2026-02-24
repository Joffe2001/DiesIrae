local mod = DiesIraeMod
local game = Game()
local stabWound = {
    FLAT_TEARS_UP = 0.5,
}

mod.CollectibleType.COLLECTIBLE_STAB_WOUND = Isaac.GetItemIdByName("Stab Wound")

---@param player EntityPlayer
function stabWound:onCache(player, cacheFlag)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_STAB_WOUND) then return end

    local num = player:GetCollectibleNum(mod.CollectibleType.COLLECTIBLE_STAB_WOUND, false)
    
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local currentTears = 30 / (player.MaxFireDelay + 1)
        local newTears = currentTears + stabWound.FLAT_TEARS_UP * num
        player.MaxFireDelay = math.max(1, (30 / newTears) - 1)
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, stabWound.onCache)

---@param player EntityPlayer
function stabWound:onPostAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    ---@diagnostic disable-next-line: param-type-mismatch
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
    player:AddCollectible(CollectibleType.COLLECTIBLE_STEVEN, 0, false)
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, stabWound.onPostAddCollectible, mod.CollectibleType.COLLECTIBLE_STAB_WOUND)
