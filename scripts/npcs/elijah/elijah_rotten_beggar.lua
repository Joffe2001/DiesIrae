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
local BEGGAR_ITEM_POOL = ItemPoolType.POOL_ROTTEN_BEGGAR

local BEGGAR_PICKUP = PickupVariant.PICKUP_HEART
local BEGGAR_RARE_HEART = HeartSubType.HEART_BONE
local BEGGAR_HEART = HeartSubType.HEART_ROTTEN

local BEGGAR_FAMILIAR1 = FamiliarVariant.BLUE_FLY
local BEGGAR_FAMILIAR2 = FamiliarVariant.BLUE_SPIDER

--- Definitions
---

---@type TrinketType[]
local rotten_trinkets = {
    TrinketType.TRINKET_FISH_TAIL,
    TrinketType.TRINKET_FISH_HEAD,
    TrinketType.TRINKET_BOBS_BLADDER,
    TrinketType.TRINKET_ROTTEN_PENNY
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
        4,
        function(beggarEntity)
            local trinket = utils.GetRandomFromTable(rotten_trinkets);
            beggarUtils.SpawnTrinket(beggarEntity, trinket)
            return true
        end
    },
    {
        5,
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, BEGGAR_PICKUP, BEGGAR_RARE_HEART)
            return false
        end
    },
    {
        12,
        function(beggarEntity)
            beggarUtils.SpawnPickup(beggarEntity, BEGGAR_PICKUP, BEGGAR_HEART)
            return false
        end
    },
    {
        30,
        function(beggarEntity)
            beggarUtils.SpawnFamiliar(beggarEntity, BEGGAR_FAMILIAR1)
            return false
        end
    },
    {
        30,
        function(beggarEntity)
            beggarUtils.SpawnFamiliar(beggarEntity, BEGGAR_FAMILIAR2)
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
    print("TOUCHE")
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
    for _ = 1, 2 do
        local offset = RandomVector() * 20
        Isaac.Spawn(EntityType.ENTITY_SMALL_MAGGOT, 0, 0, beggarEntity.Position + offset, Vector.Zero, nil)
    end
    beggarUtils.DoBeggarExplosion(beggarEntity)
    return false
end

mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, beggarFuncs.PreSlotExplosion, beggar)
