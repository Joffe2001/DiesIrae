local mod = DiesIraeMod

local KillerQueen = {}

function KillerQueen:onCache(player, cacheFlag)
    if player:HasCollectible(mod.Items.KillerQueen) and cacheFlag == CacheFlag.CACHE_FAMILIARS then
        player:CheckFamiliar(KillerQueen.FAMILIAR_VARIANT, 1, player:GetCollectibleRNG(mod.Items.KillerQueen))
    end
end

function KillerQueen:onFamiliarUpdate(fam)
    local data = fam:GetData()
    local player = fam.Player
    local rng = player:GetCollectibleRNG(mod.Items.KillerQueen)

    data.attackCooldown = (data.attackCooldown or 0) - 1
    if data.attackCooldown <= 0 then
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
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCKET, 0, closestEnemy.Position, Vector.Zero, fam)

            data.attackCooldown = 90 
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, KillerQueen.onCache)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, KillerQueen.onFamiliarUpdate, KillerQueen.FAMILIAR_VARIANT)

if EID then
    EID:addCollectible(
        mod.Items.KillerQueen,
        "Killer Queen familiar that drops Epic Fetus bombs on enemies.",
        "Killer Queen",
        "en_us"
    )
    EID:assignTransformation("collectible", mod.Items.KillerQueen, "Dad's Playlist")
end
