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

mod:AddPriorityCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, CallbackPriority.LATE, function(_, obj)
    obj_data[GetPtrHash(obj)] = nil
end)


return utils
