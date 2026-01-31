local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

local ELIJAH = mod.Players.Elijah
local WILL_COST = 10  -- Drains 10 Will total
local myBeggar = mod.Entities.BEGGAR_Familiars_Elijah.Var
local NEAR_POSITION = 40

local elijahWill = mod.Entities.PICKUP_ElijahsWill.Var

local function GetDrainableWillCount(player)
    local data = mod.SaveManager.GetRunSave(player)
    return
        (data.WillSpeed or 0) * 10 +
        (data.WillFireDelay or 0) * 5 +
        (data.WillDamage or 0) * 5 +
        (data.WillRange or 0) * 4 +
        (data.WillShotSpeed or 0) * 10 +
        (data.WillLuck or 0) * 2
end

local function DrainWillNTimes(player, beggar, times)
    local rng = beggar:GetDropRNG()
    local drained = 0

    for i = 1, times do
        if beggarUtils.DrainElijahsWill(player, rng) then
            drained = drained + 1
        else
            break
        end
    end

    if drained > 0 then
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
    end
    
    return drained >= times  -- Only return true if ALL 10 were drained
end

function mod:FamiliarElijahBeggarCollision(beggar, collider)
    local player = collider:ToPlayer()
    if not player then return end
    if player:GetPlayerType() ~= ELIJAH then return end

    local sprite = beggar:GetSprite()
    if not sprite:IsPlaying("Idle") then return end

    local data = beggar:GetData()

    if GetDrainableWillCount(player) < WILL_COST then
        game:GetHUD():ShowItemText("Your will is too weak")
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        return
    end

    if not DrainWillNTimes(player, beggar, WILL_COST) then
        game:GetHUD():ShowItemText("Need " .. WILL_COST .. " Will!")
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        return
    end

    data.LastPayer = player
    sprite:Play("PayPrize")
    sfx:Play(SoundEffect.SOUND_SCAMPER)
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.FamiliarElijahBeggarCollision, myBeggar)

function mod:FamiliarElijahBeggarUpdate(beggar)
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()

    if sprite:IsFinished("PayPrize") then
        sprite:Play("Prize")
        return
    end

    if sprite:IsFinished("Prize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)

        local rng = beggar:GetDropRNG()
        local roll = rng:RandomFloat()

        if roll < 0.5 then
            data.GaveTrinket = true

            if mod.Pools.Familiar_Beggar_Trinkets
            and #mod.Pools.Familiar_Beggar_Trinkets > 0 then
                local trinket =
                    mod.Pools.Familiar_Beggar_Trinkets[
                        rng:RandomInt(#mod.Pools.Familiar_Beggar_Trinkets) + 1
                    ]

                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_TRINKET,
                    trinket,
                    Isaac.GetFreeNearPosition(beggar.Position, NEAR_POSITION),
                    Vector.Zero,
                    beggar
                )
            end

            sprite:Play("Idle")
            return
        end
        data.GaveTrinket = false

        local familiarPool = {}

        if mod.Pools.Familiar_Beggar_Items then
            for _, item in ipairs(mod.Pools.Familiar_Beggar_Items) do
                table.insert(familiarPool, item)
            end
        end

        local itemConfig = Isaac.GetItemConfig()

        for i = 1, itemConfig:GetCollectibles().Size - 1 do
            local config = itemConfig:GetCollectible(i)

            if config
            and config.Type == ItemType.ITEM_FAMILIAR
            and config.FamiliarVariant ~= 0
            then
                table.insert(familiarPool, i)
            end
        end

        if #familiarPool > 0 then
            local item = familiarPool[rng:RandomInt(#familiarPool) + 1]

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                item,
                Isaac.GetFreeNearPosition(beggar.Position, NEAR_POSITION),
                Vector.Zero,
                beggar
            )

            sprite:Play("Teleport")
        else
            sprite:Play("Idle")
        end
        return
    end

    if sprite:IsFinished("Teleport") then
        beggar:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.FamiliarElijahBeggarUpdate, myBeggar)

function mod:FamiliarElijahBeggarExploded(beggar)
    for i = 1, 3 do
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            elijahWill,
            0,
            beggar.Position + RandomVector() * 20,
            RandomVector() * 3,
            beggar
        )
    end
    
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.FamiliarElijahBeggarExploded, myBeggar)