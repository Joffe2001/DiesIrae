local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local beggar = mod.ElijahNPCs.BeggarElijah

local payChance = 0.5
local prizeChance = 0.2

local beggarPrizes = {
    {type = PickupVariant.PICKUP_HEART, chance = 0.25, teleport = false},
    {type = PickupVariant.PICKUP_TAROTCARD, chance = 0.25, teleport = false},
    {type = PickupVariant.PICKUP_COLLECTIBLE, chance = 0.25, teleport = true},
    {type = "FOOD_POOL", chance = 0.25, teleport = true}
}

local foods = {
    CollectibleType.COLLECTIBLE_BREAKFAST,
    CollectibleType.COLLECTIBLE_LUNCH,
    CollectibleType.COLLECTIBLE_SUPPER,
    CollectibleType.COLLECTIBLE_DESSERT,
    CollectibleType.COLLECTIBLE_ROTTEN_MEAT
}

function mod:BeggarCollision(beggarEntity, collider, low)
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

            if rng:RandomFloat() > payChance then
                sprite:Play("PayPrize")
                beggarEntity:GetData().LastPayer = player
            else
                sprite:Play("PayNothing")
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.BeggarCollision, beggar)

function mod:BeggarUpdate(beggarEntity)
    local sprite = beggarEntity:GetSprite()
    local rng = beggarEntity:GetDropRNG()
    local data = beggarEntity:GetData()

    if sprite:IsFinished("PayNothing") then
        sprite:Play("Idle")
    elseif sprite:IsFinished("PayPrize") then
        sprite:Play("Prize")
    end

    if sprite:IsFinished("Prize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
        local totalChance = 0
        for _, p in ipairs(beggarPrizes) do
            totalChance = totalChance + p.chance
        end

        local roll = rng:RandomFloat() * totalChance
        local accumulated = 0
        local chosenPrize = nil

        for _, p in ipairs(beggarPrizes) do
            accumulated = accumulated + p.chance
            if roll <= accumulated then
                chosenPrize = p
                break
            end
        end

        if chosenPrize then
            if chosenPrize.type == "FOOD_POOL" then
                local food = foods[rng:RandomInt(#foods) + 1]
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, food,
                    Isaac.GetFreeNearPosition(beggarEntity.Position, 40), Vector.Zero, nil)
            elseif chosenPrize.type == PickupVariant.PICKUP_COLLECTIBLE then
                local item = game:GetItemPool():GetCollectible(ItemPoolType.POOL_BEGGAR, true)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item,
                    Isaac.GetFreeNearPosition(beggarEntity.Position, 40), Vector.Zero, nil)
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP, chosenPrize.type, 0,
                    Isaac.GetFreeNearPosition(beggarEntity.Position, 40), Vector.Zero, nil)
            end

            if chosenPrize.teleport then
                sprite:Play("Teleport")
            else
                sprite:Play("Idle")
            end
        else
            sprite:Play("Idle")
        end
    end

    if sprite:IsFinished("Teleport") then
        beggarEntity:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.BeggarUpdate, beggar)

function mod:BeggarExploded(beggar)
    local player = Isaac.GetPlayer(0)
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.BeggarExploded, beggar)

