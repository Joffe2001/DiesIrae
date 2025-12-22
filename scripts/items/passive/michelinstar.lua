local mod = DiesIraeMod
local game = Game()
---@param position Vector
---@param count integer
local function SpawnGoldenHearts(position, count)
    for i = 1, count do
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_HEART,
            HeartSubType.HEART_GOLDEN,
            Isaac.GetFreeNearPosition(position, 20),
            Vector(math.random() * 2 - 1, math.random() * 2 - 1),
            nil
        )
    end
end

function mod:OnMichelinStarPickup(collectibleType, charge, firstTime, slot, varData, player)
    if collectibleType == mod.Items.MichelinStar then
        local pdata = player:GetData()
        if not pdata.MichelinStarDone then
            pdata.MichelinStarDone = true
            SpawnGoldenHearts(player.Position, 2)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function() end)
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnMichelinStarPickup)

function mod:OnFoodPickupMichelinStar(pickup, collider)
    local player = collider:ToPlayer()
    if not player then return end
    if not player:HasCollectible(mod.Items.MichelinStar) then return end

    local ic = Isaac.GetItemConfig()
    if pickup.SubType ~= 0 and ic:GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_FOOD) then
        SpawnGoldenHearts(player.Position, 2)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnFoodPickupMichelinStar)