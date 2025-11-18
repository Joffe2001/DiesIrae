local mod = DiesIraeMod

local EnjoymentUnlucky = {}

local baseStat = {}


-- Recalculate buffs based on current negative luck
function EnjoymentUnlucky:RecalculateStats(player)
    if not player:HasCollectible(mod.Items.EnjoymentOfTheUnlucky) then
        baseStat[player.ControllerIndex] = nil
        return
    end

    local luck = player.Luck or 0
    local scale = math.max(0, -luck) -- only apply when negative

    baseStat[player.ControllerIndex] = {
        damage    = scale * 0.4,
        firedelay = scale * 0.7,
        speed     = scale * 0.1,
        range     = scale * 0.2,
        shotspeed = scale * 0.05
    }
end

function EnjoymentUnlucky:EvaluateCache(player, cacheFlag)
    EnjoymentUnlucky:RecalculateStats(player)

    local boost = baseStat[player.ControllerIndex]
    if not boost then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + boost.damage
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = math.max(0, player.MaxFireDelay - boost.firedelay)
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + boost.speed
    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearHeight = player.TearHeight - boost.range
    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + boost.shotspeed
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EnjoymentUnlucky.EvaluateCache)

