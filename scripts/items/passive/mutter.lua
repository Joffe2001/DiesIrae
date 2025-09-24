local Mutter = {}
Mutter.COLLECTIBLE_ID = Isaac.GetItemIdByName("Mutter")
local game = Game()
local MomsDressID = Isaac.GetItemIdByName("Mom's Dress")
local MomsDiaryID = Isaac.GetItemIdByName("Mom's Diary")

-- List of all Mom-related item IDs
local MomsItems = {
    CollectibleType.COLLECTIBLE_MOMS_EYESHADOW,
    CollectibleType.COLLECTIBLE_MOMS_KNIFE,
    CollectibleType.COLLECTIBLE_MOMS_EYE,
    CollectibleType.COLLECTIBLE_MOMS_CONTACTS,
    CollectibleType.COLLECTIBLE_MOMS_BRA,
    CollectibleType.COLLECTIBLE_MOMS_PAD,
    CollectibleType.COLLECTIBLE_MOMS_HEELS,
    CollectibleType.COLLECTIBLE_MOMS_LIPSTICK,
    CollectibleType.COLLECTIBLE_MOMS_PURSE,
    CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR,
    CollectibleType.COLLECTIBLE_MOMS_RING,
    CollectibleType.COLLECTIBLE_MOMS_BOX,
    MomsDressID,
    MomsDiaryID
}

-- Utility to count how many mom-related items the player has
local function CountMomsItems(player)
    local count = 0
    for _, itemID in ipairs(MomsItems) do
        if player:HasCollectible(itemID) then
            count = count + 1
        end
    end
    return count
end

function Mutter:onCache(player, cacheFlag)
    if not player:HasCollectible(Mutter.COLLECTIBLE_ID) then return end

    local momsCount = CountMomsItems(player)

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + (0.5 * momsCount)
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay - (0.3 * momsCount)
    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + momsCount
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + 0.3 + (0.05 * momsCount)
    end
end

function Mutter:IncreaseMomsItemChance(poolType, decrease, seed)
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(Mutter.COLLECTIBLE_ID) then return end

    local rng = RNG()
    rng:SetSeed(seed, 35)

    local eligiblePools = {
        ItemPoolType.POOL_TREASURE,
        ItemPoolType.POOL_DEVIL,
        ItemPoolType.POOL_ANGEL,
        ItemPoolType.POOL_SECRET,
        ItemPoolType.POOL_SHOP,
        ItemPoolType.POOL_BOSS,
        ItemPoolType.POOL_CURSE,
        ItemPoolType.POOL_RED_CHEST,
        ItemPoolType.POOL_GOLDEN_CHEST,
        ItemPoolType.POOL_DEMON_BEGGAR,
        ItemPoolType.POOL_GREED_SHOP,
        ItemPoolType.POOL_GREED_DEVIL,
        ItemPoolType.POOL_GREED_SECRET,
        ItemPoolType.POOL_GREED_TREASURE
    }

    if not eligiblePools[poolType] then return end

    local momItemsPool = {
        CollectibleType.COLLECTIBLE_MOMS_EYESHADOW,
        CollectibleType.COLLECTIBLE_MOMS_KNIFE,
        CollectibleType.COLLECTIBLE_MOMS_EYE,
        CollectibleType.COLLECTIBLE_MOMS_CONTACTS,
        CollectibleType.COLLECTIBLE_MOMS_BRA,
        CollectibleType.COLLECTIBLE_MOMS_PAD,
        CollectibleType.COLLECTIBLE_MOMS_HEELS,
        CollectibleType.COLLECTIBLE_MOMS_LIPSTICK,
        CollectibleType.COLLECTIBLE_MOMS_PURSE,
        CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR,
        CollectibleType.COLLECTIBLE_MOMS_RING,
        CollectibleType.COLLECTIBLE_MOMS_BOX,
        CollectibleType.COLLECTIBLE_C_SECTION,
        CollectibleType.COLLECTIBLE_DR_FETUS,
        MomsDiaryID,
        MomsDressID

    }

    if rng:RandomFloat() < 0.15 then
        return momItemsPool[rng:RandomInt(#momItemsPool) + 1]
    end
end

function Mutter:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mutter.onCache)
    mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, Mutter.IncreaseMomsItemChance)

    if EID then
        EID:addCollectible(
            Mutter.COLLECTIBLE_ID,
            "↑ +0.3 Speed up#↑ Stats up for each Mom item:# +0.5 Damage, -0.3 Tears Delay, +1 Luck, +0.05 Speed#↑ Increased chance to find Mom's items, Dr. Fetus and C-Section",
            "Mutter",
            "en_us"
        )
    end
end

return Mutter
