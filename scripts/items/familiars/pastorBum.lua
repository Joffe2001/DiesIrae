local mod = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")
local game = Game()
local sfx = SFXManager()

local PASTOR_BUM = mod.Entities.FAMILIAR_PastorBum.Var

---@class PastorBum
local pastorBum = {}

pastorBum.Item = mod.Items.PastorBum
pastorBum.BaseRewardChance = 0.10
pastorBum.StackRewardChance = true

pastorBum.Accepts = function(_, pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_HEART then
        return false
    end

    return pickup.SubType == HeartSubType.HEART_SOUL
        or pickup.SubType == HeartSubType.HEART_HALF_SOUL
end

function pastorBum.OnInit(fam)
    local data = fam:GetData()
    data.IsDemonic = false
end

function pastorBum.Reward(fam)
    local data = fam:GetData()
    local rng  = fam:GetDropRNG()

    if not data.IsDemonic then
        return rng:RandomFloat()
            < bumUtils.GetCurrentRewardChance(fam, pastorBum)
    end

    return rng:RandomFloat() < 0.15
end

function pastorBum.DoReward(fam)
    local data = fam:GetData()
    local rng  = fam:GetDropRNG()
    local pos  = Isaac.GetFreeNearPosition(fam.Position, 20)

    -- FIRST reward → Angel item → transform
    if not data.IsDemonic then
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            game:GetItemPool():GetCollectible(
                ItemPoolType.POOL_ANGEL,
                true,
                fam.InitSeed
            ),
            pos,
            Vector.Zero,
            fam
        )

        -- TRANSFORM
        data.IsDemonic = true
        data.PickupStack = 0

        local sprite = fam:GetSprite()
        sprite:Load("gfx/familiar/pastorbumb.anm2", true)
        sprite:Play("IdleDown", true)

        Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.POOF02,
            0,
            fam.Position,
            Vector.Zero,
            fam
        )

        sfx:Play(SoundEffect.SOUND_BABY_BRIM, 1.0)
        return
    end

    -- DEMONIC rewards
    if rng:RandomFloat() < 0.33 then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1.0)
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            game:GetItemPool():GetCollectible(
                ItemPoolType.POOL_DEVIL,
                true,
                fam.InitSeed
            ),
            pos,
            Vector.Zero,
            fam
        )
    else
        sfx:Play(SoundEffect.SOUND_MEAT_FEET_SLOW0, 1.0)
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_HEART,
            HeartSubType.HEART_BLACK,
            pos,
            Vector.Zero,
            fam
        )
    end
end

bumUtils.RegisterBum(PASTOR_BUM, pastorBum)

return pastorBum
