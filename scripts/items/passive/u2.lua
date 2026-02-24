local mod = DiesIraeMod
local U2 = {}

mod.CollectibleType.COLLECTIBLE_U2 = Isaac.GetItemIdByName("U2")

function U2:onCache(player, cacheFlag)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_U2) then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 0.2

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local currentTears = 30 / (player.MaxFireDelay + 1)
        local newTears = currentTears + 0.2
        player.MaxFireDelay = math.max(1, (30 / newTears) - 1)

    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + 0.2

    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange + (0.2 * 40)

    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + 0.2

    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + 0.2
    end
end


function U2:onUpdate()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_U2)
        and not player:GetData().U2CacheApplied then

            player:AddCacheFlags(
                ---@diagnostic disable-next-line: param-type-mismatch
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

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, U2.onCache)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, U2.onUpdate)

if EID then
    EID:assignTransformation("collectible", mod.CollectibleType.COLLECTIBLE_U2, "Dad's Playlist")
end
