---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local LA = mod.Entities.BEGGAR_Lost_Adventurer.Var
local CORPSE_LA = mod.Entities.EFFECT_LACorpse.Var

local basePrizeChance = 0.02
local chanceIncrement = 0.02

function mod:LAInit(beggar)
    local data = beggar:GetData()
    data.PaymentCount = 0
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, mod.LAInit, LA)

function RevealRandomRoom()
    local level = game:GetLevel()
    local rooms = level:GetRooms()
    local unseen = {}

    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if not desc.DisplayFlags or desc.DisplayFlags == 0 then
            table.insert(unseen, desc)
        end
    end

    if #unseen > 0 then
        local room = unseen[math.random(#unseen)]
        room.DisplayFlags = RoomDescriptor.DISPLAY_BOX
        level:UpdateVisibility()
        sfx:Play(SoundEffect.SOUND_SHELLGAME)
    end
end

function mod:LACollision(beggar, collider)
    local player = collider:ToPlayer()
    if not player then return end

    local sprite = beggar:GetSprite()
    local data = beggar:GetData()

    if data.CanPay == nil then
        data.CanPay = true
    end
    if not data.CanPay then return end
    if player:GetNumCoins() <= 0 then return end

    data.CanPay = false
    player:AddCoins(-1)

    data.PaymentCount = (data.PaymentCount or 0) + 1
    sfx:Play(SoundEffect.SOUND_SCAMPER)

    local rng = beggar:GetDropRNG()
    local chance = basePrizeChance + chanceIncrement * (data.PaymentCount - 1)

    if rng:RandomFloat() < chance then
        sprite:Play("PayPrize", true)
        data.PaymentCount = 0
        data.LastPayer = player
    else
        sprite:Play("PayNothing", true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.LACollision, LA)

function mod:LAUpdate(beggar)
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()

    if sprite:IsFinished("PayNothing") then
        sprite:Play("Idle", true)
        data.CanPay = true
    end

    if sprite:IsFinished("PayPrize") then
        sprite:Play("Prize", true)
    end

    if sprite:IsFinished("Prize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)

        local rng = beggar:GetDropRNG()
        local roll = rng:RandomFloat()

        if roll < 0.25 then
            RevealRandomRoom()
            sprite:Play("Idle", true)
            data.CanPay = true
        else
            local collectible =
                mod.Pools.LostAdventurer[rng:RandomInt(#mod.Pools.LostAdventurer) + 1]

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                collectible,
                Isaac.GetFreeNearPosition(beggar.Position, 40),
                Vector.Zero,
                nil
            )

            sprite:Play("Teleport", true)
        end
    end

    if sprite:IsFinished("Teleport") then
        local runSave = mod.SaveManager.GetRunSave()
        runSave.SpawnLostAdventurerCorpse = true
        beggar:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.LAUpdate, LA)


function mod:LAExploded(beggar)
    for i = 1, 2 do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 1,
            beggar.Position + RandomVector() * 20, RandomVector() * 3, beggar)
    end
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.LAExploded, LA)

function mod:SpawnLostAdventurerCorpse()
    local runSave = mod.SaveManager.GetRunSave()
    local room = game:GetRoom()
    
    if not runSave.SpawnLostAdventurerCorpse then return end
    if room:GetType() ~= RoomType.ROOM_DEFAULT then return end
    if not room:IsFirstVisit() then return end
    
    local centerPos = room:GetCenterPos()
    local corpse = Isaac.Spawn(
        EntityType.ENTITY_SLOT,
        CORPSE_LA,
        2, 
        centerPos,
        Vector.Zero,
        nil
    ):ToNPC()
    
    if corpse then
        local sprite = corpse:GetSprite()
        sprite:Play("Idle", true)

        corpse.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
    runSave.SpawnLostAdventurerCorpse = false
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SpawnLostAdventurerCorpse)