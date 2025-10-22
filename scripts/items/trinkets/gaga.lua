local mod = DiesIraeMod

local Gaga = {}
local game = Game()

local GAGA_BONUS = 0.05  
local GAGA_GOLDEN_BONUS = 0.10  

function Gaga:OnPickupSpawned(pickup)
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local trinketMultiplier = player:GetTrinketMultiplier(mod.Trinkets.Gaga)

        if trinketMultiplier > 0 then
            local rng = player:GetTrinketRNG(mod.Trinkets.Gaga)

            local chanceBonus = (trinketMultiplier > 1) and GAGA_GOLDEN_BONUS or GAGA_BONUS
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

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Gaga.OnPickupSpawned)
