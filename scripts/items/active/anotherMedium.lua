local mod = DiesIraeMod

local AnotherMedium = {}

local itemConfig = Isaac.GetItemConfig()
local MAX_ITEM_ID = 10000
local usedThisFloor = false

---@param id CollectibleType
---@return boolean
local function IsValidCandidate(id)
    local cfg = itemConfig:GetCollectible(id)
    return cfg
        and cfg:IsAvailable()
        and not cfg:HasTags(ItemConfig.TAG_QUEST)
        and (cfg.Type == ItemType.ITEM_PASSIVE or cfg.Type == ItemType.ITEM_FAMILIAR)
        and id ~= AnotherMedium.COLLECTIBLE_ID
end

function AnotherMedium:OnNewLevel()
    usedThisFloor = false
end

---@param rng RNG
---@param player EntityPlayer
function AnotherMedium:OnUse(_, rng, player)
    if usedThisFloor then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end

    local candidates = {}

    -- Find owned passives or familiars
    for id = 1, MAX_ITEM_ID do
        if player:HasCollectible(id) and IsValidCandidate(id) then
            table.insert(candidates, id)
        end
    end

    if #candidates > 0 then
        local toRemove = candidates[rng:RandomInt(#candidates) + 1]
        player:RemoveCollectible(toRemove)

        local newID
        local tries = 0
        repeat
            newID = rng:RandomInt(MAX_ITEM_ID) + 1
            tries = tries + 1
        until IsValidCandidate(newID) or tries > 100

        if newID then
            player:AddCollectible(newID)
        end

        player:EvaluateItems()
        player:AnimateCollectible(AnotherMedium.COLLECTIBLE_ID)
        Game():ShakeScreen(5)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
        SFXManager():Play(SoundEffect.SOUND_EDEN_GLITCH)

        usedThisFloor = true
        player:SetActiveCharge(0) 
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, AnotherMedium.OnUse, mod.Items.AnotherMedium)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, AnotherMedium.OnNewLevel)
