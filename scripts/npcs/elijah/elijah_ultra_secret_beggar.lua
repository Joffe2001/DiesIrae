local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

---@class Utils
local utils = include("scripts.core.utils")

--- MAGIC NUMBERS
---

local BASE_REWARD_CHANCES = 0.33
local BEGGAR_ITEM_POOL = ItemPoolType.POOL_ULTRA_SECRET

--- Definitions
---

---@type TrinketType[]
local red_trinkets = {
    TrinketType.TRINKET_PERFECTION,
    TrinketType.TRINKET_APOLLYONS_BEST_FRIEND,
    TrinketType.TRINKET_NUH_UH,
    TrinketType.TRINKET_PANIC_BUTTON,
    TrinketType.TRINKET_RING_CAP,
    TrinketType.TRINKET_KEEPERS_BARGAIN,
    TrinketType.TRINKET_SWALLOWED_M80,
    TrinketType.TRINKET_LIL_CLOT,
    TrinketType.TRINKET_MOTHERS_KISS,
    TrinketType.TRINKET_WICKED_CROWN,
    TrinketType.TRINKET_BROKEN_SYRINGE,
    TrinketType.TRINKET_NUMBER_MAGNET,
    TrinketType.TRINKET_FRIENDSHIP_NECKLACE,
    TrinketType.TRINKET_SHORT_FUSE,
    TrinketType.TRINKET_TEMPORARY_TATTOO,
    TrinketType.TRINKET_BROKEN_MAGNET,
    TrinketType.TRINKET_BLOODY_PENNY,
    TrinketType.TRINKET_ROSARY_BEAD,
    TrinketType.TRINKET_CHILDS_HEART,
    TrinketType.TRINKET_JUDAS_TONGUE,
    TrinketType.TRINKET_RED_PATCH,
    TrinketType.TRINKET_POKER_CHIP,
    TrinketType.TRINKET_SECOND_HAND,
    TrinketType.TRINKET_BLASTING_CAP,
    TrinketType.TRINKET_ERROR,
    TrinketType.TRINKET_MOMS_LOCKET,
    TrinketType.TRINKET_LOCUST_OF_WRATH,
    TrinketType.TRINKET_EQUALITY,
    TrinketType.TRINKET_BLOODY_CROWN,
    TrinketType.TRINKET_STEM_CELL

}

local beggar = mod.Entities.BEGGAR_UltraSecretElijah.Var

---@type beggarEventPool
local beggarEvents = {
    {
        1,
        function(beggarEntity)
            local trinket = utils.GetRandomFromTable(red_trinkets);
            beggarUtils.SpawnTrinket(beggarEntity, trinket)
            return false
        end
    },
    {
        10,
        ---@type beggarEventFunc
        function(beggarEntity)
            beggarUtils.SpawnItemFromPool(beggarEntity, BEGGAR_ITEM_POOL)
            return true
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
