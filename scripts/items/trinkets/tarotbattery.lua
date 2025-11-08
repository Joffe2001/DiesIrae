local mod = DiesIraeMod

function mod:OnCardUsed(card, player, flags)
    local tarotBattery = mod.Trinkets.TarotBattery
    if not tarotBattery or not player:HasTrinket(tarotBattery) then
        return
    end

    local rng = player:GetTrinketRNG(tarotBattery)
    local chargeAmount = rng:RandomInt(2) + 1

    local slots = { ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_SECONDARY, ActiveSlot.SLOT_POCKET }
    for _, slot in ipairs(slots) do
        local activeItem = player:GetActiveItem(slot)
        if activeItem ~= 0 then
            player:AddActiveCharge(chargeAmount, slot)
            SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnCardUsed)
