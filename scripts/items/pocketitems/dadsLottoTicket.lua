local mod = DiesIraeMod
local game = Game()


local function GetNearbyFreePosition(origin)
    local room = game:GetRoom()
    local candidates = {}


    local offsets = {
        Vector(0,0),
        Vector(40,0),
        Vector(-40,0),
        Vector(0,40),
        Vector(0,-40),
        Vector(40,40),
        Vector(-40,40),
        Vector(40,-40),
        Vector(-40,-40)
    }

    for _, off in ipairs(offsets) do
        local pos = origin + off
        if room:GetGridCollisionAtPos(pos) == GridCollisionClass.COLLISION_NONE then
            table.insert(candidates, pos)
        end
    end

    if #candidates == 0 then
        return origin
    end

    return candidates[math.random(#candidates)]
end

function mod:UseDadsLottoTicket(card, player, flags)
    if card ~= mod.Cards.DadsLottoTicket then return false end

    local rng = player:GetCollectibleRNG(mod.Cards.DadsLottoTicket)
    local roll = rng:RandomInt(100) + 1
    local coinType = nil

    if roll <= 30 then
        coinType = CoinSubType.COIN_PENNY
    elseif roll <= 45 then
        coinType = CoinSubType.COIN_NICKEL
    elseif roll <= 50 then
        coinType = CoinSubType.COIN_DIME
    elseif roll <= 60 then
        coinType = CoinSubType.COIN_LUCKYPENNY
    elseif roll <= 70 then
        coinType = CoinSubType.COIN_STICKYNICKEL
    elseif roll <= 75 then
        coinType = CoinSubType.COIN_DOUBLEPACK
    elseif roll <= 80 then
        coinType = CoinSubType.COIN_GOLDEN
    else
        coinType = nil
        SFXManager():Play(mod.Sounds.KINGS_FART)
    end

    if coinType then
        local pos = GetNearbyFreePosition(player.Position)
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COIN,
            coinType,
            pos,
            Vector.Zero,
            player
        )
    end

    return true
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.UseDadsLottoTicket)
