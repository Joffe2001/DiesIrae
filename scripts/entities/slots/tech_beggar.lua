local mod = DiesIraeMod
local music = MusicManager()
local game = Game()
local myBeggar = mod.Entities.TechBeggar.Var


local payChance = 0.8
local prizeChance = 0.2
local TECHX_DURATION = 1800

local techPool = {
    Collectibles = {
        CollectibleType.COLLECTIBLE_TECHNOLOGY,
        CollectibleType.COLLECTIBLE_TECH_X,
        CollectibleType.COLLECTIBLE_TECHNOLOGY_2,
        CollectibleType.COLLECTIBLE_TRACTOR_BEAM,
        CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
        CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE,
        CollectibleType.COLLECTIBLE_ROBO_BABY,
        CollectibleType.COLLECTIBLE_ROBO_BABY_2,
        CollectibleType.COLLECTIBLE_TECH_5,
        CollectibleType.COLLECTIBLE_SPIDER_MOD,
        CollectibleType.COLLECTIBLE_JACOBS_LADDER,
        CollectibleType.COLLECTIBLE_120_VOLT,
        CollectibleType.COLLECTIBLE_BOT_FLY
    }
}

function mod:TechBeggarCollision(beggar, collider, low)
    if not collider:ToPlayer() then return end
    local player = collider:ToPlayer()
    local sprite = beggar:GetSprite()

    if sprite:IsPlaying("Idle") then
        local rng = beggar:GetDropRNG()
        local pay = false

        if player:GetNumCoins() > 0 then
            player:AddCoins(-1)
            pay = true
        end

        if pay then
            sfx:Play(SoundEffect.SOUND_SCAMPER)

            if rng:RandomFloat() > payChance then
                sprite:Play("PayPrize")
                beggar:GetData().LastPayer = player
            else
                sprite:Play("PayNothing")
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.TechBeggarCollision, myBeggar)

function mod:TechBeggarUpdate(beggar)
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()
    local player = Isaac.GetPlayer(0)

    if not data.HasPlayedWaitingMusic then
        data.HasPlayedWaitingMusic = false
    end

    if sprite:IsPlaying("Idle") and math.random() < 0.0005 then
        sprite:Play("Waiting")
        if not data.HasPlayedWaitingMusic then
            music:Play(mod.Music.TechBeggarWaiting)
            data.HasPlayedWaitingMusic = true
        end
    end

    local playerDistance = player.Position:Distance(beggar.Position)
    if sprite:IsPlaying("Waiting") and playerDistance < 35 then
        sprite:Play("Idle")
        data.HasPlayedWaitingMusic = false
    end

    if sprite:IsFinished("PayNothing") then
        sprite:Play("Idle")
    elseif sprite:IsFinished("PayPrize") then
        sprite:Play("Prize")
    end

    if sprite:IsFinished("Prize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
        local rng = beggar:GetDropRNG()
        local player = data.LastPayer or Isaac.GetPlayer(0)
        local roll = rng:RandomFloat()
        

        if roll < 0.25 then
            mod:GiveTemporaryTechX(player)
            sprite:Play("Idle")
        else
            local collectible = techPool.Collectibles[rng:RandomInt(#techPool.Collectibles) + 1]
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible,
                Isaac.GetFreeNearPosition(beggar.Position, 40), Vector.Zero, nil)
                sprite:Play("Teleport")
        end
    elseif sprite:IsFinished("Teleport") then
        beggar:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.TechBeggarUpdate, myBeggar)



function mod:GiveTemporaryTechX(player)
    if not player or not player:ToPlayer() then return end

    sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
    player:AddCollectible(CollectibleType.COLLECTIBLE_TECH_X, 0, false)
    player:GetData().TechX_Timer = TECHX_DURATION

    print("[Tech Beggar] Gave temporary Tech X for 30 seconds!")
end

function mod:TechXTimerUpdate(player)
    local data = player:GetData()
    if data.TechX_Timer then
        data.TechX_Timer = data.TechX_Timer - 1
        if data.TechX_Timer <= 0 then
            data.TechX_Timer = nil
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_TECH_X)
            print("[Tech Beggar] Tech X expired.")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.TechXTimerUpdate)


function mod:TechBeggarExploded(beggar)
    for i = 1, 2 do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 1,
            beggar.Position + RandomVector() * 20, RandomVector() * 3, beggar)
    end
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.TechBeggarExploded, myBeggar)
