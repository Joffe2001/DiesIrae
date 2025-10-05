local mod = DiesIraeMod

local HolyWood = {}

---@param player EntityPlayer
function HolyWood:UseItem(_, _, player)
    player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true)

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, HolyWood.UseItem, mod.Items.HolyWood)

if EID then
    EID:addCollectible(mod.Items.HolyWood,
        "Grants Holy Mantle for the current room",
        "Holy Wood",
        "en_us"
    )
end