local MomsOldPhoto = {}
MomsOldPhoto.COLLECTIBLE_ID = Enums.Items.momsOldPhoto
local momItemsPool = {
    CollectibleType.COLLECTIBLE_MOMS_EYESHADOW,
    CollectibleType.COLLECTIBLE_MOMS_KNIFE,
    CollectibleType.COLLECTIBLE_MOMS_EYE,
    CollectibleType.COLLECTIBLE_MOMS_CONTACTS,
    CollectibleType.COLLECTIBLE_MOMS_BRA,
    CollectibleType.COLLECTIBLE_MOMS_PAD,
    CollectibleType.COLLECTIBLE_MOMS_HEELS,
    CollectibleType.COLLECTIBLE_MOMS_LIPSTICK,
    CollectibleType.COLLECTIBLE_MOMS_PURSE,
    CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR,
    CollectibleType.COLLECTIBLE_MOMS_RING,
    CollectibleType.COLLECTIBLE_MOMS_BOX,
    Enums.Items.MomsDiary,
    Enums.Items.MomsDress
}

function MomsOldPhoto:OnItemPickup(player, itemID)
    if itemID == MomsOldPhoto then
        player:GetData().momOldPhoto = true
    end
end

function MomsOldPhoto:PostPickupInit(pickup)
    if not pickup then return end
    local player = Isaac.GetPlayer(0)
    if player:GetData().momOldPhoto then
        if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and Game():GetRoom():GetType() == RoomType.ROOM_BOSS then
            pickup:Remove()
            local item = momItemsPool[math.random(#momItemsPool)] 
            local pedestal = Isaac.Spawn(PickupVariant.PICKUP_COLLECTIBLE, 0, item, player.Position, Vector(0, 0), nil)
            pedestal:ToPickup().AutoPickup = false
        end
    end
end
function MomsOldPhoto:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
        MomsOldPhoto:CreateMomsOldPhoto() 
    end)

    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, player, itemID)
        MomsOldPhoto:OnItemPickup(player, itemID)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
        MomsOldPhoto:PostPickupInit(pickup)
    end)
end

return MomsOldPhoto
