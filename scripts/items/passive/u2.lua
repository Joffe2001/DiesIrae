local U2 = {}
U2.COLLECTIBLE_ID = Isaac.GetItemIdByName("U2")

-- Cache stat application
function U2:onCache(player, cacheFlag)
    if not player:HasCollectible(U2.COLLECTIBLE_ID) then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 0.2
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local currentTears = 30 / (player.MaxFireDelay + 1)
        local newTears = currentTears + 0.2
        player.MaxFireDelay = (30 / newTears) - 1
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + 0.2
    elseif cacheFlag == CacheFlag.CACHE_RANGE then
    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearHeight = player.TearHeight - 5   -- ≈ +1.7 range
        player.TearFallingSpeed = player.TearFallingSpeed + 0.5
    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + 0.2
    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + 0.2
    end
end

-- Apply cache flags when item is picked up
function U2:onUpdate()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(U2.COLLECTIBLE_ID) and not player:GetData().U2CacheApplied then
            player:AddCacheFlags(
                CacheFlag.CACHE_DAMAGE
                | CacheFlag.CACHE_FIREDELAY
                | CacheFlag.CACHE_SPEED
                | CacheFlag.CACHE_RANGE
                | CacheFlag.CACHE_SHOTSPEED
                | CacheFlag.CACHE_LUCK
            )
            player:EvaluateItems()
            player:GetData().U2CacheApplied = true
        end
    end
end

-- Initialization
function U2:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, U2.onCache)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, U2.onUpdate)

    if EID then
        EID:addCollectible(
            U2.COLLECTIBLE_ID,
            "↑ +0.2 Damage#↑ +0.2 Tears#↑ +0.2 Speed#↑ +0.2 Range#↑ +0.2 Shot Speed",
            "U2",
            "en_us"
        )
        EID:assignTransformation("collectible", U2.COLLECTIBLE_ID, "Dad's Playlist")
    end
end

return U2
