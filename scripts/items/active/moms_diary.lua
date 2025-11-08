local mod = DiesIraeMod

local MomsDiary = {}

local chargePerHit = 1
local maxCharge = 6

---@param entity Entity
function MomsDiary:OnPlayerDamaged(entity)
    local player = entity:ToPlayer()
    if not player then return end

    if player:HasCollectible(mod.Items.MomsDiary) then
        for slot = 0, 2 do
            if player:GetActiveItem(slot) == mod.Items.MomsDiary then
                local charge = player:GetActiveCharge(slot)
                local newCharge = math.min(charge + chargePerHit, maxCharge)
                player:SetActiveCharge(newCharge, slot)
            end
        end
    end
end

---@param rng RNG
---@param player EntityPlayer
function MomsDiary:OnUseItem(_, rng, player)
    local pool = Game():GetItemPool()
    local level = Game():GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    local currentPool = ItemPoolType.POOL_TREASURE

    if roomDesc and roomDesc.Data and roomDesc.Data.ItemPool then
        currentPool = roomDesc.Data.ItemPool
    end

    local itemID = pool:GetCollectible(currentPool, true, rng:GetSeed())
    if itemID ~= CollectibleType.COLLECTIBLE_NULL then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, player.Position, Vector.Zero, nil)
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, MomsDiary.OnPlayerDamaged, EntityType.ENTITY_PLAYER)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, MomsDiary.OnUseItem, mod.Items.MomsDiary)

