local mod = DiesIraeMod

mod.CollectibleType.COLLECTIBLE_GOLDEN_DAY = Isaac.GetItemIdByName("Golden Day")

local GoldenDay = {}
local game = Game()
local rng = RNG()

-- Called when player picks up the item
function GoldenDay:OnItemPickup(player, itemID, includeModifiers)
    if itemID == mod.CollectibleType.COLLECTIBLE_GOLDEN_DAY then
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

function GoldenDay:OnNewLevel()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_GOLDEN_DAY) then
            if rng:RandomFloat() < 0.5 then
                local rooms = game:GetLevel():GetRooms()
                for i = 0, rooms.Size - 1 do
                    local roomDesc = rooms:Get(i)
                    if roomDesc and roomDesc.Data and roomDesc.Data.Type == RoomType.ROOM_SECRET then
                        local pos = roomDesc.Data.Position -- are we sure about that ?
                        local choice = rng:RandomInt(3) + 1

                        if choice == 1 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN, pos, Vector.Zero, nil)
                        elseif choice == 2 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN, pos, Vector.Zero, nil)
                        elseif choice == 3 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN, pos, Vector.Zero, nil)
                        end

                        break
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_GOLDEN_DAY) and not player:GetData().GoldenDayGiven then
        player:GetData().GoldenDayGiven = true
        GoldenDay:OnItemPickup(player, mod.CollectibleType.COLLECTIBLE_GOLDEN_DAY, false)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, GoldenDay.OnNewLevel)
