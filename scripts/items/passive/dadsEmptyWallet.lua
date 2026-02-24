local mod = DiesIraeMod
local DadsEmptyWallet = {}

mod.CollectibleType.COLLECTIBLE_DADS_EMPTY_WALLET = Isaac.GetItemIdByName("Dad's Empty Wallet")

local game = Game()

local function GetTearRateBonus(player)
    local coins = player:GetNumCoins()
    local bonus = 1.0 - (coins * 0.02) 
    if bonus < 0 then
        bonus = 0
    end
    return bonus
end

local function AddTearsUp(player, tearsUp)
    local currentTears = 30 / (player.MaxFireDelay + 1)
    local newTears = currentTears + tearsUp
    player.MaxFireDelay = math.max((30 / newTears) - 1, 1)
end

function DadsEmptyWallet:onCache(player, cacheFlag)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_DADS_EMPTY_WALLET) then return end

    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local bonus = GetTearRateBonus(player)
        if bonus > 0 then
            AddTearsUp(player, bonus)
        end
    end
end

function DadsEmptyWallet:onCoinChange()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_DADS_EMPTY_WALLET) then
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:EvaluateItems()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DadsEmptyWallet.onCache)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, DadsEmptyWallet.onCoinChange)
