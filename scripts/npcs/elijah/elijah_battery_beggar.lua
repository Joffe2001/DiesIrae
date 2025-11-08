local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local beggar = mod.ElijahNPCs.BatteryBeggarElijah

-- Payout chances
local chanceCharge = 0.8125
local chanceBattery = 0.10
local chanceItem = 0.0625
local chanceTrinketAAA = 0.0125
local chanceTrinketWatch = 0.0125

function mod:BatteryBeggarCollision(beggarEntity, collider, low)
    if not collider:ToPlayer() then return end
    local player = collider:ToPlayer()
    local sprite = beggarEntity:GetSprite()

    if player:GetPlayerType() ~= mod.Players.Elijah then
        return
    end

    if sprite:IsPlaying("Idle") then
        local rng = beggarEntity:GetDropRNG()
        local paid = mod:DrainElijahStat(player)

        if paid then
            sfx:Play(SoundEffect.SOUND_SCAMPER)
            sprite:Play("PayPrize")
            beggarEntity:GetData().LastPayer = player
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.BatteryBeggarCollision, beggar)


function mod:BatteryBeggarUpdate(beggarEntity)
    local sprite = beggarEntity:GetSprite()
    local rng = beggarEntity:GetDropRNG()
    local data = beggarEntity:GetData()

    if sprite:IsFinished("PayNothing") then
        sprite:Play("Idle")
    elseif sprite:IsFinished("PayPrize") then
        sprite:Play("Prize")
    elseif sprite:IsFinished("Prize") then
        local player = data.LastPayer or Isaac.GetPlayer(0)
        local roll = rng:RandomFloat()
        if roll < chanceCharge then
            local charges = rng:RandomInt(3) + 1
            local totalAdded = 0

            if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) > 0 then
                totalAdded = totalAdded + player:AddActiveCharge(charges, ActiveSlot.SLOT_PRIMARY, true, true)
            end
            if player:GetActiveItem(ActiveSlot.SLOT_POCKET) > 0 then
                totalAdded = totalAdded + player:AddActiveCharge(charges, ActiveSlot.SLOT_POCKET, true, true)
            end

            if totalAdded > 0 then
                sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
                Game():GetHUD():ShowItemText("Battery Beggar", "+" .. tostring(totalAdded) .. " Charge")
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, beggarEntity.Position, Vector.Zero, nil)
            else
                Game():GetHUD():ShowItemText("Battery Beggar", "No Active Item!")
            end
            sprite:Play("Idle")

        elseif roll < chanceCharge + chanceBattery then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 1,
                Isaac.GetFreeNearPosition(beggarEntity.Position, 40), Vector.Zero, nil)
            sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
            sprite:Play("Idle")

        elseif roll < chanceCharge + chanceBattery + chanceItem then
            sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
            local item = game:GetItemPool():GetCollectible(ItemPoolType.POOL_BATTERY_BUM, true)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item,
                Isaac.GetFreeNearPosition(beggarEntity.Position, 40), Vector.Zero, nil)
            sprite:Play("Teleport")

        elseif roll < chanceCharge + chanceBattery + chanceItem + chanceTrinketAAA then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_AAA_BATTERY,
                Isaac.GetFreeNearPosition(beggarEntity.Position, 40), Vector.Zero, nil)
            sprite:Play("Teleport")
        else
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_WATCH_BATTERY,
                Isaac.GetFreeNearPosition(beggarEntity.Position, 40), Vector.Zero, nil)
            sprite:Play("Teleport")
        end
    end
    if sprite:IsFinished("Teleport") then
        sfx:Play(SoundEffect.SOUND_POOF01)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, beggarEntity.Position, Vector.Zero, nil)
        beggarEntity:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.BatteryBeggarUpdate, beggar)


function mod:BatteryBeggarExploded(beggar)
    for i = 1, 2 do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 1,
            beggar.Position + RandomVector() * 20, RandomVector() * 2, beggar)
    end
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color(0.8, 1, 1, 1, 0, 0.5, 1))
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.BatteryBeggarExploded, beggar)
