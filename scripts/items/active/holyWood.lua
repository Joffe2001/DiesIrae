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
    EID:assignTransformation("collectible", mod.Items.HolyWood, "Isaac's sinful Playlist")
end