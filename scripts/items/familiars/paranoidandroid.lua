local mod = DiesIraeMod

local ParanoidAndroid = {}

-- Balance
local BASE_RADIUS = 55
local BFFS_RADIUS = 55
local BASE_DAMAGE = 3.0
local BFFS_DAMAGE = 6.0
local TICK_RATE = 5 -- frames per tick

---------------------------------------------------
-- Familiar Management
---------------------------------------------------
function ParanoidAndroid:onCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
        local count = player:GetCollectibleNum(mod.Items.ParanoidAndroid)
        player:CheckFamiliar(
            mod.EntityVariant.ParanoidAndroid,
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

    -- Handle facing direction
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

    -- Spawn/remove ring depending on Isaac firing
    if player:GetFireDirection() ~= Direction.NO_DIRECTION then
        if not familiar:GetData().Ring or not familiar:GetData().Ring:Exists() then
            local ring = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                mod.EntityVariant.AndroidLazerRing,
                0,
                familiar.Position,
                Vector.Zero,
                familiar
            ):ToEffect()

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

---------------------------------------------------
-- Ring Behavior
---------------------------------------------------
function ParanoidAndroid:onRingUpdate(effect)
    local familiar = effect.SpawnerEntity and effect.SpawnerEntity:ToFamiliar()
    if not familiar then
        effect:Remove()
        return
    end

    -- Follow familiar
    effect.Position = familiar.Position
    effect.DepthOffset = -50

    local player = familiar.Player
    local data = effect:GetData()

    -- Damage scale with BFFS!
    local radius = BASE_RADIUS
    local damage = BASE_DAMAGE
    if player and player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        radius = BFFS_RADIUS
        damage = BFFS_DAMAGE
    end

    -- Tick timer
    if not data.TickTimer then data.TickTimer = TICK_RATE end
    data.TickTimer = data.TickTimer - 1

    if data.TickTimer <= 0 then
        -- Deal damage to enemies inside the ring
        local enemies = Isaac.FindInRadius(effect.Position, radius, EntityPartition.ENEMY)
        for _, enemy in ipairs(enemies) do
            if enemy:IsActiveEnemy(false) and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                enemy:TakeDamage(damage, 0, EntityRef(familiar), 0)
            end
        end

        data.TickTimer = TICK_RATE
    end
end

---------------------------------------------------
-- Init
---------------------------------------------------
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ParanoidAndroid.onCache)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ParanoidAndroid.onFamiliarInit, mod.EntityVariant.ParanoidAndroid)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, ParanoidAndroid.onFamiliarUpdate, mod.EntityVariant.ParanoidAndroid)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, ParanoidAndroid.onRingUpdate, mod.EntityVariant.AndroidLazerRing)

if EID then
    EID:addCollectible(
        mod.Items.ParanoidAndroid,
        "#Enemies touching the ring take damage every few frames",
        "Paranoid Android",
        "en_us"
    )
end
