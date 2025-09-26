local ComaWhite = {}
ComaWhite.COLLECTIBLE_ID = Enums.Items.ComaWhite

local blockBossReward = false

---@param player EntityPlayer
function ComaWhite:UseItem(_, _, player)
    player:AddEternalHearts(1)
    blockBossReward = true
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

---@param pickup EntityPickup
function ComaWhite:PostPickupInit(pickup)
    if blockBossReward
    and GameRef:GetRoom():GetType() == RoomType.ROOM_BOSS
    and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        pickup:Remove()
        blockBossReward = false
    end
end

function ComaWhite:OnNewLevel()
    blockBossReward = false
end

function ComaWhite:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return ComaWhite:UseItem(...)
    end, ComaWhite.COLLECTIBLE_ID)

    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
        ComaWhite:PostPickupInit(pickup)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
        ComaWhite:OnNewLevel()
    end)

    if EID then
        EID:addCollectible(ComaWhite.COLLECTIBLE_ID,
            "Grants 1 Eternal Heart#Removes boss item reward this floor",
            "Coma White",
            "en_us"
        )
    end
end

return ComaWhite