local mod = DiesIraeMod
local HypaHypa = {}

---@param player EntityPlayer
function HypaHypa:UseItem(_, _, player)
    local rng = RNG()
    rng:SetSeed(Game():GetFrameCount() + player.InitSeed, 35)

    if rng:RandomFloat() <= 0.3 then
        local itemConfig = Isaac.GetItemConfig()
        local collectibles = itemConfig:GetCollectibles()

        local quality4Items = {}

        for id = 1, collectibles.Size - 1 do
            local item = itemConfig:GetCollectible(id)

            if item
                and item.Quality == 4
                and not item.Hidden
                and not item:HasTags(ItemConfig.TAG_QUEST)
                and item:IsAvailable()
            then
                table.insert(quality4Items, id)
            end
        end

        if #quality4Items > 0 then
            local chosenItem = quality4Items[rng:RandomInt(#quality4Items) + 1]

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                chosenItem,
                player.Position,
                Vector.Zero,
                nil
            )
        end
    else
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            CollectibleType.COLLECTIBLE_POOP,
            player.Position,
            Vector.Zero,
            nil
        )
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
