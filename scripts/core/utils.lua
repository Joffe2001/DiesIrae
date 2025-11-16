--- Definitions
---

---@class Utils
local utils = {}


--- Functions
---

---Correctly apply a TearsUp to a character. From Hybrid
---@param amount number
---@param current number
---@return number
function utils.TearsUp(amount, current)
    local currentTears = 30 / (amount + 1)
    local newTears = currentTears + current
    return math.max((30 / newTears) - 1, -0.9999)
end

return utils