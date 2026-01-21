---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local myBeggar = mod.Entities.BEGGAR_Familiars.Var

local PAYMENT_COST = 10

function mod:FamiliarBeggarCollision(beggar, collider, low)
    if not collider:ToPlayer() then return end
    local player = collider:ToPlayer()
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()

    if sprite:IsPlaying("Idle") then
        local playerCoins = player:GetNumCoins()
        
        if playerCoins >= PAYMENT_COST then
            player:AddCoins(-PAYMENT_COST)
            
            sfx:Play(SoundEffect.SOUND_SCAMPER)

            sprite:Play("PayPrize")
            data.LastPayer = player
        else
            sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.FamiliarBeggarCollision, myBeggar)

function mod:FamiliarBeggarUpdate(beggar)
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
                    Isaac.GetFreeNearPosition(beggar.Position, 40),
                    Vector.Zero,
                    beggar
                )
            end

            sprite:Play("Idle")

        else
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
                    Isaac.GetFreeNearPosition(beggar.Position, 40),
                    Vector.Zero,
                    beggar
                )

                sprite:Play("Teleport")
            else
                sprite:Play("Idle")
            end
        end
        return
    end

    if sprite:IsFinished("Teleport") then
        beggar:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.FamiliarBeggarUpdate, myBeggar)

function mod:FamiliarBeggarExploded(beggar)
    for i = 1, 3 do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY,
            beggar.Position + RandomVector() * 20, RandomVector() * 3, beggar)
    end
    
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.FamiliarBeggarExploded, myBeggar)