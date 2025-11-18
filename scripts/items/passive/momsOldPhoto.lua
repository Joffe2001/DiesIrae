local mod = DiesIraeMod
local game = Game()

function mod:OldPhoto_PostPickupInit(pickup)
    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSS then return end
    if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end

    local hasTrinket = false
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(mod.Trinkets.MomsOldPhoto) then
            hasTrinket = true
            break
        end
    end
    if not hasTrinket then return end

    local pool = game:GetItemPool()
    local rng = RNG()
    rng:SetSeed(pickup.InitSeed, 35)
    local newItem = pool:GetCollectible(ItemPoolType.POOL_MOMS_CHEST, true, rng:RandomInt(999999))
    pickup:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, false, true, false)
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OldPhoto_PostPickupInit)
