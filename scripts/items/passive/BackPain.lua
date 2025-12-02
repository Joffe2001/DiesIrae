local mod = DiesIraeMod
local BackPain = {}

local function GetPassiveItemCount(player)
    local count = 0
    local itemConfig = Isaac.GetItemConfig()
    local totalCollectibles = itemConfig:GetCollectiblesCount()

    for id = 1, totalCollectibles do
        local cfg = itemConfig:GetCollectible(id)
        if cfg and cfg.Type == ItemType.ITEM_PASSIVE then
            local num = player:GetCollectibleNum(id)
            if num > 0 then
                count = count + num
            end
        end
    end

    return count
end

function BackPain:OnEvaluateCache(player, cacheFlag)
    if not player:HasCollectible(mod.Items.BackPain) then return end

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

function BackPain:PostPEffectUpdate(player)
    if not player:HasCollectible(mod.Items.BackPain) then return end

    local data = player:GetData()
    data.BackPain_LastPassiveCount = data.BackPain_LastPassiveCount or -1
    data.BackPain_HadProtein = data.BackPain_HadProtein or false

    local currentCount = GetPassiveItemCount(player)

    if currentCount ~= data.BackPain_LastPassiveCount then
        data.BackPain_LastPassiveCount = currentCount
        player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    end

    local hasProtein = player:HasCollectible(mod.Items.ProteinPowder)
    if hasProtein ~= data.BackPain_HadProtein then
        data.BackPain_HadProtein = hasProtein
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BackPain.PostPEffectUpdate)

return BackPain
