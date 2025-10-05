local mod = DiesIraeMod

local ShBoom = {}

--THIS ITEM IS NOT IN items.xml SO I DID NOT REWORK THE CODE

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
    player:SetActiveCharge(0, ActiveSlot.SLOT_PRIMARY) -- forcibly set to 0

    return true
end

-- Reset charge on new floor
function ShBoom:OnNewLevel()
    usedThisFloor = false
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.ShBoom) then
            player:SetActiveCharge(4, ActiveSlot.SLOT_PRIMARY) -- full recharge manually
        end
    end
end

-- Stop room clears or batteries from recharging it
function ShBoom:PreventAutoRecharge(player)
    if usedThisFloor and player:HasCollectible(mod.Items.ShBoom) then
        player:SetActiveCharge(0, ActiveSlot.SLOT_PRIMARY)
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, ShBoom.UseItem, mod.Items.ShBoom)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShBoom.OnNewLevel)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, ShBoom.PreventAutoRecharge)

-- EID support
if EID then
    EID:addCollectible(mod.Items.ShBoom,
        "Triggers a full-room Mama Mega explosion#Only once per floor#Isaac gains 1 broken heart as a cost",
        "Sh-boom!!",
        "en_us"
    )
    EID:assignTransformation("collectible", mod.Items.ShBoom, "Dad's Playlist")
end
