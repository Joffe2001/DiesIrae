local mod = DiesIraeMod
local Kaboomush = {}
local game = Game()

function Kaboomush:OnPickup(collectibleID, player)
    if collectibleID ~= mod.Items.Kaboomush then return end

    player:AddBombs(3)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    player:EvaluateItems()
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Kaboomush.OnPickup)

function Kaboomush:OnCache(player, cacheFlag)
    if player:HasCollectible(mod.Items.Kaboomush) then
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay - 0.3
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Kaboomush.OnCache)


function Kaboomush:OnPlayerDamaged(entity, damageAmount, damageFlags, source, countdown)
    local player = entity:ToPlayer()
    if not player then return end
    if not player:HasCollectible(mod.Items.Kaboomush) then return end

    if damageFlags & DamageFlag.DAMAGE_EXPLOSION ~= DamageFlag.DAMAGE_EXPLOSION then
        return
    end

    local pool = mod.Pools.Mushroom
    if not pool or #pool == 0 then return end

    local rng = player:GetCollectibleRNG(mod.Items.Kaboomush)
    local mush = pool[rng:RandomInt(#pool) + 1]
    player:AddInnateCollectible(mush)
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Kaboomush.OnPlayerDamaged, EntityType.ENTITY_PLAYER)
