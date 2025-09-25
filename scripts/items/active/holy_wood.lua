local HolyWood = {}
HolyWood.COLLECTIBLE_ID = Enums.Items.HolyWood

local HOLY_MANTLE = CollectibleType.COLLECTIBLE_HOLY_MANTLE

---@param player EntityPlayer
function HolyWood:UseItem(_, _, player)
    player:AddCollectibleEffect(HOLY_MANTLE, true)

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

function HolyWood:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return HolyWood:UseItem(...)
    end, HolyWood.COLLECTIBLE_ID)

    if EID then
        EID:addCollectible(HolyWood.COLLECTIBLE_ID,
            "Grants Holy Mantle for the current room",
            "Holy Wood",
            "en_us"
        )
    end
end

return HolyWood