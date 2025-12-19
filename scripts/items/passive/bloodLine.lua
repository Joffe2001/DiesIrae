local mod = DiesIraeMod
local game = Game()

mod._BloodlineActive = false

local function GetPlayerFromDamageSource(entity)
    local current = entity

    while current do
        if current:ToPlayer() then
            return current:ToPlayer()
        end
        current = current.SpawnerEntity
    end

    return nil
end

function mod:OnEnemyTakeDamage_bloodline(entity, damageAmount, damageFlags, damageSource, damageCountdown)
    if mod._BloodlineActive then
        return
    end

    local source = damageSource.Entity
    if not source then return end

    local ownerPlayer = GetPlayerFromDamageSource(source)
    if not ownerPlayer then return end
    if not ownerPlayer:HasCollectible(mod.Items.Bloodline) then
        return
    end

    local targetType = entity.Type
    local targetVariant = entity.Variant
    local targetHash = GetPtrHash(entity)

    mod._BloodlineActive = true

    for _, e in ipairs(Isaac.GetRoomEntities()) do
        if e:IsActiveEnemy(false) and not e:IsDead() then
            if GetPtrHash(e) ~= targetHash
            and e.Type == targetType
            and e.Variant == targetVariant then
                e:TakeDamage(damageAmount, damageFlags, damageSource, damageCountdown)
            end
        end
    end

    mod._BloodlineActive = false
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnEnemyTakeDamage_bloodline)
