local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

--- CONFIGURATION
---

---@type BeggarConfig
local beggarConfig = {
    baseChance = 0.10,
    multPerUse = 0.05,
    hasSecondary = true,
    secondaryBaseChance = 0.50,
    secondaryMultPerUse = 0.10,
    restockAffected = false
}

local BEGGAR_ITEM_POOL = ItemPoolType.POOL_BATTERY_BUM

--- Definitions
---

local beggar = mod.Entities.BEGGAR_BatteryElijah.Var

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
        5,
        function(beggarEntity)
            beggarUtils.SpawnTrinket(beggarEntity, TrinketType.TRINKET_WATCH_BATTERY)
            return true
        end
    },
    {
        5,
        function(beggarEntity)
            beggarUtils.SpawnTrinket(beggarEntity, TrinketType.TRINKET_AAA_BATTERY)
            return true
        end
    }
}

---@type beggarEventPool
local beggarSecondaryEvents = {
    {
        1,
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_LIL_BATTERY)
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