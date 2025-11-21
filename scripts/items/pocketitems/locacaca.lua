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
    local copies = {}

    for id = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
        local count = p:GetCollectibleNum(id, false)
        if count > 0 then
            local cfg = itemConfig:GetCollectible(id)
            if cfg
            and cfg:IsAvailable()
            and not cfg:HasTags(ItemConfig.TAG_QUEST)
            and cfg.Type == ItemType.ITEM_PASSIVE then
                
                for _ = 1, count do
                    table.insert(copies, id)
                end
            end
        end
    end
    if #copies == 0 then return end

    local index = math.random(#copies)
    local id = copies[index]

    p:RemoveCollectible(id)
    p:EvaluateItems()
end

function Locacaca:useLocacaca(p)
    local broken = p:GetBrokenHearts()

    if broken > 0 then
        for i = 1, broken do
            Locacaca:removePassiveItem(p)
        end
        p:AddBrokenHearts(-broken)
    end

    local missing = p:GetMaxHearts() - p:GetHearts()
    if missing > 0 then
        p:AddHearts(missing)
        for i = 1, missing do
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
        p.Luck = p.Luck - debuffs.Luck * 0.3
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, p, f) Locacaca:onCache(p, f) end)
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags, slot)
    if card == mod.Cards.Locacaca then
        Locacaca:useLocacaca(player)
    end
end)

return Locacaca
