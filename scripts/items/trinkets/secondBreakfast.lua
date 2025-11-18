local SecondBreakfast = {}
SecondBreakfast.TRINKET_ID = Enums.Trinkets.SecondBreakfast
local game = Game()

local foodItemStats = {
    [CollectibleType.COLLECTIBLE_MEAT] = { damage = 1.0, health = 1 },
    [CollectibleType.COLLECTIBLE_LUNCH] = { health = 1 },
    [CollectibleType.COLLECTIBLE_SUPPER] = { health = 1 },
    [CollectibleType.COLLECTIBLE_DESSERT] = { health = 1 },
    [CollectibleType.COLLECTIBLE_ROTTEN_MEAT] = { health = 1 },
    [CollectibleType.COLLECTIBLE_SAUSAGE] = {
        damage = 1.0,
        tears = 0.5,
        speed = 0.2,
        range = 0.5,
        luck = 1
    }
}

local playerBonuses = {}

function SecondBreakfast:onUpdate(player)
    local id = player.InitSeed
    playerBonuses[id] = playerBonuses[id] or {}

    local trinketMult = player:GetTrinketMultiplier(SecondBreakfast.TRINKET_ID)
    if trinketMult <= 0 then return end

    for itemID, stats in pairs(foodItemStats) do
        local count = player:GetCollectibleNum(itemID)

        if count > 0 then
            playerBonuses[id][itemID] = stats
        end
    end

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end

function SecondBreakfast:onEvaluateCache(player, cacheFlag)
    local id = player.InitSeed
    if not playerBonuses[id] then return end

    for _, stats in pairs(playerBonuses[id]) do
        if cacheFlag == CacheFlag.CACHE_DAMAGE and stats.damage then
            player.Damage = player.Damage + stats.damage
        end
        if cacheFlag == CacheFlag.CACHE_FIREDELAY and stats.tears then
            player.MaxFireDelay = player.MaxFireDelay - stats.tears
        end
        if cacheFlag == CacheFlag.CACHE_SPEED and stats.speed then
            player.MoveSpeed = player.MoveSpeed + stats.speed
        end
        if cacheFlag == CacheFlag.CACHE_RANGE and stats.range then
            player.TearRange = player.TearRange + stats.range * 40 
        end
        if cacheFlag == CacheFlag.CACHE_LUCK and stats.luck then
            player.Luck = player.Luck + stats.luck
        end
    end
end

function SecondBreakfast:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, SecondBreakfast.onUpdate)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SecondBreakfast.onEvaluateCache)
end

return SecondBreakfast
