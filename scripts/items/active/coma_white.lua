local mod = DiesIraeMod

local ComaWhite = {}

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
    and Game():GetRoom():GetType() == RoomType.ROOM_BOSS
    and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        pickup:Remove()
        blockBossReward = false
    end
end

function ComaWhite:OnNewLevel()
    blockBossReward = false
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, ComaWhite.UseItem, mod.Items.ComaWhite)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ComaWhite.PostPickupInit)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ComaWhite.OnNewLevel)

if EID then
    EID:addCollectible(mod.Items.ComaWhite,
        "Grants 1 Eternal Heart#Removes boss item reward this floor",
        "Coma White",
        "en_us"
    )
end