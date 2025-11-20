local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class Utils
local utils = include("scripts.core.utils")


--- MAGIC NUMBERS
---

local BASE_REWARD_CHANCES = 0.33
local NEAR_POSITION = 30


--- Definitions
---

local elijah = mod.Players.Elijah


---@alias statDownFun fun(data: table)
---@class StatDownEntry
---@field key string
---@field func statDownFun
---@type StatDownEntry[]
local statsDownFuncs = {
    {
        key = "WillSpeed",
        func = function(data)
            data.WillSpeed = (data.WillSpeed or 0) - WILL_SPEED_UP
        end
    },
    {
        key = "WillFireDelay",
        func = function(data)
            data.WillFireDelay = (data.WillFireDelay or 0) - WILL_TEARS_UP
        end
    },
    {
        key = "WillDamage",
        func = function(data)
            data.WillDamage = (data.WillDamage or 0) - WILL_DAMAGE_UP
        end
    },
    {
        key = "WillRange",
        func = function(data)
            data.WillRange = (data.WillRange or 0) - WILL_RANGE_UP
        end
    },
    {
        key = "WillShotSpeed",
        func = function(data)
            data.WillShotSpeed = (data.WillShotSpeed or 0) - WILL_SHOT_SPEED_UP
        end
    },
    {
        key = "WillLuck",
        func = function(data)
            data.WillLuck = (data.WillLuck or 0) - WILL_LUCK_UP
        end
    },
}

---@class BeggarUtils
local beggarFuncs = {}


--- Functions
---

---Simulate a beggar drop
---@param beggar EntityNPC
---@param player EntityPlayer
---@param rewardChance number | nil
---@return boolean
function beggarFuncs.OnBeggarCollision(beggar, player, rewardChance)
    local sprite = beggar:GetSprite()

    if player:GetPlayerType() ~= elijah then return false end
    if not sprite:IsPlaying("Idle") then return false end

    local rng = beggar:GetDropRNG()
    local paid = beggarFuncs.DrainElijahsWill(player, rng)

    if not paid then return false end

    player:AddCacheFlags(CacheFlag.CACHE_ALL, true)

    sfx:Play(SoundEffect.SOUND_SCAMPER)

    if rng:RandomFloat() < (rewardChance or BASE_REWARD_CHANCES) then
        sprite:Play("PayPrize")
    else
        sprite:Play("PayNothing")
    end

    return true
end


---Remove stats from an Elijah character
---@param player EntityPlayer
---@param rng RNG
---@return boolean
function beggarFuncs.DrainElijahsWill(player, rng)
    if player:GetPlayerType() ~= elijah then return false end

    local data = mod.SaveManager.GetRunSave(player)

    local canGoDown = {}

    for _, stat in ipairs(statsDownFuncs) do
        if (data[stat.key] or 0) > 0 then
            table.insert(canGoDown, stat)
        end
    end

    if #canGoDown == 0 then return false end

    local pick = canGoDown[rng:RandomInt(#canGoDown) + 1]
    pick.func(data)
    return true
end


---Basic beggar stats machine that gives a random item from a pool then vanish
---@param beggarEntity EntityNPC
---@alias beggarEventFunc fun(beggarEntity: EntityNPC, playerEntity: EntityPlayer | nil): boolean
---@alias beggarEventEntry { [1]: integer, [2]: beggarEventFunc }
---@alias beggarEventPool beggarEventEntry[]
---@param pool beggarEventPool
function beggarFuncs.StateMachine(beggarEntity, pool)
    local sprite = beggarEntity:GetSprite()
    local rng = beggarEntity:GetDropRNG()

    if sprite:IsFinished("PayNothing") then
        sprite:Play("Idle")
    elseif sprite:IsFinished("PayPrize") then
        sprite:Play("Prize")
    end

    if sprite:IsFinished("Prize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)

        ---@type beggarEventFunc
        local BeggarEvent = utils.WeightedRandom(pool, rng)
        local shouldTeleport = BeggarEvent(beggarEntity, PlayerManager.FirstPlayerByType(elijah))

        if shouldTeleport then
            sprite:Play("Teleport")
        else
            sprite:Play("Idle")
        end
    end

    if sprite:IsFinished("Teleport") then
        beggarEntity:Remove()
    end
end


---SFX BOOM then remove the beggar
---@param beggar EntityNPC
function beggarFuncs.DoBeggarExplosion(beggar)
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
end


---@param beggarEntity EntityNPC
---@param itemPool ItemPoolType
function beggarFuncs.SpawnItemFromPool(beggarEntity, itemPool)
    local item = game:GetItemPool():GetCollectible(itemPool, true, beggarEntity:GetDropRNG():Next())
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item,
        Isaac.GetFreeNearPosition(beggarEntity.Position, NEAR_POSITION), Vector.Zero, beggarEntity)
end

---@param beggarEntity EntityNPC
---@param collectibleType CollectibleType
function beggarFuncs.SpawnItem(beggarEntity, collectibleType)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectibleType,
        Isaac.GetFreeNearPosition(beggarEntity.Position, NEAR_POSITION), Vector.Zero, beggarEntity)
end

---@param beggarEntity EntityNPC
---@param pickupVariant PickupVariant
---@param pickupSubtype integer | nil
function beggarFuncs.SpawnPickup(beggarEntity, pickupVariant, pickupSubtype)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, pickupVariant, pickupSubtype or 0,
        Isaac.GetFreeNearPosition(beggarEntity.Position, NEAR_POSITION), Vector.Zero, beggarEntity)
end

---@param beggarEntity EntityNPC
---@param trinketType TrinketType
function beggarFuncs.SpawnTrinket(beggarEntity, trinketType)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinketType,
        Isaac.GetFreeNearPosition(beggarEntity.Position, NEAR_POSITION), Vector.Zero, beggarEntity)
end

---@param beggarEntity EntityNPC
---@param familiarVariant FamiliarVariant
function beggarFuncs.SpawnFamiliar(beggarEntity, familiarVariant)
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, familiarVariant, 0,
        Isaac.GetFreeNearPosition(beggarEntity.Position, NEAR_POSITION), Vector.Zero, beggarEntity)
end


return beggarFuncs
