local mod = DiesIraeMod

local Diary_madman = {}

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

---@param player EntityPlayer
function Diary_madman:UseItem(_, _, player)
    if active then return false end

    active = true
    statMods = {}

    for stat, _ in pairs(stats) do
        local range = statRanges[stat]
        local baseStat

        if stat == "DAMAGE" then
            baseStat = player.Damage
        elseif stat == "SPEED" then
            baseStat = player.MoveSpeed
        elseif stat == "TEAR_DELAY" then
            baseStat = player.MaxFireDelay
        elseif stat == "SHOT_SPEED" then
            baseStat = player.ShotSpeed
        elseif stat == "LUCK" then
            baseStat = player.Luck
        elseif stat == "RANGE" then
            baseStat = player.TearRange
        end

        local higher = math.random() < 0.5

        local offset = range.min + math.random() * (range.max - range.min)
        if stat == "SPEED" then
            offset = offset - 1
        end

        if higher then
            statMods[stat] = math.abs(offset)
        else
            statMods[stat] = -math.abs(offset)
        end
    end

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

---@param player EntityPlayer
---@param cacheFlag CacheFlag
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
        player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, Diary_madman.UseItem, mod.Items.DiaryOfAMadman)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Diary_madman.OnCache)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Diary_madman.OnNewRoom)

if EID then
    EID:assignTransformation("collectible", mod.Items.DiaryOfAMadman, "Isaac's sinful Playlist")
end