local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

---@class Utils
local utils = include("scripts.core.utils")

--- MAGIC NUMBERS
---

local BASE_REWARD_CHANCES = 0.2
local BEGGAR_ITEM_POOL = ItemPoolType.POOL_NULL

local BEGGAR_PICKUP = PickupVariant.PICKUP_HEART
local BEGGAR_PICKUP2 = PickupVariant.PICKUP_TAROTCARD

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
        2,
        function(beggarEntity)
            local item = utils.GetRandomFromTable(custom_pool)
            beggarUtils.SpawnItemFromPool(beggarEntity, item)
            return true
        end
    },
    {
        2,
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, BEGGAR_PICKUP)
            return false
        end
    },
    {
        2,
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, BEGGAR_PICKUP2)
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
