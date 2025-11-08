local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local beggar = mod.ElijahNPCs.RottenBeggarElijah

local payouts = {
    {type="BLUE_FLY", chance=0.36},
    {type="BLUE_SPIDER", chance=0.36},
    {type="ROTTEN_HEART", chance=0.12},
    {type="BONE_HEART", chance=0.04},
    {type="TRINKET", chance=0.03},
    {type="FART", chance=0.05},
    {type="ITEM_POOL", chance=0.0416}
}

local trinkets = {
    TrinketType.TRINKET_FISH_TAIL,
    TrinketType.TRINKET_FISH_HEAD,
    TrinketType.TRINKET_BOBS_BLADDER,
    TrinketType.TRINKET_ROTTEN_PENNY
}

local function PickTrinket(player)
    local available = {}
    for _, t in ipairs(trinkets) do
        if not player:HasTrinket(t) then
            table.insert(available, t)
        end
    end
    if #available > 0 then
        return available[math.random(#available)]
    else
        return "FART"
    end
end

function mod:RottenBeggarCollision(beggarEntity, collider, low)
    if not collider:ToPlayer() then return end
    local player = collider:ToPlayer()
    local sprite = beggarEntity:GetSprite()

    if player:GetPlayerType() ~= mod.Players.Elijah then return end

    if sprite:IsPlaying("Idle") then
        local rng = beggarEntity:GetDropRNG()
        local paid = mod:DrainElijahStat(player)

        if paid then
            sfx:Play(SoundEffect.SOUND_SCAMPER)
            if rng:RandomFloat() > 0.5 then
                sprite:Play("PayPrize")
                beggarEntity:GetData().LastPayer = player
            else
                sprite:Play("PayNothing")
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.RottenBeggarCollision, beggar)

function mod:RottenBeggarUpdate(beggarEntity)
    local sprite = beggarEntity:GetSprite()
    local rng = beggarEntity:GetDropRNG()
    local data = beggarEntity:GetData()
    local player = data.LastPayer or Isaac.GetPlayer(0)

    if sprite:IsFinished("PayNothing") then
        sprite:Play("Idle")
    elseif sprite:IsFinished("PayPrize") then
        sprite:Play("Prize")
    end

    if sprite:IsFinished("Prize") then
        local roll = rng:RandomFloat()
        local accumulated = 0
        local chosen = nil
        for _, p in ipairs(payouts) do
            accumulated = accumulated + p.chance
            if roll <= accumulated then
                chosen = p
                break
            end
        end

        if chosen then
            if chosen.type == "BLUE_FLY" then
                Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0,
                    Isaac.GetFreeNearPosition(beggarEntity.Position, 20), Vector.Zero, nil)
            elseif chosen.type == "BLUE_SPIDER" then
                Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, 0,
                    Isaac.GetFreeNearPosition(beggarEntity.Position, 20), Vector.Zero, nil)
            elseif chosen.type == "ROTTEN_HEART" then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN,
                    Isaac.GetFreeNearPosition(beggarEntity.Position, 20), Vector.Zero, nil)
            elseif chosen.type == "BONE_HEART" then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE,
                    Isaac.GetFreeNearPosition(beggarEntity.Position, 20), Vector.Zero, nil)
            elseif chosen.type == "TRINKET" then
                local trinket = PickTrinket(player)
                if trinket == "FART" then
                    game:ButterFart(beggarEntity.Position, player)
                else
                    player:DropTrinket(trinket)
                end
            elseif chosen.type == "FART" then
                game:ButterFart(beggarEntity.Position, player)
            elseif chosen.type == "ITEM_POOL" then
                local item = game:GetItemPool():GetCollectible(ItemPoolType.POOL_ROTTEN_BEGGAR, true)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item,
                    Isaac.GetFreeNearPosition(beggarEntity.Position, 20), Vector.Zero, nil)
                sprite:Play("Teleport")
            end

            if chosen.type ~= "ITEM_POOL" then
                sprite:Play("Idle")
            end
        end
    end

    if sprite:IsFinished("Teleport") then
        beggarEntity:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.RottenBeggarUpdate, beggar)

function mod:RottenBeggarExploded(beggar)
    for i = 1, 2 do
        local offset = RandomVector() * 20
        Isaac.Spawn(EntityType.ENTITY_SMALL_MAGGOT, 0, 0, beggar.Position + offset, Vector.Zero, nil)
    end
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.RottenBeggarExploded, beggar)
