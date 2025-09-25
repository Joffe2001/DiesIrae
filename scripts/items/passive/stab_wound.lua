local StabWound = {}
StabWound.COLLECTIBLE_ID = Isaac.GetItemIdByName("Stab Wound")
local game = Game()

-- STAT BOOSTS
function StabWound:onCache(player, cacheFlag)
    if not player:HasCollectible(StabWound.COLLECTIBLE_ID) then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        -- +1 flat damage (additive)
        player.Damage = player.Damage + 1.0

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local currentTears = 30 / (player.MaxFireDelay + 1)
        local newTears = currentTears + 0.5 -- StabWound = +0.5 tears
        player.MaxFireDelay = math.max(1, (30 / newTears) - 1)
    end
end

-- Apply cache flags when item is picked up / removed (keeps things in sync)
function StabWound:onUpdate()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()

        if player:HasCollectible(StabWound.COLLECTIBLE_ID) then
            if not data.StabWoundCacheApplied then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY)
                player:EvaluateItems()
                data.StabWoundCacheApplied = true
            end
        else
            -- If the player no longer has the item, clear the flag and force re-eval
            if data.StabWoundCacheApplied then
                data.StabWoundCacheApplied = nil
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY)
                player:EvaluateItems()
            end
        end
    end
end

-- INIT
function StabWound:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, StabWound.onCache)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, StabWound.onUpdate)

    if EID then
        EID:addCollectible(
            StabWound.COLLECTIBLE_ID,
            "↑ +1 Damage#↑ +0.5 Tears",
            "Stab Wound",
            "en_us"
        )
    end
end

return StabWound
