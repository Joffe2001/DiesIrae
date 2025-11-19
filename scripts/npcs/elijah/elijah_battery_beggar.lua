local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

--- MAGIC NUMBERS
---

local BASE_REWARD_CHANCES = 0.25
local BEGGAR_ITEM_POOL = ItemPoolType.POOL_BATTERY_BUM
local BEGGAR_PICKUP = PickupVariant.PICKUP_LIL_BATTERY

--- Definitions
---

local beggar = mod.Entities.BEGGAR_BatteryElijah.Var

---@type beggarEventPool
local beggarEvents = {
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
    },
    {
        20,
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, BEGGAR_PICKUP)
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

    local ok = beggarUtils.OnBeggarCollision(beggarEntity, player, BASE_REWARD_CHANCES)
    if ok then
        player:PlayExtraAnimation("Sad")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, beggarFuncs.PostSlotCollision, beggar)


---@param beggarEntity EntityNPC
function beggarFuncs:PostSlotUpdate(beggarEntity)
    beggarUtils.StateMachine(beggarEntity, beggarEvents)
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, beggarFuncs.PostSlotUpdate, beggar)


---@param beggarEntity EntityNPC
function beggarFuncs:PreSlotExplosion(beggarEntity)
    beggarUtils.DoBeggarExplosion(beggarEntity)
    return false
end

mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, beggarFuncs.PreSlotExplosion, beggar)
