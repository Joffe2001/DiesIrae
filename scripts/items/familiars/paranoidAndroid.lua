local mod = DiesIraeMod

local ParanoidAndroid = {}

local BASE_RADIUS = 55
local BFFS_RADIUS = 55
local BASE_DAMAGE = 3.0
local BFFS_DAMAGE = 6.0
local TICK_RATE = 5 

function ParanoidAndroid:onCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
        local count = player:GetCollectibleNum(mod.Items.ParanoidAndroid)
        player:CheckFamiliar(
            mod.Entities.FAMILIAR_ParanoidAndroid.Var,
            count,
            RNG(),
            Isaac.GetItemConfig():GetCollectible(mod.Items.ParanoidAndroid)
        )
    end
end

function ParanoidAndroid:onFamiliarInit(familiar)
    familiar:AddToFollowers()
end

function ParanoidAndroid:onFamiliarUpdate(familiar)
    local player = familiar.Player
    local sprite = familiar:GetSprite()

    familiar:FollowParent()

    local fireDir = player:GetFireDirection()
    if fireDir == Direction.LEFT then
        sprite:Play("FloatShootSide", true)
        sprite.FlipX = true
    elseif fireDir == Direction.RIGHT then
        sprite:Play("FloatShootSide", true)
        sprite.FlipX = false
    elseif fireDir == Direction.UP then
        sprite:Play("FloatShootUp", true)
    elseif fireDir == Direction.DOWN then
        sprite:Play("FloatShootDown", true)
    else
        if not sprite:IsPlaying("FloatDown") then
            sprite:Play("FloatDown", true)
        end
    end

    if player:GetFireDirection() ~= Direction.NO_DIRECTION then
        if not familiar:GetData().Ring or not familiar:GetData().Ring:Exists() then
            local ring = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                mod.Entities.EFFECT_AndroidLazerRing.Var,
                0,
                familiar.Position,
                Vector.Zero,
                familiar
            ):ToEffect()
            if ring == nil then return end

            ring:GetSprite():Play("Idle", true)
            ring:GetSprite().Scale = Vector(2.0, 2.0)

            local data = ring:GetData()
            data.TickTimer = TICK_RATE

            familiar:GetData().Ring = ring
        end
    else
        if familiar:GetData().Ring and familiar:GetData().Ring:Exists() then
            familiar:GetData().Ring:Remove()
            familiar:GetData().Ring = nil
        end
    end
end

function ParanoidAndroid:onRingUpdate(effect)
    local familiar = effect.SpawnerEntity and effect.SpawnerEntity:ToFamiliar()
    if not familiar then
        effect:Remove()
        return
    end

    effect.Position = familiar.Position
    effect.DepthOffset = -50

    local player = familiar.Player
    local data = effect:GetData()

    local radius = BASE_RADIUS
    local damage = BASE_DAMAGE
    if player and player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        radius = BFFS_RADIUS
        damage = BFFS_DAMAGE
    end

    if not data.TickTimer then data.TickTimer = TICK_RATE end
    data.TickTimer = data.TickTimer - 1

    if data.TickTimer <= 0 then
        local enemies = Isaac.FindInRadius(effect.Position, radius, EntityPartition.ENEMY)
        for _, enemy in ipairs(enemies) do
            if enemy:IsActiveEnemy(false) and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                enemy:TakeDamage(damage, 0, EntityRef(familiar), 0)
            end
        end

        data.TickTimer = TICK_RATE
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ParanoidAndroid.onCache)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ParanoidAndroid.onFamiliarInit, mod.Entities.FAMILIAR_ParanoidAndroid.Var)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, ParanoidAndroid.onFamiliarUpdate, mod.Entities.FAMILIAR_ParanoidAndroid.Var)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, ParanoidAndroid.onRingUpdate, mod.Entities.EFFECT_AndroidLazerRing.Var)

if EID then
    EID:addDescriptionModifier(
        "ParanoidAndroid_BFF",

        function(descObj)
            if descObj.ObjType ~= EntityType.ENTITY_PICKUP then return false end
            if descObj.ObjVariant ~= PickupVariant.PICKUP_COLLECTIBLE then return false end
            if descObj.ObjSubType ~= mod.Items.ParanoidAndroid then return false end

            local player = EID:ClosestPlayerTo(descObj.Entity)
            return player and player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS)
        end,

        function(descObj)
            descObj.Description =
                descObj.Description ..
                "#{{Collectible" .. CollectibleType.COLLECTIBLE_BFFS .. "}}{{ColorRainbow}}Deals double damage{{CR}}"

            return descObj
        end
    )
end