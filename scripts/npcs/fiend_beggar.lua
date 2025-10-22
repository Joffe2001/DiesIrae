local mod = DiesIraeMod
local sfx = SFXManager()
local game = Game()
local myBeggar = mod.EntityVariant.FiendBeggar
local Fragile = require("scripts.effects.fragile")
mod.FiendRewardsPending = {}

function mod:FiendBeggarUpdate(beggar)
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()
    local player = Isaac.GetPlayer(0)

    if data.HasTriggered then
        if sprite:IsFinished("PayPrize") then
            sprite:Play("Teleport", true)
        elseif sprite:IsFinished("Teleport") then
            beggar:Remove()
        end
        return
    end

    if player and player.Position:Distance(beggar.Position) < 35 then
        Fragile.ApplyFragile(player)
        sfx:Play(SoundEffect.SOUND_SATAN_GROW)
        sprite:Play("PayPrize", true)
        data.HasTriggered = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.FiendBeggarUpdate, myBeggar)

function mod:FiendBeggarExploded(beggar)
    local player = Isaac.GetPlayer(0)
    if player then
        player:TakeDamage(2, DamageFlag.DAMAGE_EXPLOSION, EntityRef(beggar), 0)
    end

    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.FiendBeggarExploded, myBeggar)

function mod:OnNewFloor()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()
        if data.IsFragile then
            data.IsFragile = false
            mod.FiendRewardsPending[i] = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewFloor)

function mod:SpawnFiendReward()
    local level = game:GetLevel()
    local room = game:GetRoom()
    local roomDesc = level:GetCurrentRoomDesc()

    if not roomDesc or roomDesc.SafeGridIndex ~= level:GetStartingRoomIndex() then
        return
    end

    for i = 0, game:GetNumPlayers() - 1 do
        if mod.FiendRewardsPending[i] then
            mod.FiendRewardsPending[i] = nil

            local itemPool = game:GetItemPool()
            local pos = room:GetCenterPos()

            local item1 = itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, true)
            local item2 = itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, true)

            local pedestal1 = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item1, pos + Vector(-60, 0), Vector.Zero, nil)
            local pedestal2 = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item2, pos + Vector(60, 0), Vector.Zero, nil)

            pedestal1:GetData().FiendPedestal = true
            pedestal2:GetData().FiendPedestal = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SpawnFiendReward)

function mod:OnPickupCollect(pickup, collider)
    local player = collider:ToPlayer()
    if not player then return end

    if pickup:GetData().FiendPedestal then
        for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            if ent:Exists() and ent.InitSeed ~= pickup.InitSeed and ent:GetData().FiendPedestal then
                ent:Remove()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnPickupCollect, PickupVariant.PICKUP_COLLECTIBLE)