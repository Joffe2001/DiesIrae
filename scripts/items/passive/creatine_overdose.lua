local CreatineOverdose = {}
CreatineOverdose.COLLECTIBLE_ID = Enums.Items.CreatineOverdose

local BASE_BONUS = 0.2
local BONUS_MULT = 1.2

---@param player EntityPlayer
---@param cacheFlag CacheFlag
function CreatineOverdose:onEvaluateCache(player, cacheFlag)
    if not player:HasCollectible(CreatineOverdose.COLLECTIBLE_ID) then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + BASE_BONUS

        local effectiveBase = player:GetData().CreatineBase or 3.5 
        local current = player.Damage

        local bonus = current - effectiveBase - BASE_BONUS
        if bonus > 0 then
            player.Damage = effectiveBase + BASE_BONUS + bonus * BONUS_MULT
        end
    end
end

---@param player EntityPlayer
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
