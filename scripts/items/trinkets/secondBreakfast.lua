local mod = DiesIraeMod
local SecondBreakfast = {}
local game = Game()


SecondBreakfast.FOOD_POOL = {
    CollectibleType.COLLECTIBLE_MEAT,
    CollectibleType.COLLECTIBLE_LUNCH,
    CollectibleType.COLLECTIBLE_SUPPER,
    CollectibleType.COLLECTIBLE_DESSERT,
    CollectibleType.COLLECTIBLE_ROTTEN_MEAT,
    CollectibleType.COLLECTIBLE_SAUSAGE,
    mod.Items.ProteinPowder,
    mod.Items.CreatineOverdose,
    mod.Items.KoRn,
    mod.Items.BigKahunaBurger
}

local triggeredItems = {}

function SecondBreakfast:onUpdate(player)
    local id = player.InitSeed
    triggeredItems[id] = triggeredItems[id] or {}

    local trinketMult = player:GetTrinketMultiplier(mod.Trinkets.SecondBreakfast)
    if trinketMult <= 0 then return end

    for _, itemID in ipairs(SecondBreakfast.FOOD_POOL) do
        if player:GetCollectibleNum(itemID) > 0 then
            if not triggeredItems[id][itemID] then
                triggeredItems[id][itemID] = true

                local pos = player.Position + Vector(math.random(-40,40), math.random(-40,40))
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BREAKFAST, pos, Vector.Zero, nil)
            end
        end
    end
end

function SecondBreakfast:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, SecondBreakfast.onUpdate)
end

return SecondBreakfast
