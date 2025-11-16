local mod = DiesIraeMod
local sfx = SFXManager()

function mod:OnPlayerDamaged_BloodBattery(entity, damageAmount, damageFlags, source, countdownFrames)
    local player = entity:ToPlayer()
    if not player then return end
    if not player:HasCollectible(mod.Items.BloodBattery) then return end

    local totalAdded = 0
    if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) > 0 then
        totalAdded = totalAdded + player:AddActiveCharge(1, ActiveSlot.SLOT_PRIMARY, true, true)
    end
    if player:GetActiveItem(ActiveSlot.SLOT_POCKET) > 0 then
        totalAdded = totalAdded + player:AddActiveCharge(1, ActiveSlot.SLOT_POCKET, true, true)
    end

    if totalAdded > 0 then
        sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
    else
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnPlayerDamaged_BloodBattery, EntityType.ENTITY_PLAYER)
