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

return utils