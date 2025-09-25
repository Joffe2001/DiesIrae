local ParanoidAndroid = {}
ParanoidAndroid.COLLECTIBLE_ID = Enums.Items.ParanoidAndroid
ParanoidAndroid.FAMILIAR_VARIANT = Enums.EntityVariants.ParanoidAndroid
ParanoidAndroid.RING_VARIANT = Enums.EntityVariants.AndroidLazerRing

local BASE_RADIUS = 55
local BFFS_RADIUS = 55
local BASE_DAMAGE = 3.0
local BFFS_DAMAGE = 6.0
local TICK_RATE = 5

---@param player EntityPlayer
---@param cacheFlag CacheFlag
function ParanoidAndroid:onCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
        local count = player:GetCollectibleNum(ParanoidAndroid.COLLECTIBLE_ID)
        player:CheckFamiliar(
            ParanoidAndroid.FAMILIAR_VARIANT,
            count,
            RNG(),
            Isaac.GetItemConfig():GetCollectible(ParanoidAndroid.COLLECTIBLE_ID)
        )
    end
end

---@param familiar EntityFamiliar
function ParanoidAndroid:onFamiliarInit(familiar)
    familiar:AddToFollowers()
end

---@param familiar EntityFamiliar
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
                ParanoidAndroid.RING_VARIANT,
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

---@param effect EntityEffect
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

function ParanoidAndroid:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, self.onCache)
    mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, self.onFamiliarInit, self.FAMILIAR_VARIANT)
    mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, self.onFamiliarUpdate, self.FAMILIAR_VARIANT)
    mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, self.onRingUpdate, self.RING_VARIANT)

    if EID then
        EID:addCollectible(
            self.COLLECTIBLE_ID,
            "#Enemies touching the ring take damage every few frames",
            "Paranoid Android",
            "en_us"
        )
    end
end

return ParanoidAndroid
