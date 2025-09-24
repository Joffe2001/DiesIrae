local MomsDiary = {}
MomsDiary.COLLECTIBLE_ID = Isaac.GetItemIdByName("Mom's Diary")
local game = Game()

local chargePerHit = 1
local maxCharge = 6

-- Handle damage to charge item
function MomsDiary:OnPlayerDamaged(entity, damageAmount, flags, source, countdown)
    if not entity:ToPlayer() then return end
    local player = entity:ToPlayer()

    if player:HasCollectible(MomsDiary.COLLECTIBLE_ID) then
        -- Find the slot with Mom's Diary
        for slot = 0, 2 do
            if player:GetActiveItem(slot) == MomsDiary.COLLECTIBLE_ID then
                local charge = player:GetActiveCharge(slot)
                if charge < maxCharge then
                    local newCharge = math.min(charge + chargePerHit, maxCharge)
                    player:SetActiveCharge(newCharge, slot)
                end
            end
        end
    end
end

-- When used: Spawn a random pedestal item & reset charge
function MomsDiary:OnUseItem(_, rng, player, flags, slot, varData)
    local pool = game:GetItemPool()
    local level = game:GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    local currentPool = ItemPoolType.POOL_TREASURE

    if roomDesc and roomDesc.Data and roomDesc.Data.ItemPool then
        currentPool = roomDesc.Data.ItemPool
    end

    local itemID = pool:GetCollectible(currentPool, true, rng:GetSeed())
    if itemID ~= CollectibleType.COLLECTIBLE_NULL then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, player.Position, Vector.Zero, nil)
    end

    player:SetActiveCharge(0, slot) -- reset charge
    return true
end

-- Ensure it starts empty when picked up
function MomsDiary:OnPlayerEffectUpdate(player)
    if player:HasCollectible(MomsDiary.COLLECTIBLE_ID) then
        for slot = 0, 2 do
            if player:GetActiveItem(slot) == MomsDiary.COLLECTIBLE_ID and player:GetActiveCharge(slot) > 0 and game:GetFrameCount() < 2 then
                player:SetActiveCharge(0, slot)
            end
        end
    end
end

function MomsDiary:Init(mod)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, MomsDiary.OnPlayerDamaged, EntityType.ENTITY_PLAYER)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, MomsDiary.OnUseItem, MomsDiary.COLLECTIBLE_ID)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, MomsDiary.OnPlayerEffectUpdate)

    if EID then
        EID:addCollectible(
            MomsDiary.COLLECTIBLE_ID,
            "Spawns a random pedestal item.#Charges only when Isaac takes damage.",
            "Mom's Diary",
            "en_us"
        )
    end
end

return MomsDiary