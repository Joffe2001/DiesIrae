local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

--- CONFIGURATION
---

---@type BeggarConfig
local beggarConfig = {
    baseChance = 0.33,
    multPerUse = 0.33,
    hasSecondary = false,
    secondaryBaseChance = 0,
    secondaryMultPerUse = 0,
    restockAffected = false
}

local BEGGAR_ITEM_POOL = ItemPoolType.POOL_NULL
local IDLE_CHANGE_CHANCE = 0.30
local MIN_IDLE_FRAMES = 150

--- Definitions
---

local beggar = mod.Entities.BEGGAR_ERROR_Elijah.Var

---@type beggarEventPool
local beggarEvents = {
    {
        1,
        ---@type beggarEventFunc
        function(beggarEntity, player)
            if player then
                player:UseActiveItem(CollectibleType.COLLECTIBLE_EVERYTHING_JAR,
                    ---@diagnostic disable-next-line: param-type-mismatch
                    UseFlag.USE_NOANIM | UseFlag.USE_CUSTOMVARDATA, -1, 12)
            end
            return false
        end
    },
    {
        2,
        ---@type beggarEventFunc
        function(beggarEntity, player)
            if player then
                player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            end
            beggarUtils.SpawnItemFromPool(beggarEntity, BEGGAR_ITEM_POOL)
            if player then
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            end
            return true
        end
    },
    {
        3,
        ---@type beggarEventFunc
        function(beggarEntity)
            beggarUtils.SpawnItemFromPool(beggarEntity, BEGGAR_ITEM_POOL)
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

    beggarEntity:AddEntityFlags(EntityFlag.FLAG_GLITCH)

    local ok = beggarUtils.OnBeggarCollision(beggarEntity, player, beggarConfig)
    if ok then
        player:PlayExtraAnimation("Glitch")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, beggarFuncs.PostSlotCollision, beggar)

---@param beggarEntity EntityNPC
function beggarFuncs:PostSlotUpdate(beggarEntity)
    local sprite = beggarEntity:GetSprite()
    local data = beggarEntity:GetData()
    
    data.IdleFrameCounter = data.IdleFrameCounter or 0
    
    local currentAnim = sprite:GetAnimation()
    local isIdle = currentAnim == "Idle" or (currentAnim:match("^Idle%d+$") ~= nil)
    
    if isIdle then
        data.IdleFrameCounter = data.IdleFrameCounter + 1
        
        if data.IdleFrameCounter >= MIN_IDLE_FRAMES then
            local rng = beggarEntity:GetDropRNG()
            if rng:RandomFloat() < IDLE_CHANGE_CHANCE then
                local idleNum = rng:RandomInt(27) + 2
                local newIdle = "Idle" .. idleNum
                
                sprite:Play(newIdle, true)
                data.IdleFrameCounter = 0
            end
        end
        
        if currentAnim ~= "Idle" and sprite:IsFinished(currentAnim) then
            sprite:Play("Idle", true)
            data.IdleFrameCounter = 0
        end
    else
        data.IdleFrameCounter = 0
    end
    beggarUtils.StateMachine(beggarEntity, beggarConfig, beggarEvents, nil)
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, beggarFuncs.PostSlotUpdate, beggar)

---@param beggarEntity EntityNPC
function beggarFuncs:PreSlotExplosion(beggarEntity)
    beggarUtils.DoBeggarExplosion(beggarEntity)
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, beggarFuncs.PreSlotExplosion, beggar)