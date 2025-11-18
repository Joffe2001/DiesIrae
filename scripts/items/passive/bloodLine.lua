local mod = DiesIraeMod
local game = Game()

mod._BloodlineActive = false

function mod:OnEnemyTakeDamage_bloodline(entity, damageAmount, damageFlags, damageSource, damageCountdown)
    if mod._BloodlineActive then
        return
    end

    local source = damageSource.Entity
    if not source then
        return
    end

    local player
    if source:ToPlayer() then
        player = source:ToPlayer()
    elseif source.SpawnerEntity and source.SpawnerEntity:ToPlayer() then
        player = source.SpawnerEntity:ToPlayer()
    end

    if not player or not player:HasCollectible(mod.Items.Bloodline) then
        return
    end

    local targetType = entity.Type
    local targetVariant = entity.Variant
    local targetHash = GetPtrHash(entity)

    mod._BloodlineActive = true

    for _, e in ipairs(Isaac.GetRoomEntities()) do
        if e:IsActiveEnemy(false) and not e:IsDead() then
            local enemyHash = GetPtrHash(e)
            if enemyHash ~= targetHash and e.Type == targetType and e.Variant == targetVariant then
                e:TakeDamage(damageAmount, damageFlags, damageSource, damageCountdown)
            end
        end
    end

    mod._BloodlineActive = false
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnEnemyTakeDamage_bloodline)
