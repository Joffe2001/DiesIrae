local mod = DiesIraeMod
local KingsHeart = {}

local costInPennies = 10

---@param rng RNG
---@param player EntityPlayer
function KingsHeart:OnUseItem(_, rng, player)
    if player:GetNumCoins() >= costInPennies then
        player:AddCoins(-costInPennies)

        local heartPool = {
            HeartSubType.HEART_FULL,
            HeartSubType.HEART_HALF,
            HeartSubType.HEART_SOUL,
            HeartSubType.HEART_ETERNAL,
            HeartSubType.HEART_DOUBLEPACK,
            HeartSubType.HEART_BLACK,
            HeartSubType.HEART_GOLDEN,
            HeartSubType.HEART_HALF_SOUL,
            HeartSubType.HEART_SCARED,
            HeartSubType.HEART_BONE,
            HeartSubType.HEART_ROTTEN
        }
        local heartType = heartPool[rng:RandomInt(#heartPool) + 1]

        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, heartType, player.Position, Vector.Zero, nil)

        return {
            Discharge = true,
            Remove = false,
            ShowAnim = true
        }
    else
        return {
            Discharge = false,
            Remove = false,
            ShowAnim = false,
            SFXManager():Play(mod.Sounds.KINGS_FART)
        }
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, KingsHeart.OnUseItem, mod.Items.KingsHeart)
