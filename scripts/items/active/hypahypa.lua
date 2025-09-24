local HypaHypa = {}
HypaHypa.COLLECTIBLE_ID = Isaac.GetItemIdByName("Hypa Hypa")
local game = Game()

function HypaHypa:UseItem(_, _, player)
    local rng = RNG()
    rng:SetSeed(Random(), 1)

    local chance = rng:RandomFloat() -- 0.0 - 1.0

    if chance <= 0.10 then
        -- 10% chance: spawn random quality 4 collectible
        local itemConfig = Isaac.GetItemConfig()
        local quality4Items = {}

        for i = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
            local item = itemConfig:GetCollectible(i)
            if item and item.Quality == 4 and not item.Hidden then
                table.insert(quality4Items, i)
            end
        end

        if #quality4Items > 0 then
            local chosen = quality4Items[rng:RandomInt(#quality4Items) + 1]
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, chosen, player.Position, Vector.Zero, nil)
        end
    else
        -- 90% chance: spawn "The Poop" collectible
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_POOP, player.Position, Vector.Zero, nil)
    end

    -- Single-use: remove Hypa Hypa from inventory
    player:RemoveCollectible(HypaHypa.COLLECTIBLE_ID)

    return true
end

function HypaHypa:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return HypaHypa:UseItem(...)
    end, HypaHypa.COLLECTIBLE_ID)

    if EID then
        EID:addCollectible(HypaHypa.COLLECTIBLE_ID,
            "10% chance to spawn a quality 4 item #90% chance to spawn The Poop #Single-use item",
            "Hypa Hypa",
            "en_us"
        )
    end
end

return HypaHypa
