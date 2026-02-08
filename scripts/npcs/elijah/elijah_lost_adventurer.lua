---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

local LA = mod.Entities.BEGGAR_Lost_Adventurer_E.Var
local elijah = mod.Players.Elijah


local BASE_FINAL_CHANCE = 0.02
local BASE_SECONDARY_CHANCE = 0.10
local FINAL_MULT = 0.02
local SECONDARY_MULT = 0.15   


function mod:LAElijahInit(beggar)
    local data = beggar:GetData()
    data.Payments = 0
    data.CanPay = true
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, mod.LAElijahInit, LA)


local function RevealRandomRoomElijah()
    local level = game:GetLevel()
    local rooms = level:GetRooms()
    local unseen = {}

    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if desc.DisplayFlags == 0 then
            unseen[#unseen + 1] = desc
        end
    end

    if #unseen > 0 then
        local room = unseen[math.random(#unseen)]
        room.DisplayFlags = RoomDescriptor.DISPLAY_BOX
        level:UpdateVisibility()
        sfx:Play(SoundEffect.SOUND_SHELLGAME)
    end
end

function mod:LAElijahCollision(beggar, collider)
    if beggar.Variant ~= LA then return end
    
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= elijah then return end

    local sprite = beggar:GetSprite()
    local data = beggar:GetData()
    local rng = beggar:GetDropRNG()

    if not data.CanPay then return end
    if not sprite:IsPlaying("Idle") then return end

    if not beggarUtils.DrainElijahsWill(player, rng) then
        return
    end

    data.CanPay = false
    data.Payments = data.Payments + 1

    sfx:Play(SoundEffect.SOUND_SCAMPER)
    sprite:Play("PayNothing", true)
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.LAElijahCollision, LA)

function mod:LAElijahUpdate(beggar)
    if beggar.Variant ~= LA then return end
    
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()
    local rng = beggar:GetDropRNG()

    if sprite:IsFinished("PayNothing") then
        local finalChance =
            BASE_FINAL_CHANCE + FINAL_MULT * (data.Payments - 1)
        local secondaryChance =
            BASE_SECONDARY_CHANCE + SECONDARY_MULT * (data.Payments - 1)

        finalChance = math.min(finalChance, 1)
        secondaryChance = math.min(secondaryChance, 1)

        local roll = rng:RandomFloat()

        if roll < finalChance then
            sprite:Play("PayPrize", true)
            data.Payments = 0
            return
        end

        if roll < finalChance + secondaryChance then
            sprite:Play("Prize", true)
            return
        end
        data.CanPay = true
        sprite:Play("Idle", true)
    end

    if sprite:IsFinished("Prize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
        RevealRandomRoomElijah()
        
        data.Payments = 0
        data.CanPay = true
        sprite:Play("Idle", true)
    end

    if sprite:IsFinished("PayPrize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)

        local pool = mod.Pools.LostAdventurer
        if pool and #pool > 0 then
            local item = pool[rng:RandomInt(#pool) + 1]
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                item,
                Isaac.GetFreeNearPosition(beggar.Position, 40),
                Vector.Zero,
                nil
            )
        end

        sprite:Play("Teleport", true)
    end

    if sprite:IsFinished("Teleport") then
        local runSave = mod.SaveManager.GetRunSave()
        runSave.SpawnLostAdventurerCorpse = true
        beggar:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.LAElijahUpdate, LA)

function mod:LAElijahExploded(beggar)
    if beggar.Variant ~= LA then return end
    
    beggarUtils.DoBeggarExplosion(beggar)
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.LAElijahExploded, LA)

local CORPSE_LA = mod.Entities.EFFECT_LACorpse.Var

function mod:SpawnLostAdventurerCorpseElijah()
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end
    
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
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SpawnLostAdventurerCorpseElijah)