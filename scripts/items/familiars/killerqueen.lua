local mod = DiesIraeMod
local KillerQueen = {}

-- Add the familiar to the player's cache
function KillerQueen:onCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
        local count = player:GetCollectibleNum(mod.Items.KillerQueen)
        player:CheckFamiliar(
            mod.EntityVariant.KillerQueen,
            count,
            RNG(),
            Isaac.GetItemConfig():GetCollectible(mod.Items.KillerQueen)
        )
    end
end

function KillerQueen:onFamiliarInit(familiar)
    familiar:AddToFollowers()  
    familiar.Position = familiar.Player.Position + Vector(10, 0)  
    familiar.Velocity = Vector.Zero
end

function KillerQueen:onFamiliarUpdate(familiar)
    local sprite = familiar:GetSprite()

    if not sprite:IsPlaying("Float") then
        sprite:Play("Float", true)
    end

    if familiar.Player then
        familiar.TargetPosition = familiar.Player.Position
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, KillerQueen.onCache)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, KillerQueen.onFamiliarInit, mod.EntityVariant.KillerQueen)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, KillerQueen.onFamiliarUpdate, mod.EntityVariant.KillerQueen)
