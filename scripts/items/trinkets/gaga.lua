local mod = DiesIraeMod

local Gaga = {}
local game = Game()

-- Constants for drop chances
local GAGA_BONUS = 0.05  -- 5% bonus
local GAGA_GOLDEN_BONUS = 0.10  -- 10% bonus

-- Function to morph regular pickups into golden ones
function Gaga:OnPickupSpawned(pickup)
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local trinketMultiplier = player:GetTrinketMultiplier(mod.Trinkets.Gaga)

        if trinketMultiplier > 0 then
            local rng = player:GetTrinketRNG(mod.Trinkets.Gaga)

            -- Calculate bonus
            local chanceBonus = (trinketMultiplier > 1) and GAGA_GOLDEN_BONUS or GAGA_BONUS

            -- Try morph
            if rng:RandomFloat() < chanceBonus then
                if pickup.Variant == PickupVariant.PICKUP_BOMB and pickup.SubType ~= BombSubType.BOMB_GOLDEN then
                    pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN, true)
                    break
                elseif pickup.Variant == PickupVariant.PICKUP_KEY and pickup.SubType ~= KeySubType.KEY_GOLDEN then
                    pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN, true)
                    break
                elseif pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType ~= CoinSubType.COIN_GOLDEN then
                    pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN, true)
                    break
                end
            end
        end
    end
end

-- EID description
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Gaga.OnPickupSpawned)

if EID then
    EID:addTrinket(
        mod.Trinkets.Gaga,
        "Increased chance to transform regular Bombs, Keys, and Coins into their golden variants.#↑ +5% chance#↑ +10% if golden",
        "Gaga",
        "en_us"
    )
end
