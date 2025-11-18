local mod = DiesIraeMod
local game = Game()

local ENERGY_DRINK_CHANCE_BONUS = 15

function mod:OnSweetCaffeinePickup(player)
    local data = player:GetData()
    if not data.SweetCaffeineSpawned then
        data.SweetCaffeineSpawned = true
        local spawnPos = Isaac.GetFreeNearPosition(player.Position, 40)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.Cards.EnergyDrink, spawnPos, Vector.Zero, nil)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player:HasCollectible(mod.Items.SweetCaffeine) then
        mod:OnSweetCaffeinePickup(player)
    end
end)

function mod:OnGetCard(rng, card, decrease)
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.SweetCaffeine) then
            local roll = rng:RandomInt(100)
            if roll < ENERGY_DRINK_CHANCE_BONUS then
                return mod.Cards.EnergyDrink
            end
        end
    end
    return card
end
mod:AddCallback(ModCallbacks.MC_GET_CARD, mod.OnGetCard)
