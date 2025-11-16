local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local music = MusicManager()
local GuppyBeggar = mod.Entities.GuppyBeggar.Var

local giveChance = 0.5 
local GuppyPool = {
    Collectibles = {
        CollectibleType.COLLECTIBLE_GUPPYS_EYE,
        CollectibleType.COLLECTIBLE_GUPPYS_PAW,
        CollectibleType.COLLECTIBLE_GUPPYS_TAIL,
        CollectibleType.COLLECTIBLE_GUPPYS_HEAD,
        CollectibleType.COLLECTIBLE_GUPPYS_HAIRBALL,
        CollectibleType.COLLECTIBLE_GUPPYS_COLLAR,
        mod.Items.GuppysSoul,
    }
}

function mod:GuppyBeggarCollision(beggar, collider, low)
    if not collider:ToPlayer() then return end
    local player = collider:ToPlayer()
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()

    if data.EasterEggActive then return end

    if sprite:IsPlaying("Idle") then
        if player:GetBrokenHearts() < 12 then
            player:AddBrokenHearts(1)
            sfx:Play(SoundEffect.SOUND_SCAMPER)
            sprite:Play("PayPrize")
            data.LastPayer = player
        else
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
            sprite:Play("PayNothing")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.GuppyBeggarCollision, GuppyBeggar)

function mod:GuppyBeggarUpdate(beggar)
    local sprite = beggar:GetSprite()
    local rng = beggar:GetDropRNG()
    local data = beggar:GetData()
    local player = Isaac.GetPlayer(0)

    if not data.Init then
        data.Init = true
        data.GaveNothingBefore = false
        data.Timer = 0 
        data.EasterEggActive = false
        data.EasterEggPhase = 0
    end

    if sprite:IsFinished("PayNothing") then
        sprite:Play("Idle")
    elseif sprite:IsFinished("PayPrize") then
        sprite:Play("Prize")
    elseif sprite:IsFinished("Prize") then
        local roll = rng:RandomFloat()
        if (not data.GaveNothingBefore and roll < giveChance) or data.GaveNothingBefore then
            local itemList = GuppyPool.Collectibles
            local item = itemList[rng:RandomInt(#itemList) + 1]
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item,
                Isaac.GetFreeNearPosition(beggar.Position, 40), Vector.Zero, nil)
            sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
            sprite:Play("Teleport")
        else
            data.GaveNothingBefore = true
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
            sprite:Play("PayNothing")
        end
    elseif sprite:IsFinished("Teleport") then
        beggar:Remove()
        return
    end

    data.Timer = data.Timer + 1
    if not data.EasterEggActive and data.Timer >= 90 * 30 then
        data.EasterEggActive = true
        data.EasterEggPhase = 1
        sprite:Play("Waiting")
        music:Play(mod.Music.Oiiai)
    end

    if data.EasterEggActive then
        if data.EasterEggPhase == 1 and data.Timer >= (90 + 25) * 30 then
            data.EasterEggPhase = 2
            sprite:Play("Waiting2")
        elseif data.EasterEggPhase == 2 and data.Timer >= (90 + 25 + 25) * 30 then
            data.EasterEggPhase = 3
            sprite:Play("Waiting3")
        elseif sprite:IsFinished("Waiting3") then
            local itemList = GuppyPool.Collectibles
            local item = itemList[rng:RandomInt(#itemList) + 1]
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item,
                Isaac.GetFreeNearPosition(beggar.Position, 40), Vector.Zero, nil)
            beggar:Remove()
            music:Disable()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.GuppyBeggarUpdate, GuppyBeggar)

function mod:OnPostNewRoom()
    for _, beggar in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, GuppyBeggar, -1, false, false)) do
        beggar:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnPostNewRoom)