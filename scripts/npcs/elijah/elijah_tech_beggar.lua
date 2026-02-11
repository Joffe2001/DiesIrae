local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

---@class Utils
local utils = include("scripts.core.utils")

--- CONFIGURATION
---

local TECHX_DURATION = 1800 

---@type BeggarConfig
local beggarConfig = {
    baseChance = 0.05,
    multPerUse = 0.02,
    hasSecondary = false,
    secondaryBaseChance = 0,
    secondaryMultPerUse = 0,
    restockAffected = false
}

--- Definitions
---

local beggar = mod.Entities.BEGGAR_TechElijah.Var

--- Helper Functions
---

function mod:GiveTemporaryTechXElijah(player)
    if not player or not player:ToPlayer() then return end
    local data = player:GetData()

    if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
        return
    end

    sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)

    player:AddCollectible(CollectibleType.COLLECTIBLE_TECH_X, 0, false)
    player:EvaluateItems()

    data.TechX_Timer_Elijah = TECHX_DURATION
    data.TechX_Temporary_Elijah = true

    print("[Elijah Tech Beggar] Gave temporary Tech X.")
end

function mod:TechXTimerUpdateElijah(player)
    local data = player:GetData()

    if not data.TechX_Timer_Elijah then return end

    data.TechX_Timer_Elijah = data.TechX_Timer_Elijah - 1
    if data.TechX_Timer_Elijah <= 0 then
        data.TechX_Timer_Elijah = nil

        if data.TechX_Temporary_Elijah then
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_TECH_X)
            player:EvaluateItems()
            data.TechX_Temporary_Elijah = nil

            print("[Elijah Tech Beggar] Temporary Tech X expired.")
        end
    end
end

-- Only update for Elijah
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    if player:GetPlayerType() == mod.Players.Elijah then
        mod:TechXTimerUpdateElijah(player)
    end
end)

---@type beggarEventPool
local beggarPrimaryEvents = {
    {
        25,
        function(beggarEntity, player)
            mod:GiveTemporaryTechXElijah(player)
            return false
        end
    },
    {
        75,
        function(beggarEntity, player)
            local item = utils.GetRandomFromTable(mod.Pools.Tech)
            beggarUtils.SpawnItem(beggarEntity, item)
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
    
    local ok = beggarUtils.OnBeggarCollision(beggarEntity, player, beggarConfig)
    if ok then
        player:PlayExtraAnimation("Sad")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, beggarFuncs.PostSlotCollision, beggar)

---@param beggarEntity EntityNPC
function beggarFuncs:PostSlotUpdate(beggarEntity)
    beggarUtils.StateMachine(beggarEntity, beggarConfig, beggarPrimaryEvents, nil)
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