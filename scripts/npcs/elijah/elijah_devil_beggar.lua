local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

--- MAGIC NUMBERS
---

local BASE_REWARD_CHANCES = 1
local BEGGAR_ITEM_POOL = ItemPoolType.POOL_DEVIL

local MARK_DECORATION_DURATION = 3

--- Definitions
---

local beggar = mod.Entities.BEGGAR_DevilElijah.Var

---@type beggarEventPool
local beggarEvents = {
    {
        1,
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
        player:AddBrimstoneMark(EntityRef(beggarEntity), MARK_DECORATION_DURATION * 30)
        player:AddBrokenHearts(1);
        player:BloodExplode();
        player:PlayExtraAnimation("Hit")
        local pdata = player:GetData()
        pdata.UsedDevilBeggar = true
        
        local level = Game():GetLevel()
        level:SetAngelRoomChance(0.0)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, beggarFuncs.PostSlotCollision, beggar)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local player = Isaac.GetPlayer(0)
    if not player then return end
    
    local pdata = player:GetData()
    if pdata.UsedDevilBeggar then
        local level = game:GetLevel()
        level:SetAngelRoomChance(0.0)
    end
end)

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