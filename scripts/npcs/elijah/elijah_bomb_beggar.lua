local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local beggar = mod.Entities.BEGGAR_BombElijah.Var

local chanceNothing = 0.5
local chanceBomb = 0.45
local chanceItem = 0.05

function mod:BombBeggarCollision(beggarEntity, collider, low)
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
            if rng:RandomFloat() > chanceNothing then
                sprite:Play("PayPrize")
                beggarEntity:GetData().LastPayer = player
            else
                sprite:Play("PayNothing")
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.BombBeggarCollision, beggar)

function mod:BombBeggarUpdate(beggarEntity)
    local sprite = beggarEntity:GetSprite()
    local rng = beggarEntity:GetDropRNG()
    local data = beggarEntity:GetData()

    if sprite:IsFinished("PayNothing") then
        sprite:Play("Idle")
    elseif sprite:IsFinished("PayPrize") then
        sprite:Play("Prize")
    end
    if sprite:IsFinished("Prize") then
        local player = data.LastPayer or Isaac.GetPlayer(0)
        local roll = rng:RandomFloat()

        if roll < chanceItem then
            sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
            local item = game:GetItemPool():GetCollectible(ItemPoolType.POOL_BOMB_BUM, true)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item,
                Isaac.GetFreeNearPosition(beggarEntity.Position, 40), Vector.Zero, nil)
            sprite:Play("Teleport")

        elseif roll <= chanceItem + chanceBomb then
            sfx:Play(SoundEffect.SOUND_FETUS_FEET)
            player:AddBombs(1)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, beggarEntity.Position, Vector.Zero, nil)
            Game():GetHUD():ShowItemText("Bomb Beggar", "+1 Bomb")

            sprite:Play("Idle")
        end
    end

    if sprite:IsFinished("Teleport") then
        beggarEntity:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.BombBeggarUpdate, beggar)

function mod:BombBeggarExploded(beggar)
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() == mod.Players.Elijah then
        player:AddBombs(1)
    end
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.BombBeggarExploded, beggar)
