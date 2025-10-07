local DadsEmptyWallet = {}
DadsEmptyWallet.COLLECTIBLE_ID = Enums.Items.DadsEmptyWallet

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
    if not player:HasCollectible(DadsEmptyWallet.COLLECTIBLE_ID) then return end

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
        if player:HasCollectible(DadsEmptyWallet.COLLECTIBLE_ID) then
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:EvaluateItems()
        end
    end
end

function DadsEmptyWallet:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DadsEmptyWallet.onCache)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, DadsEmptyWallet.onCoinChange)

    if EID then
        EID:addCollectible(
            DadsEmptyWallet.COLLECTIBLE_ID,
            "↑ +1 Tears if you have no coins#↓-0.02 Tears bonus per coin",
            "Dad's Empty Wallet",
            "en_us"
        )
    end
end

return DadsEmptyWallet
