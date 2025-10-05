local mod = DiesIraeMod

local CreatineOverdose = {}

local BASE_BONUS = 0.2
local BONUS_MULT = 1.2

function CreatineOverdose:onEvaluateCache(player, cacheFlag)
    if not player:HasCollectible(mod.Items.CreatineOverdose) then return end

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

function CreatineOverdose:onPlayerInit(player)
    player:GetData().CreatineBase = player.Damage
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CreatineOverdose.onEvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, CreatineOverdose.onPlayerInit)

if EID then
    EID:addCollectible(
        mod.Items.CreatineOverdose,
        "↑ +0.2 Damage#↑ All bonus damage is amplified by 20%.",
        "Creatine Overdose",
        "en_us"
    )
end
