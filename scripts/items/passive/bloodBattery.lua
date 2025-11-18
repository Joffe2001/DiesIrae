local mod = DiesIraeMod

local function DropWeightedBattery(player)
    local rng = player:GetCollectibleRNG(mod.Items.BloodBattery)

    if rng:RandomFloat() > 0.5 then
        return
    end
    
    local roll = rng:RandomInt(100)
    local subtype

    if roll < 55 then
        subtype = BatterySubType.BATTERY_MICRO
    elseif roll < 85 then
        subtype = BatterySubType.BATTERY_NORMAL
    elseif roll < 97 then
        subtype = BatterySubType.BATTERY_MEGA
    else
        subtype = BatterySubType.BATTERY_GOLDEN
    end

    Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_LIL_BATTERY or 0,
        subtype or 0,
        player.Position,
        Vector.Zero,
        player
    )
end


function mod:OnPlayerDamaged_BloodBattery(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player then return end
    if not player:HasCollectible(mod.Items.BloodBattery) then return end
    DropWeightedBattery(player)
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnPlayerDamaged_BloodBattery, EntityType.ENTITY_PLAYER)
