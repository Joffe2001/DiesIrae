local CustomTransform = {}
local game = Game()

-- Transformation identifiers
CustomTransform.TRANSFORM_DAD_PLAYLIST = "Dad's Old Playlist"
CustomTransform.TRANSFORM_SINFUL_MUSIC = "Isaac's Sinful Music"

-- Track whether each transformation has been triggered
CustomTransform.transformed = {
    [CustomTransform.TRANSFORM_DAD_PLAYLIST] = false,
    [CustomTransform.TRANSFORM_SINFUL_MUSIC] = false
}

-- Items in each transformation
CustomTransform.DAD_PLAYLIST_ITEMS = {
    [Isaac.GetItemIdByName("Army of Lovers")] = true,
    [Isaac.GetItemIdByName("The Bad Touch")] = true,
    [Isaac.GetItemIdByName("Sh-boom!!")] = true,
    [Isaac.GetItemIdByName("U2")] = true,
    [Isaac.GetItemIdByName("Helter Skelter")] = true,
    [CollectibleType.COL_VENUS] = true
}

CustomTransform.SINFUL_MUSIC_ITEMS = {
    [Isaac.GetItemIdByName("Hypa Hypa")] = true,
    [Isaac.GetItemIdByName("Holy Wood")] = true,
    [Isaac.GetItemIdByName("Coma White")] = true,
    [Isaac.GetItemIdByName("Diary of a Madman")] = true
}

-- Helper: Count how many items from a set the player has
function CustomTransform:CountTransformationItems(player, itemTable)
    local count = 0
    for itemID, _ in pairs(itemTable) do
        if player:HasCollectible(itemID) then
            count = count + 1
        end
    end
    return count
end

-- Transformation logic
function CustomTransform:onPlayerUpdate(player)
    -- DAD'S PLAYLIST TRANSFORMATION
    if not self.transformed[self.TRANSFORM_DAD_PLAYLIST] then
        local count = self:CountTransformationItems(player, self.DAD_PLAYLIST_ITEMS)
        if count >= 3 then
            self.transformed[self.TRANSFORM_DAD_PLAYLIST] = true
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_LUCK)
            player:EvaluateItems()

            Game():GetHUD():ShowItemText("Transformation!", self.TRANSFORM_DAD_PLAYLIST)
            SFXManager():Play(97)
        end
    end

    -- SINFUL MUSIC TRANSFORMATION
    if not self.transformed[self.TRANSFORM_SINFUL_MUSIC] then
        local count = self:CountTransformationItems(player, self.SINFUL_MUSIC_ITEMS)
        if count >= 3 then
            self.transformed[self.TRANSFORM_SINFUL_MUSIC] = true
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FLYING)
            player:EvaluateItems()

            Game():GetHUD():ShowItemText("Transformation!", self.TRANSFORM_SINFUL_MUSIC)
            SFXManager():Play(150)
        end
    end
end

local azazelWings = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT).Costume

-- Apply stat changes
function CustomTransform:onCache(player, cacheFlag)
    if self.transformed[self.TRANSFORM_DAD_PLAYLIST] then
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            local tears = 30 / (player.MaxFireDelay + 1)
            tears = tears + 2
            player.MaxFireDelay = (30 / tears) - 1
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + 1
        end
    end

    if self.transformed[self.TRANSFORM_SINFUL_MUSIC] then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + 2
        elseif cacheFlag == CacheFlag.CACHE_FLYING then
            player.CanFly = true
            if azazelWings then
                player:AddNullCostume(azazelWings)
            end
        end
    end
end

function CustomTransform:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
        self:onPlayerUpdate(player)
    end)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
        self:onCache(player, flag)
    end)
end

return CustomTransform
