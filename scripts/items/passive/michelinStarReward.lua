local mod = DiesIraeMod
local game = Game()
local michelineStarReward = {}

mod.CollectibleType.COLLECTIBLE_MICHELINE_STAR_REWARD = Isaac.GetItemIdByName("Michelin Star Reward")

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

function michelineStarReward:OnMichelinStarPickup(collectibleType, charge, firstTime, slot, varData, player)
    if collectibleType == mod.CollectibleType.COLLECTIBLE_MICHELINE_STAR_REWARD then
        local pdata = player:GetData()
        if not pdata.MichelinStarDone then
            pdata.MichelinStarDone = true
            SpawnGoldenHearts(player.Position, 2)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function() end)
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, michelineStarReward.OnMichelinStarPickup)

function michelineStarReward:OnFoodPickupMichelinStar(pickup, collider)
    local player = collider:ToPlayer()
    if not player then return end
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_MICHELINE_STAR_REWARD) then return end

    local ic = Isaac.GetItemConfig()
    if pickup.SubType ~= 0 and ic:GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_FOOD) then
        SpawnGoldenHearts(player.Position, 2)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, michelineStarReward.OnFoodPickupMichelinStar)
