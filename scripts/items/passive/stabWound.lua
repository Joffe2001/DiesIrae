local mod = DiesIraeMod

local stabWound = {
    FLAT_TEARS_UP = 0.5,
    FLAT_DMG_UP = 1,
}
local game = Game()

---@param player EntityPlayer
function stabWound:onCache(player, cacheFlag)
    if not player:HasCollectible(mod.Items.StabWound) then return end

    local num = player:GetCollectibleNum(mod.Items.StabWound, false)
    
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local currentTears = 30 / (player.MaxFireDelay + 1)
        local newTears = currentTears + stabWound.FLAT_TEARS_UP * num
        player.MaxFireDelay = math.max(1, (30 / newTears) - 1)
    elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + stabWound.FLAT_DMG_UP * num
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, stabWound.onCache)

---@param player EntityPlayer
function stabWound:onPostAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, stabWound.onPostAddCollectible, mod.Items.StabWound)