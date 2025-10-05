local mod = DiesIraeMod

local ArmyOfLovers = {}

---@param player EntityPlayer
function ArmyOfLovers:UseItem(_, _, player)
    for i = 1, 2 do
        player:AddMinisaac(player.Position)
    end
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, ArmyOfLovers.UseItem, mod.Items.ArmyOfLovers)

--Needs to add: Wisps