local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

---@class Utils
local utils = include("scripts.core.utils")

--- CONFIGURATION
---

---@type BeggarConfig
local beggarConfig = {
    baseChance = 0.02,
    multPerUse = 0.05,
    hasSecondary = true,
    secondaryBaseChance = 0.30,
    secondaryMultPerUse = 0.10,
    restockAffected = false
}

local BEGGAR_ITEM_POOL = ItemPoolType.POOL_NULL

--- Definitions
---

---@type CollectibleType[]
local custom_pool = {
    CollectibleType.COLLECTIBLE_BREAKFAST,
    CollectibleType.COLLECTIBLE_LUNCH,
    CollectibleType.COLLECTIBLE_SUPPER,
    CollectibleType.COLLECTIBLE_DESSERT,
    CollectibleType.COLLECTIBLE_ROTTEN_MEAT
}

local beggar = mod.Entities.BEGGAR_Elijah.Var

---@type beggarEventPool
local beggarPrimaryEvents = {
    {
        1,
        function(beggarEntity)
            beggarUtils.SpawnItemFromPool(beggarEntity, BEGGAR_ITEM_POOL)
            return true
        end
    },
    {
        2,
        function(beggarEntity)
            local item = utils.GetRandomFromTable(custom_pool)
            beggarUtils.SpawnItem(beggarEntity, item)
            return true
        end
    }
}

---@type beggarEventPool
local beggarSecondaryEvents = {
    {
        1, -- Heart
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_HEART)
            return false
        end
    },
    {
        1, -- Bomb
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_BOMB)
            return false
        end
    },
    {
        1, -- Key
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_KEY)
            return false
        end
    },
    {
        1, -- Tarot card
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_TAROTCARD)
            return false
        end
    }
}

local beggarFuncs = {}

--- Callbacks
---

---@param beggarEntity EntityNPC
---@param collider Entity
---@param _ any
function beggarFuncs:PostSlotCollision(beggarEntity, collider, _)
    local player = collider:ToPlayer()
    if not player then return end
    
    local ok = beggarUtils.OnBeggarCollision(beggarEntity, player, beggarConfig)
    if ok then
        player:PlayExtraAnimation("Sad")
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, beggarFuncs.PostSlotCollision, beggar)

---@param beggarEntity EntityNPC
function beggarFuncs:PostSlotUpdate(beggarEntity)
    beggarUtils.StateMachine(beggarEntity, beggarConfig, beggarPrimaryEvents, beggarSecondaryEvents)
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, beggarFuncs.PostSlotUpdate, beggar)

---@param beggarEntity EntityNPC
function beggarFuncs:PreSlotExplosion(beggarEntity)
    beggarUtils.DoBeggarExplosion(beggarEntity)
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, beggarFuncs.PreSlotExplosion, beggar)