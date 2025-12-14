---@class ModReference
local mod = DiesIraeMod
local game = Game()

local openingGift = false
local hasGiftThisFloor = false
local lastStageKey = nil

local function GetStageKey()
    local level = game:GetLevel()
    return tostring(level:GetStage()) .. "-" .. tostring(level:GetStageType())
end
function mod:RewrappingPaper_OnUse(_, _, player)
    if player:HasCollectible(mod.Items.RewrappingPaper) then
        openingGift = true
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.RewrappingPaper_OnUse, CollectibleType.COLLECTIBLE_MYSTERY_GIFT)

function mod:RewrappingPaper_PreGetCollectible(pool, decrease, seed)
    local stageKey = GetStageKey()

    if stageKey ~= lastStageKey then
        hasGiftThisFloor = false
        lastStageKey = stageKey
    end
    if openingGift then
        openingGift = false
        return nil
    end
    for p = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        if player:HasCollectible(mod.Items.RewrappingPaper) then

            if pool == ItemPoolType.POOL_TREASURE and not hasGiftThisFloor then
                hasGiftThisFloor = true
                return CollectibleType.COLLECTIBLE_MYSTERY_GIFT
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, mod.RewrappingPaper_PreGetCollectible)
