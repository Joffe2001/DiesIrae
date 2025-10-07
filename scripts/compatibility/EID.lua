if not EID then return end

local mod = DiesIraeMod
local Enums = require("core.enums")
local function always_true()
    return true
end

local Name2Variant = {
    Collectible = PickupVariant.PICKUP_COLLECTIBLE,
    Trinket = PickupVariant.PICKUP_TRINKET
}

local descmods_num = 0

---------------------------------------------------
-- 🔹 EID Description System
---------------------------------------------------
function mod:AddEIDescription(var, add_func, id, lang, desc_table, lang_table)
    local base_desc = ""
    local variant = Name2Variant[var]

    for _, str in ipairs(desc_table) do
        if type(str) == "string" then
            base_desc = base_desc .. "#" .. str
        else
            descmods_num = descmods_num + 1
            local ModFunc, CondFunc

            if type(str) == "table" then
                CondFunc = str[1]
                ModFunc = str[2]
            else
                CondFunc = always_true
                ModFunc = str
            end

            local function Condition(descObj)
                local player = EID:ClosestPlayerTo(descObj.Entity)

                return descObj.ObjType == EntityType.ENTITY_PICKUP
                    and descObj.ObjVariant == variant
                    and (descObj.ObjSubType == id 
                         or (var == "Trinket" and descObj.ObjSubType == id + (1 << 15))
                    )
                    and CondFunc(descObj, player)
                    and (EID:getLanguage() == lang 
                         or (lang == "en_us" and not lang_table[EID:getLanguage()])
                    )
            end

            -- Modifier function: appends dynamic description
            local function Modifier(descObj)
                local player = EID:ClosestPlayerTo(descObj.Entity)
                local new_desc = "#" .. ModFunc(descObj, player)
                EID:appendToDescription(descObj, new_desc)
                return descObj
            end

            -- Register the modifier with EID
            EID:addDescriptionModifier("Dies Irae #" .. descmods_num, Condition, Modifier)
        end
    end

    -- Add base description for static lines
    add_func(id, base_desc, _, lang)
end

----------------------------
-- 🔹 Register 
---------------------------------------------------
for var, t1 in pairs(mod.EIDescs) do
    for id, t2 in pairs(t1) do
        if type(t2) == "table" then
            for lang, desc in pairs(t2) do
                mod:AddEIDescription(var, t1.EIDadd, id, lang, desc, t2)
            end
        end
    end
end

