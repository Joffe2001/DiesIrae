local GoldenDay = {}
GoldenDay.ID = Enums.Items.GoldenDay
local game = Game()
local rng = RNG()

-- Called when player picks up the item
function GoldenDay:OnItemPickup(player, itemID, includeModifiers)
    if itemID == GoldenDay.ID then
        local choice = rng:RandomInt(3) + 1 -- 1 to 3

        if choice == 1 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN, player.Position, Vector.Zero, nil)
        elseif choice == 2 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN, player.Position, Vector.Zero, nil)
        elseif choice == 3 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN, player.Position, Vector.Zero, nil)
        end
    end
end

-- Called every new floor
function GoldenDay:OnNewLevel()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(GoldenDay.ID) then
            if rng:RandomFloat() < 0.5 then -- 50% chance
                local rooms = game:GetLevel():GetRooms()
                for i = 0, rooms.Size - 1 do
                    local roomDesc = rooms:Get(i)
                    if roomDesc and roomDesc.Data and roomDesc.Data.Type == RoomType.ROOM_SECRET then
                        local pos = roomDesc.Data.Position
                        local choice = rng:RandomInt(3) + 1

                        if choice == 1 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN, pos, Vector.Zero, nil)
                        elseif choice == 2 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN, pos, Vector.Zero, nil)
                        elseif choice == 3 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN, pos, Vector.Zero, nil)
                        end

                        break -- Only one secret room gets the pickup
                    end
                end
            end
        end
    end
end

-- Initialization
function GoldenDay:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
        if player:HasCollectible(GoldenDay.ID) and not player:GetData().GoldenDayGiven then
            player:GetData().GoldenDayGiven = true
            GoldenDay:OnItemPickup(player, GoldenDay.ID, false)
        end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, GoldenDay.OnNewLevel)

    if EID then
        EID:addCollectible(
            GoldenDay.ID,
            "Spawns a random golden pickup.#{{SecretRoom}} Each floor, has a 50% chance to spawn one of them in the Secret Room.",
            "Golden Day",
            "en_us"
        )
    end
end

return GoldenDay
