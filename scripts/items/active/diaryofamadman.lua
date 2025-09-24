local Diary_madman = {}
Diary_madman.COLLECTIBLE_ID = Isaac.GetItemIdByName("Diary of a Madman")

local active = false
local statMods = {}

local stats = {
    DAMAGE = "Damage",
    SPEED = "MoveSpeed",
    TEAR_DELAY = "MaxFireDelay",
    SHOT_SPEED = "ShotSpeed",
    LUCK = "Luck",
    RANGE = "TearRange",
}

local statRanges = {
    DAMAGE = {min = -1.2, max = 10},
    SPEED = {min = 0.5, max = 2},
    TEAR_DELAY = {min = -1, max = 7},
    SHOT_SPEED = {min = -1, max = 3},
    LUCK = {min = -10, max = 10},
    RANGE = {min = -1, max = 3},
}

function Diary_madman:UseItem(_, _, player)
    if active then return false end

    active = true
    statMods = {}

    for stat, _ in pairs(stats) do
        local range = statRanges[stat]
        local val = range.min + math.random() * (range.max - range.min)

        if stat == "SPEED" then
            val = val - 1
        end

        statMods[stat] = val
    end

    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE + CacheFlag.CACHE_SPEED + CacheFlag.CACHE_FIREDELAY + CacheFlag.CACHE_SHOTSPEED + CacheFlag.CACHE_LUCK + CacheFlag.CACHE_RANGE)
    player:EvaluateItems()

    return true
end

function Diary_madman:OnCache(player, cacheFlag)
    if not active then return end

    if (cacheFlag & CacheFlag.CACHE_DAMAGE) > 0 and statMods.DAMAGE then
        player.Damage = player.Damage + statMods.DAMAGE
    end

    if (cacheFlag & CacheFlag.CACHE_SPEED) > 0 and statMods.SPEED then
        player.MoveSpeed = player.MoveSpeed + statMods.SPEED
    end

    if (cacheFlag & CacheFlag.CACHE_FIREDELAY) > 0 and statMods.TEAR_DELAY then
        player.MaxFireDelay = math.max(1, player.MaxFireDelay - statMods.TEAR_DELAY)
    end

    if (cacheFlag & CacheFlag.CACHE_SHOTSPEED) > 0 and statMods.SHOT_SPEED then
        player.ShotSpeed = player.ShotSpeed + statMods.SHOT_SPEED
    end

    if (cacheFlag & CacheFlag.CACHE_LUCK) > 0 and statMods.LUCK then
        player.Luck = player.Luck + statMods.LUCK
    end

    if (cacheFlag & CacheFlag.CACHE_RANGE) > 0 and statMods.RANGE then
        player.TearRange = player.TearRange + statMods.RANGE
    end
end

function Diary_madman:OnNewRoom()
    if active then
        local player = Isaac.GetPlayer(0)
        active = false
        statMods = {}
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE + CacheFlag.CACHE_SPEED + CacheFlag.CACHE_FIREDELAY + CacheFlag.CACHE_SHOTSPEED + CacheFlag.CACHE_LUCK + CacheFlag.CACHE_RANGE)
        player:EvaluateItems()
    end
end

function Diary_madman:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return Diary_madman:UseItem(...)
    end, Diary_madman.COLLECTIBLE_ID)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
        Diary_madman:OnCache(player, cacheFlag)
    end)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        Diary_madman:OnNewRoom()
    end)

    if EID then
        EID:addCollectible(Diary_madman.COLLECTIBLE_ID,
            "Randomly changes all stats for the current room",
            "Diary of a Madman",
            "en_us"
        )
    end
end

return Diary_madman
