local mod = DiesIraeMod
local BackPain = {}

local function GetPassiveItemCount(player)
    local count = 0
    local itemConfig = Isaac.GetItemConfig()

    for id = 1, CollectibleType.NUM_COLLECTIBLES do
        if player:HasCollectible(id) then
            local cfg = itemConfig:GetCollectible(id)
            if cfg and cfg.Type == ItemType.ITEM_PASSIVE then
                count = count + 1
            end
        end
    end

    return count
end

function BackPain:OnEvaluateCache(player, cacheFlag)
    if not player:HasCollectible(mod.Items.BackPain) then
        return
    end

    local passiveCount = GetPassiveItemCount(player)
    if passiveCount <= 0 then return end

    if cacheFlag == CacheFlag.CACHE_SPEED then
        if not player:HasCollectible(mod.Items.ProteinPowder) then
            player.MoveSpeed = player.MoveSpeed - (0.03 * passiveCount)
        end
    end

    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local tearsUp = 0.1 * passiveCount

        local currentTears = 30 / (player.MaxFireDelay + 1)
        local newTears = currentTears + tearsUp

        player.MaxFireDelay = math.max(1, (30 / newTears) - 1)
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BackPain.OnEvaluateCache)


function BackPain:OnGetCollectible(_, itemID)
    local player = Isaac.GetPlayer(0)
    if not player then return end

    if itemID == mod.Items.BackPain then
        player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
        return
    end

    if player:HasCollectible(mod.Items.BackPain) then
        local cfg = Isaac.GetItemConfig():GetCollectible(itemID)
        if cfg and cfg.Type == ItemType.ITEM_PASSIVE then
            player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
            player:EvaluateItems()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, BackPain.OnGetCollectible)
return BackPain
