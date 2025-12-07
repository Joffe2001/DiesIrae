--- Definitions
---

---@class Utils
local utils = {}

local mod = DiesIraeMod
local obj_data = {}


--- Functions
---

---Correctly apply a TearsUp to a character. From Hybrid
---@param current number
---@param amount number
---@return number
function utils.TearsUp(current, amount)
    local currentTears = 30 / (current + 1)
    local newTears = currentTears + amount
    return math.max((30 / newTears) - 1, -0.9999)
end

---Choose a random element from a weighted table
---@generic T
---@alias weightedEntry { [1]: number, [2]: T }
---@alias weightedTable weightedEntry[]
---@param table weightedTable<T>
---@param rng RNG
---@return T
function utils.WeightedRandom(table, rng)
    local size = 0
    for _, pair in ipairs(table) do
        size = size + pair[1]
    end

    local select = rng:RandomInt(size) + 1
    for _, pair in ipairs(table) do
        select = select - pair[1]
        if (select <= 0) then return pair[2] end
    end

    return nil
end

---Checks if the objects are equal or not
---@param obj1 any
---@param obj2 any
---@return boolean
function utils:IsEqual(obj1, obj2)
    if type(obj1) ~= type(obj2) then return false end

    if type(obj1) == "userdata" then
        return GetPtrHash(obj1) == GetPtrHash(obj2)
            or tostring(obj1) == tostring(obj2)
    else
        return obj1 == obj2
    end
end

---Returns a random element from a table.\
---You can give Isaac RNG or just nil if you are lazy.
---@generic T
---@param table T[]
---@param rng RNG | nil
---@return T
function utils.GetRandomFromTable(table, rng)
    local idx = -1
    if rng then
        idx = rng:RandomInt(#table) + 1
    else
        idx = math.random(#table)
    end
    return table[idx]
end


---@param player EntityPlayer
function utils.HasBirthright(player)
    return player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
end


---@param soundId integer
---@param flags integer
function utils.PlayVoiceline(soundId, flags, player)
    if flags & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then
        return
    end

    local rng = player:GetCollectibleRNG(1)
    local randNum = rng:RandomInt(2)

    -- AnnouncerVoiceMode:
    -- 0 = random
    -- 1 = off
    -- 2 = always on
    if Options.AnnouncerVoiceMode == 2
        or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
    then
        sfx:Play(soundId)
    end
end


---@param id number
function utils.IsGoldTrinket(id)
    return id & TrinketType.TRINKET_GOLDEN_FLAG ~= 0
end

return utils
