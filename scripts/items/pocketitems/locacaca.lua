local mod = DiesIraeMod
local Locacaca = {}

function Locacaca:decreaseRandomStats(p, count)
    local stats = {"Damage", "MoveSpeed", "Tears", "Range", "Luck"}
    p:GetData().LocacacaStatDebuff = p:GetData().LocacacaStatDebuff or {}
    for i = 1, count do
        local stat = stats[math.random(#stats)]
        p:GetData().LocacacaStatDebuff[stat] = (p:GetData().LocacacaStatDebuff[stat] or 0) + 1
    end
    p:AddCacheFlags(CacheFlag.CACHE_ALL)
    p:EvaluateItems()
end

function Locacaca:removePassiveItem(p)
    local itemConfig = Isaac.GetItemConfig()
    local toRemove = {}

    for i = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
        if p:HasCollectible(i) then
            local cfg = itemConfig:GetCollectible(i)
            if cfg and cfg:IsAvailable() and not cfg:HasTags(ItemConfig.TAG_QUEST) and cfg.Type == ItemType.ITEM_PASSIVE then
                table.insert(toRemove, i)
            end
        end
    end

    for _, id in ipairs(toRemove) do
        p:RemoveCollectible(id)
    end

    p:EvaluateItems()
end

function Locacaca:useLocacaca(p)
    local healedHearts = 0
    local healedBrokenHearts = 0

    local broken = p:GetBrokenHearts()
    if broken > 0 then
        p:AddBrokenHearts(-broken)
        healedBrokenHearts = broken
        for i = 1, broken do
            Locacaca:removePassiveItem(p)
        end
    end

    local missing = p:GetMaxHearts() - p:GetHearts()
    if missing > 0 then
        p:AddHearts(missing)
        healedHearts = missing
        for i = 1, healedHearts do
            Locacaca:decreaseRandomStats(p, 1)
        end
    end
end

function Locacaca:onCache(p, cacheFlag)
    local debuffs = p:GetData().LocacacaStatDebuff
    if not debuffs then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE and debuffs.Damage then
        p.Damage = p.Damage - debuffs.Damage * 0.2
    end
    if cacheFlag == CacheFlag.CACHE_SPEED and debuffs.MoveSpeed then
        p.MoveSpeed = p.MoveSpeed - debuffs.MoveSpeed * 0.1
    end
    if cacheFlag == CacheFlag.CACHE_FIREDELAY and debuffs.Tears then
        p.MaxFireDelay = p.MaxFireDelay + debuffs.Tears * 0.3
    end
    if cacheFlag == CacheFlag.CACHE_RANGE and debuffs.Range then
        p.TearRange = p.TearRange - debuffs.Range * 20
    end
    if cacheFlag == CacheFlag.CACHE_LUCK and debuffs.Luck then
        p.Luck = p.Luck - debuffs.Luck
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, p, f) Locacaca:onCache(p, f) end)
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags, slot)
    if card == mod.Cards.Locacaca then
        Locacaca:useLocacaca(player)
    end
end)

return Locacaca
