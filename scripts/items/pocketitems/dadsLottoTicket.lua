local mod = DiesIraeMod
local game = Game()

---@class Utils
local utils = mod.Utils

local dadsLottoTicket = {}

function dadsLottoTicket:onUse(card, player, flags)
    if card ~= mod.Cards.DadsLottoTicket then return false end

    local rng = player:GetCollectibleRNG(mod.Cards.DadsLottoTicket)

    local luckyFootMutiplier = 1
    if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
        luckyFootMutiplier = 0.5
    end

    local rewardPool = {
        {2500 * luckyFootMutiplier, nil},
        {6000 * luckyFootMutiplier, {CoinSubType.COIN_PENNY}},
        {900 * luckyFootMutiplier, {CoinSubType.COIN_DOUBLEPACK}},
        {500 * luckyFootMutiplier, {CoinSubType.COIN_NICKEL}},

        -- 1% chance below, total weight 100
        {20, {CoinSubType.COIN_DIME}},
        {20, {CoinSubType.COIN_GOLDEN}},
        {10, {CoinSubType.COIN_LUCKYPENNY}},
        {10, {CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_STICKYNICKEL}},
        {5, {CoinSubType.COIN_DOUBLEPACK, CoinSubType.COIN_DOUBLEPACK, CoinSubType.COIN_DOUBLEPACK, CoinSubType.COIN_DOUBLEPACK, CoinSubType.COIN_DOUBLEPACK,
            CoinSubType.COIN_DOUBLEPACK, CoinSubType.COIN_DOUBLEPACK, CoinSubType.COIN_DOUBLEPACK, CoinSubType.COIN_DOUBLEPACK, CoinSubType.COIN_DOUBLEPACK}},
        {5, {CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_STICKYNICKEL,
            CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_STICKYNICKEL}},
        {5, {CoinSubType.COIN_DIME, CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_GOLDEN}},
        {5, {CoinSubType.COIN_DIME, CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_GOLDEN, CoinSubType.COIN_DIME, CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_GOLDEN}},
        {4, {CoinSubType.COIN_DIME, CoinSubType.COIN_DIME, CoinSubType.COIN_DIME, CoinSubType.COIN_DIME, CoinSubType.COIN_DIME, CoinSubType.COIN_DIME}},
        {4, {CoinSubType.COIN_GOLDEN, CoinSubType.COIN_GOLDEN, CoinSubType.COIN_GOLDEN, CoinSubType.COIN_GOLDEN}},
        {2, {CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_LUCKYPENNY}},
        {3, {CoinSubType.COIN_DIME, CoinSubType.COIN_DIME, CoinSubType.COIN_GOLDEN, CoinSubType.COIN_GOLDEN, CoinSubType.COIN_GOLDEN, CoinSubType.COIN_GOLDEN, CoinSubType.COIN_GOLDEN}},
        {3, {CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_DOUBLEPACK, CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_NICKEL, CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_DIME}},
        {2, {CoinSubType.COIN_GOLDEN, CoinSubType.COIN_GOLDEN, CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_LUCKYPENNY, CoinSubType.COIN_LUCKYPENNY}},
        {2, {CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_NICKEL, CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_NICKEL,
            CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_NICKEL, CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_NICKEL,
            CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_NICKEL, CoinSubType.COIN_STICKYNICKEL, CoinSubType.COIN_NICKEL,}},
    }

    local reward = utils.WeightedRandom(rewardPool, rng)
    if reward == nil then
        SFXManager():Play(mod.Sounds.KINGS_FART)
        return false
    end

    for _, coinType in ipairs(reward) do
        local spawnPos = Isaac.GetFreeNearPosition(player.Position, 40)
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COIN,
            coinType,
            spawnPos,
            Vector.Zero,
            player
        )
    end

    return true
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, dadsLottoTicket.onUse)
