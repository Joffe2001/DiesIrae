--- Definitions
---

---@class Utils
local utils = {}


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
---@alias weight_table table<table<integer, T>>
---@param table weight_table
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

return utils
