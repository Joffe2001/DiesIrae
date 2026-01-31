local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class Utils
local utils = include("scripts.core.utils")

--- MAGIC NUMBERS
---
local NEAR_POSITION = 30

-- Synergy bonuses
local LUCKY_FOOT_BASE_BONUS = 0.05
local LUCKY_FOOT_MULT_BONUS = 0.01
local BFFS_BASE_BONUS = 0.05
local BFFS_MULT_BONUS = 0.01

-- Restock penalties (ONLY for shop beggars)
local RESTOCK_PRIMARY_BASE_PENALTY = 0.05
local RESTOCK_PRIMARY_MULT_PENALTY = 0.01
local RESTOCK_SECONDARY_BASE_PENALTY = 0.10
local RESTOCK_SECONDARY_MULT_PENALTY = 0.05

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
            data.WillSpeed = (data.WillSpeed) - WILL_SPEED_UP
        end
    },
    {
        key = "WillFireDelay",
        func = function(data)
            data.WillFireDelay = (data.WillFireDelay) - WILL_TEARS_UP
        end
    },
    {
        key = "WillDamage",
        func = function(data)
            data.WillDamage = (data.WillDamage) - WILL_DAMAGE_UP
        end
    },
    {
        key = "WillRange",
        func = function(data)
            data.WillRange = (data.WillRange) - WILL_RANGE_UP
        end
    },
    {
        key = "WillShotSpeed",
        func = function(data)
            data.WillShotSpeed = (data.WillShotSpeed) - WILL_SHOT_SPEED_UP
        end
    },
    {
        key = "WillLuck",
        func = function(data)
            data.WillLuck = (data.WillLuck) - WILL_LUCK_UP
        end
    },
}

---@class BeggarConfig
---@field baseChance number
---@field multPerUse number
---@field hasSecondary boolean
---@field secondaryBaseChance number
---@field secondaryMultPerUse number
---@field restockAffected boolean

---@class BeggarUtils
local beggarFuncs = {}

--- Helper Functions
---

---Synergies
---@param player EntityPlayer
---@return number baseBonus, number multBonus
local function GetSynergies(player)
    local baseBonus, multBonus = 0, 0

    if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
        baseBonus = baseBonus + LUCKY_FOOT_BASE_BONUS
        multBonus = multBonus + LUCKY_FOOT_MULT_BONUS
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        baseBonus = baseBonus + BFFS_BASE_BONUS
        multBonus = multBonus + BFFS_MULT_BONUS
    end

    return baseBonus, multBonus
end

local function HasRestock(player)
    return player and player:HasCollectible(CollectibleType.COLLECTIBLE_RESTOCK)
end

---@param config BeggarConfig
---@param timesUsed number
---@param player EntityPlayer
---@return number
local function CalculateRewardChance(config, timesUsed, player)
    local baseBonus, multBonus = GetSynergies(player)
    
    local baseChance = config.baseChance
    local multPerUse = config.multPerUse
    
    if config.restockAffected and HasRestock(player) then
        baseChance = baseChance - RESTOCK_PRIMARY_BASE_PENALTY
        multPerUse = multPerUse - RESTOCK_PRIMARY_MULT_PENALTY
    end
    
    local chance =
        baseChance +
        baseBonus +
        (multPerUse + multBonus) * timesUsed +
        (player.Luck / 100)

    return math.max(0, math.min(1, chance))
end

function beggarFuncs.TrySecondaryReward(beggar, player, config)
    if not config.hasSecondary or config.secondaryBaseChance <= 0 then
        return false
    end

    local data = beggar:GetData()
    local rng = beggar:GetDropRNG()

    data.SecondaryUses = data.SecondaryUses or 0

    local base = config.secondaryBaseChance
    local mult = config.secondaryMultPerUse

    if config.restockAffected and HasRestock(player) then
        base = base - RESTOCK_SECONDARY_BASE_PENALTY
        mult = mult - RESTOCK_SECONDARY_MULT_PENALTY
    end

    local chance = math.max(0, math.min(1, base + mult * data.SecondaryUses))

    if rng:RandomFloat() < chance then
        data.SecondaryUses = 0
        data.GiveSecondary = true
        return true
    else
        data.SecondaryUses = data.SecondaryUses + 1
        data.GiveSecondary = false
        return false
    end
end

--- Main Functions
---

function beggarFuncs.OnBeggarCollision(beggar, player, config)
    local sprite = beggar:GetSprite()
    if player:GetPlayerType() ~= elijah then return false end
    if not sprite:IsPlaying("Idle") then return false end

    local rng = beggar:GetDropRNG()
    if not beggarFuncs.DrainElijahsWill(player, rng) then return false end

    sfx:Play(SoundEffect.SOUND_SCAMPER)

    local data = beggar:GetData()
    data.TimesUsed = (data.TimesUsed or 0) + 1

    local primaryChance = CalculateRewardChance(config, data.TimesUsed - 1, player)
    local gavePrimary = rng:RandomFloat() < primaryChance
    local gaveSecondary = false

    if not gavePrimary then
        gaveSecondary = beggarFuncs.TrySecondaryReward(beggar, player, config)
    end

    if gavePrimary then
        sprite:Play("PayPrize")
        data.LastRewardType = "primary"
    elseif gaveSecondary then
        sprite:Play("PayPrize")
        data.LastRewardType = "secondary"
    else
        sprite:Play("PayNothing")
        data.LastRewardType = "nothing"
    end
    return true
end

function beggarFuncs.DrainElijahsWill(player, rng)
    if player:GetPlayerType() ~= elijah then return false end

    local data = mod.SaveManager.GetRunSave(player)
    
    if (data.WillCount or 0) <= 0 then
        return false
    end
    
    local canGoDown = {}

    for _, stat in ipairs(statsDownFuncs) do
        if (data[stat.key] or 0) > 0 then
            table.insert(canGoDown, stat)
        end
    end

    if #canGoDown == 0 then return false end
    
    canGoDown[rng:RandomInt(#canGoDown) + 1].func(data)
    
    data.WillCount = math.max(0, (data.WillCount or 0) - 1)

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
    
    return true
end

function beggarFuncs.StateMachine(beggarEntity, config, primaryPool, secondaryPool)
    local sprite = beggarEntity:GetSprite()
    local rng = beggarEntity:GetDropRNG()
    local data = beggarEntity:GetData()
    local player = PlayerManager.FirstPlayerByType(elijah)

    if sprite:IsFinished("PayNothing") then
        sprite:Play("Idle")
    elseif sprite:IsFinished("PayPrize") then
        sprite:Play("Prize")
    end

    if sprite:IsFinished("Prize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)

        local shouldTeleport = true

        if data.LastRewardType == "primary" then
            shouldTeleport = utils.WeightedRandom(primaryPool, rng)(beggarEntity, player)
        elseif data.LastRewardType == "secondary" and secondaryPool then
            shouldTeleport = utils.WeightedRandom(secondaryPool, rng)(beggarEntity, player)
        end

        -- Restock: Shop beggars never teleport
        if config.restockAffected and HasRestock(player) then
            shouldTeleport = false
        end

        sprite:Play(shouldTeleport and "Teleport" or "Idle")
        data.LastRewardType = nil
    end

    if sprite:IsFinished("Teleport") then
        beggarEntity:Remove()
    end
end

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
    
    if mod.Pools and mod.Pools.Trinket_blacklist then
        while mod.Pools.Trinket_blacklist[item] do
            item = game:GetItemPool():GetCollectible(itemPool, true, beggarEntity:GetDropRNG():Next())
        end
    end
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