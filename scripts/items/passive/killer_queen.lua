local KillerQueen = {}
KillerQueen.COLLECTIBLE_ID = Isaac.GetItemIdByName("Killer Queen")
KillerQueen.FAMILIAR_VARIANT = Isaac.GetEntityVariantByName("Killer Queen")

-- Add familiar on item pickup
function KillerQueen:onCache(player, cacheFlag)
    if player:HasCollectible(KillerQueen.COLLECTIBLE_ID) and cacheFlag == CacheFlag.CACHE_FAMILIARS then
        player:CheckFamiliar(KillerQueen.FAMILIAR_VARIANT, 1, player:GetCollectibleRNG(KillerQueen.COLLECTIBLE_ID))
    end
end

-- Familiar AI
function KillerQueen:onFamiliarUpdate(fam)
    local data = fam:GetData()
    local player = fam.Player
    local rng = player:GetCollectibleRNG(KillerQueen.COLLECTIBLE_ID)

    -- Cooldown between attacks
    data.attackCooldown = (data.attackCooldown or 0) - 1
    if data.attackCooldown <= 0 then
        -- Find nearest enemy
        local closestEnemy
        local dist = 9999
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            if entity:IsActiveEnemy(false) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                local d = fam.Position:Distance(entity.Position)
                if d < dist then
                    dist = d
                    closestEnemy = entity
                end
            end
        end

        if closestEnemy then
            -- Spawn Epic Fetus rocket
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCKET, 0, closestEnemy.Position, Vector.Zero, fam)

            -- Reset cooldown
            data.attackCooldown = 90 -- 1.5s cooldown (60 = 1 sec)
        end
    end
end

-- Register
function KillerQueen:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, KillerQueen.onCache)
    mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, KillerQueen.onFamiliarUpdate, KillerQueen.FAMILIAR_VARIANT)

    if EID then
        EID:addCollectible(
            KillerQueen.COLLECTIBLE_ID,
            "Killer Queen familiar that drops Epic Fetus bombs on enemies.",
            "Killer Queen",
            "en_us"
        )
        EID:assignTransformation("collectible", KillerQueen.COLLECTIBLE_ID, "Dad's Playlist")
    end
end

return KillerQueen
