local CreatineOverdose = {}
CreatineOverdose.COLLECTIBLE_ID = Isaac.GetItemIdByName("Creatine Overdose")

local BASE_BONUS = 0.2
local BONUS_MULT = 1.2

function CreatineOverdose:onEvaluateCache(player, cacheFlag)
    if not player:HasCollectible(CreatineOverdose.COLLECTIBLE_ID) then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        -- Step 1: Add the flat +0.2 like U2
        player.Damage = player.Damage + BASE_BONUS

        -- Step 2: Scale ONLY the "extra" damage (anything above the base +0.2)
        local effectiveBase = player:GetData().CreatineBase or 3.5 -- assume Isaac’s base if nothing set
        local current = player.Damage

        local bonus = current - effectiveBase - BASE_BONUS
        if bonus > 0 then
            player.Damage = effectiveBase + BASE_BONUS + bonus * BONUS_MULT
        end
    end
end

-- Track each character’s true base damage so scaling is correct
function CreatineOverdose:onPlayerInit(player)
    player:GetData().CreatineBase = player.Damage
end

function CreatineOverdose:Init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CreatineOverdose.onEvaluateCache)
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, CreatineOverdose.onPlayerInit)

    if EID then
        EID:addCollectible(
            CreatineOverdose.COLLECTIBLE_ID,
            "↑ +0.2 Damage#↑ All bonus damage is amplified by 20%.",
            "Creatine Overdose",
            "en_us"
        )
    end
end

return CreatineOverdose
