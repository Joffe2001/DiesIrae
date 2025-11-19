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

--- Definitions
---

---@type CollectibleType[]
local custom_pool = {
    CollectibleType.COLLECTIBLE_TECHNOLOGY,
    CollectibleType.COLLECTIBLE_TECH_X,
    CollectibleType.COLLECTIBLE_TECHNOLOGY_2,
    CollectibleType.COLLECTIBLE_TRACTOR_BEAM,
    CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
    CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE,
    CollectibleType.COLLECTIBLE_ROBO_BABY,
    CollectibleType.COLLECTIBLE_ROBO_BABY_2,
    CollectibleType.COLLECTIBLE_TECH_5,
    CollectibleType.COLLECTIBLE_SPIDER_MOD,
    CollectibleType.COLLECTIBLE_JACOBS_LADDER,
    CollectibleType.COLLECTIBLE_120_VOLT,
    CollectibleType.COLLECTIBLE_BOT_FLY
}

local beggar = mod.Entities.BEGGAR_TechElijah.Var

---@type beggarEventPool
local beggarEvents = {
    {
        1,
        function(beggarEntity)
            local item = utils.GetRandomFromTable(custom_pool)
            beggarUtils.SpawnItem(beggarEntity, item)
            return true
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
    for i = 1, 2 do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 1,
            beggarEntity.Position + RandomVector() * 20, RandomVector() * 3, beggarEntity)
    end
    beggarUtils.DoBeggarExplosion(beggarEntity)
    return false
end

mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, beggarFuncs.PreSlotExplosion, beggar)
