local mod = DiesIraeMod
local game = Game()

function mod:UseDadsLottoTicket(card, player, flags)
    if card ~= mod.Cards.DadsLottoTicket then
        return false
    end

    local rng = player:GetCollectibleRNG(mod.Cards.DadsLottoTicket)
    local roll = rng:RandomInt(100) + 1 
    local coinType = nil

    if roll <= 30 then
        coinType = CoinSubType.COIN_PENNY   
    elseif roll <= 45 then
        coinType = CoinSubType.COIN_NICKEL  
    elseif roll <= 50 then
        coinType = CoinSubType.COIN_DIME 
    else
        coinType = nil
        SFXManager():Play(mod.Sounds.KINGS_FART)
    end

    if coinType then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, coinType, player.Position, Vector.Zero, player)
    end

    return true
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.UseDadsLottoTicket)
