local ShBoom = {}
ShBoom.COLLECTIBLE_ID = Isaac.GetItemIdByName("Sh-boom!!")
local game = Game()
local sfx = SFXManager()

local usedThisFloor = false

-- Use Item
function ShBoom:UseItem(_, _, player)
    if usedThisFloor then
        return false -- silently block reuse
    end

    -- Full Mama Mega explosion
    game:GetRoom():MamaMegaExplosion(player.Position, player)
    game:ShakeScreen(30)
    sfx:Play(134)

    -- Player receives 1 broken heart as cost
    player:AddBrokenHearts(1)

    -- Open secret doors
    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = game:GetRoom():GetDoor(i)
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
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(ShBoom.COLLECTIBLE_ID) then
            player:SetActiveCharge(4, ActiveSlot.SLOT_PRIMARY) -- full recharge manually
        end
    end
end

-- Stop room clears or batteries from recharging it
function ShBoom:PreventAutoRecharge(player)
    if usedThisFloor and player:HasCollectible(ShBoom.COLLECTIBLE_ID) then
        player:SetActiveCharge(0, ActiveSlot.SLOT_PRIMARY)
    end
end

function ShBoom:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return ShBoom:UseItem(...)
    end, ShBoom.COLLECTIBLE_ID)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
        ShBoom:OnNewLevel()
    end)

    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
        ShBoom:PreventAutoRecharge(player)
    end)

    -- EID support
    if EID then
        EID:addCollectible(ShBoom.COLLECTIBLE_ID,
            "Triggers a full-room Mama Mega explosion#Only once per floor#Isaac gains 1 broken heart as a cost",
            "Sh-boom!!",
            "en_us"
        )
        EID:assignTransformation("collectible", ShBoom.COLLECTIBLE_ID, "Dad's Playlist")
    end
end

return ShBoom
