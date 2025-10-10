local mod = DiesIraeMod
local KillerQueen = {}

-- Add the familiar to the player's cache
function KillerQueen:onCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
        local count = player:GetCollectibleNum(mod.Items.KillerQueen)
        player:CheckFamiliar(
            mod.EntityVariant.KillerQueen,
            count,
            player:GetCollectibleRNG(mod.Items.KillerQueen ),
            Isaac.GetItemConfig():GetCollectible(mod.Items.KillerQueen)
        )
    end
end

function KillerQueen:onFamiliarInit(familiar)
    familiar.Parent = familiar.SpawnerEntity
end

function KillerQueen:onFamiliarUpdate(familiar)
    local sprite = familiar:GetSprite()
    
    if not familiar.IsFollower then
        familiar:AddToFollowers()
    end
    familiar:FollowParent()

    if not sprite:IsPlaying("Float") then
        sprite:Play("Float", true)
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, KillerQueen.onCache)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, KillerQueen.onFamiliarInit, mod.EntityVariant.KillerQueen)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, KillerQueen.onFamiliarUpdate, mod.EntityVariant.KillerQueen)
