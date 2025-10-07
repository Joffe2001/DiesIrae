local SecondBreakfast = {}
SecondBreakfast.TRINKET_ID = Enums.Trinkets.SecondBreakfast

local foodItems = {
    CollectibleType.COLLECTIBLE_MEAT,
    CollectibleType.COLLECTIBLE_LUNCH,
    CollectibleType.COLLECTIBLE_SUPPER,
    CollectibleType.COLLECTIBLE_DESSERT,
    CollectibleType.COLLECTIBLE_ROTTEN_MEAT,
    CollectibleType.COLLECTIBLE_SAUSAGE,
    Enums.Items.BigKahunaBurger
}

SecondBreakfast.usedThisFloor = {}

function SecondBreakfast:onCollectibleAdded(_, Type, Charge, FirstTime, Slot, VarData, player)
    if not player:HasTrinket(SecondBreakfast.TRINKET_ID) then return end
    local id = player:GetPlayerIndex()

    if SecondBreakfast.usedThisFloor[id] then return end

    for _, foodID in ipairs(foodItems) do
        if Type == foodID then
            SecondBreakfast.usedThisFloor[id] = true

            local randomFood = foodItems[math.random(#foodItems)]
            local room = Game():GetRoom()
            local spawnPos = room:FindFreePickupSpawnPosition(player.Position, 0, true)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, randomFood, spawnPos, Vector.Zero, nil)
            break
        end
    end
end

function SecondBreakfast:onNewLevel()
    SecondBreakfast.usedThisFloor = {}
end

function SecondBreakfast:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(mod, Type, Charge, FirstTime, Slot, VarData, player)
        SecondBreakfast:onCollectibleAdded(mod, Type, Charge, FirstTime, Slot, VarData, player)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
        SecondBreakfast:onNewLevel()
    end)

    if EID then
        EID:addTrinket(
            SecondBreakfast.TRINKET_ID,
            "Once per floor: picking up a food item spawns a random extra food item.",
            "Second Breakfast",
            "en_us"
        )
    end
end

return SecondBreakfast
