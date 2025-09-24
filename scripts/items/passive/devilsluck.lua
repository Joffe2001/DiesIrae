local DevilLuck = {}
DevilLuck.COLLECTIBLE_ID = Isaac.GetItemIdByName("Devil's Luck")

-- Constants
local LUCK_PENALTY = -6
local DAMAGE_PER_DISAPPEAR = 0.05

-- Cache modification
function DevilLuck:OnCache(player, cacheFlag)
    if not player:HasCollectible(DevilLuck.COLLECTIBLE_ID) then return end

    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + LUCK_PENALTY
    elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
        local dmgBoost = player:GetData().DevilLuckDamageBoost or 0
        player.Damage = player.Damage + dmgBoost
    end
end

-- Apply cache flags instantly when item is picked up
function DevilLuck:OnPlayerUpdate(player)
    if player:HasCollectible(DevilLuck.COLLECTIBLE_ID) and not player:GetData().DevilLuck_Initialized then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK | CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
        player:GetData().DevilLuck_Initialized = true
    end
end

-- Handle pickup collision
function DevilLuck:OnPickupCollision(pickup, collider, _)
    local player = collider:ToPlayer()
    if not player or not player:HasCollectible(DevilLuck.COLLECTIBLE_ID) then return end

    -- Filter out pickups that shouldn't be affected
    if pickup:IsShopItem() or pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then return end

    local allowed = {
        [PickupVariant.PICKUP_COIN] = true,
        [PickupVariant.PICKUP_KEY] = true,
        [PickupVariant.PICKUP_BOMB] = true,
        [PickupVariant.PICKUP_HEART] = true
    }

    if not allowed[pickup.Variant] then return end

    -- Use Isaac's RNG for consistent results
    local rng = player:GetCollectibleRNG(DevilLuck.COLLECTIBLE_ID)

    if rng:RandomFloat() < 0.5 then
        -- Block the pickup, add damage
        pickup:Remove()

        local data = player:GetData()
        data.DevilLuckDamageBoost = (data.DevilLuckDamageBoost or 0) + DAMAGE_PER_DISAPPEAR
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()

        SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 1.0, 0, false, 1.0)
        Game():SpawnParticles(pickup.Position, EffectVariant.POOF01, 1, 2.0, Color(1, 0, 0, 1))

        return true -- ✅ BLOCK the pickup
    end

    -- ✅ Do not return anything! Pickup will be collected
end

-- Init
function DevilLuck:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DevilLuck.OnCache)
    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, DevilLuck.OnPickupCollision)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, DevilLuck.OnPlayerUpdate)

    if EID then
        EID:addCollectible(
            DevilLuck.COLLECTIBLE_ID,
            "↓ -6 Luck instantly#50% chance for pickups (coins, keys, bombs, hearts) to vanish#↑ Permanent damage up per vanished pickup",
            "Devil's Luck",
            "en_us"
        )
    end
end

return DevilLuck
