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
    secondaryBaseChance = 0.40,
    secondaryMultPerUse = 0.10,
    restockAffected = false
}

local BEGGAR_ITEM_POOL = ItemPoolType.POOL_ROTTEN_BEGGAR

--- Definitions
---

---@type TrinketType[]
local rotten_trinkets = {
    TrinketType.TRINKET_FISH_TAIL,
    TrinketType.TRINKET_FISH_HEAD,
    TrinketType.TRINKET_BOBS_BLADDER,
    TrinketType.TRINKET_ROTTEN_PENNY
}

local beggar = mod.Entities.BEGGAR_RottenElijah.Var

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
    -- Blue Fly - 70%
    {
        70,
        function(beggarEntity)
            beggarUtils.SpawnFamiliar(beggarEntity, FamiliarVariant.BLUE_FLY)
            return false
        end
    },
    -- Blue Spider - 70%
    {
        70,
        function(beggarEntity)
            beggarUtils.SpawnFamiliar(beggarEntity, FamiliarVariant.BLUE_SPIDER)
            return false
        end
    },
    -- Rotten Heart - 15%
    {
        15,
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN)
            return false
        end
    },
    -- Bone Heart - 10%
    {
        10,
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE)
            return false
        end
    },
    -- Trinket - 5%
    {
        5,
        function(beggarEntity)
            local trinket = utils.GetRandomFromTable(rotten_trinkets)
            beggarUtils.SpawnTrinket(beggarEntity, trinket)
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
    -- Spawn maggots on explosion
    for _ = 1, 2 do
        local offset = RandomVector() * 20
        Isaac.Spawn(EntityType.ENTITY_SMALL_MAGGOT, 0, 0, beggarEntity.Position + offset, Vector.Zero, nil)
    end
    beggarUtils.DoBeggarExplosion(beggarEntity)
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, beggarFuncs.PreSlotExplosion, beggar)