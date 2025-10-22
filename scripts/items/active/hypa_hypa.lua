local mod = DiesIraeMod
local HypaHypa = {}

---@param player EntityPlayer
function HypaHypa:UseItem(_, _, player)
    local rng = RNG()
    rng:SetSeed(Game():GetFrameCount() + player.InitSeed, 35)

    if rng:RandomFloat() <= 0.3 then
        local itemConfig = Isaac.GetItemConfig()
        local quality4Items = {}

        for i = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
            local item = itemConfig:GetCollectible(i)
            if item and item.Quality == 4 and not item.Hidden then
                table.insert(quality4Items, i)
            end
        end

        if #quality4Items > 0 then
            local chosenIndex = rng:RandomInt(#quality4Items) + 1
            local chosenItem = quality4Items[chosenIndex]

            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, chosenItem, player.Position, Vector.Zero, nil)
        end
    else
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_POOP, player.Position, Vector.Zero, nil)
    end

    return {
        Discharge = false,
        Remove = true,
        ShowAnim = true 
    }
end

if EID then
    EID:assignTransformation("collectible", mod.Items.HypaHypa, "Isaac's sinful Playlist")
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, HypaHypa.UseItem, mod.Items.HypaHypa)

return HypaHypa
