local ArmyOfLovers = {}
ArmyOfLovers.COLLECTIBLE_ID = Enums.Items.ArmyOfLovers

---@param player EntityPlayer
function ArmyOfLovers:UseItem(_, _, player, _, _)
    for i = 1, 2 do
        player:AddMinisaac(player.Position)
    end
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

function ArmyOfLovers:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return ArmyOfLovers:UseItem(...)
    end, ArmyOfLovers.COLLECTIBLE_ID)

    -- EID description
    if EID then
        EID:addCollectible(ArmyOfLovers.COLLECTIBLE_ID, "Spawns 2 Mini Isaacs", "Army of Lovers", "en_us")
        EID:assignTransformation("collectible", ArmyOfLovers.COLLECTIBLE_ID, "Dad's Playlist")
    end
end



return ArmyOfLovers
--Needs to add: Wisps