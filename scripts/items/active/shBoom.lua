local mod = DiesIraeMod
local ShBoom = {}

local usedThisFloor = false

---@param player EntityPlayer
function ShBoom:UseItem(_, _, player)
    if usedThisFloor then
        return {
            Discharge = false,
            Remove = false,
            ShowAnim = false
        }
    end

    Game():GetRoom():MamaMegaExplosion(player.Position)
    Game():ShakeScreen(30)
    SFXManager():Play(134)

    player:AddBrokenHearts(1)

    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = Game():GetRoom():GetDoor(i)
        if door and (door.TargetRoomType == RoomType.ROOM_SECRET or door.TargetRoomType == RoomType.ROOM_SUPERSECRET) then
            door:Open()
        end
    end

    usedThisFloor = true
    player:SetActiveCharge(0, ActiveSlot.SLOT_PRIMARY) 

    return true
end

function ShBoom:OnNewLevel()
    usedThisFloor = false
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.ShBoom) then
            player:SetActiveCharge(4, ActiveSlot.SLOT_PRIMARY)
        end
    end
end

function ShBoom:PreventAutoRecharge(player)
    if usedThisFloor and player:HasCollectible(mod.Items.ShBoom) then
        player:SetActiveCharge(0, ActiveSlot.SLOT_PRIMARY)
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, ShBoom.UseItem, mod.Items.ShBoom)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShBoom.OnNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, ShBoom.PreventAutoRecharge)
