local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

--- CONFIGURATION
---

---@type BeggarConfig
local beggarConfig = {
    baseChance = 0.05,
    multPerUse = 0.05,
    hasSecondary = true,
    secondaryBaseChance = 0.50,
    secondaryMultPerUse = 0.20,
    restockAffected = true
}

local BEGGAR_ITEM_POOL = ItemPoolType.POOL_SHOP

--- Definitions
---

local beggar = mod.Entities.BEGGAR_ShopElijah.Var

---@type beggarEventPool
local beggarPrimaryEvents = {
    {
        1,
        function(beggarEntity)
            beggarUtils.SpawnItemFromPool(beggarEntity, BEGGAR_ITEM_POOL)
            return true
        end
    }
}

---@type beggarEventPool
local beggarSecondaryEvents = {
    {
        4, -- Heart 
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL)
            return false
        end
    },
    {
        5, -- Half Heart 
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF)
            return false
        end
    },
    {
        1, -- Soul Heart 
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL)
            return false
        end
    },
        {
        2, -- Half Soul Heart 
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL)
            return false
        end
    },
    {
        6, -- Bomb 
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL)
            return false
        end
    },
    {
        6, -- Key
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL)
            return false
        end
    },
    {
        3, -- Lil Battery
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_MICRO)
            return false
        end
    },
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