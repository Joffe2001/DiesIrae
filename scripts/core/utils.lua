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

---Returns a table where you can store all object-exclusive data
---@param obj userdata
---@return table
function utils:GetData(obj)
    if type(obj) ~= "userdata" then return {} end
    local hash = GetPtrHash(obj)
    local data = obj_data[hash]
    if not data then
        local newData = {}
        obj_data[hash] = newData
        data = newData
    end
    return data
end

---Checks if the vectors is equal or not
---@param v1 vector
---@param v2 vector
---@return boolean
function utils:VectorEqual(v1, v2)
    return tostring(v1) == tostring(v2)
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, CallbackPriority.LATE, function(_, obj)
    obj_data[GetPtrHash(obj)] = nil
end)


return utils