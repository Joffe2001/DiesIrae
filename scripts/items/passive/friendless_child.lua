local FriendlessChild = {}
FriendlessChild.COLLECTIBLE_ID = Enums.Items.FriendlessChild
local game = Game()

-- Stat bonuses by familiar quality
local FamiliarStatBoosts = {
    [0] = {Speed = 0.25},
    [1] = {Damage = 0.5},
    [2] = {Damage = 1.0, Tears = 0.5},
    [3] = {Damage = 1.5, Range = 1.0},
    [4] = {Damage = 2.0, Tears = 0.7},
}

-- Remove all familiars when picking up the item
function FriendlessChild:onPickup(player)
    if player:HasCollectible(FriendlessChild.COLLECTIBLE_ID) then
        for _, familiar in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
            if familiar:ToFamiliar() and familiar.Player and familiar.Player.InitSeed == player.InitSeed then
                familiar:Remove()
            end
        end
    end
end

-- Replace familiar items with stat boosts
function FriendlessChild:onPreGetCollectible(pool, decrease, seed, loopCount, currentCollectible)
    local itemConfig = Isaac.GetItemConfig():GetCollectible(currentCollectible)
    if not itemConfig then return end

    if itemConfig.Type == ItemType.ITEM_FAMILIAR then
        local player = Isaac.GetPlayer(0) -- assumes 1 player (expand for coop)
        if player:HasCollectible(FriendlessChild.COLLECTIBLE_ID) then
            local quality = itemConfig.Quality
            local boost = FamiliarStatBoosts[quality] or {}

            local data = player:GetData()
            data.FriendlessBoosts = data.FriendlessBoosts or {Damage=0, Tears=0, Speed=0, Range=0}
            for stat, value in pairs(boost) do
                data.FriendlessBoosts[stat] = data.FriendlessBoosts[stat] + value
            end

            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE)
            player:EvaluateItems()

            return CollectibleType.COLLECTIBLE_NULL -- block familiar from spawning
        end
    end
end

-- Apply stat boosts from stored data
function FriendlessChild:onCache(player, cacheFlag)
    if not player:HasCollectible(FriendlessChild.COLLECTIBLE_ID) then return end

    local data = player:GetData()
    if not data.FriendlessBoosts then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + data.FriendlessBoosts.Damage
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = math.max(1, player.MaxFireDelay - data.FriendlessBoosts.Tears)
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + data.FriendlessBoosts.Speed
    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange + data.FriendlessBoosts.Range * 40 -- convert to range units
    end
end

function FriendlessChild:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player) FriendlessChild:onPickup(player) end)
    mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, FriendlessChild.onPreGetCollectible)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, FriendlessChild.onCache)
end

return FriendlessChild
