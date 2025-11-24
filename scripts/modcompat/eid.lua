---@class ModReference
local mod = DiesIraeMod

local function always_true()
	return true
end

local Name2Variant = {
	Collectible = PickupVariant.PICKUP_COLLECTIBLE,
	Trinket = PickupVariant.PICKUP_TRINKET,
	Card = PickupVariant.PICKUP_TAROTCARD,
	Pill = PickupVariant.PICKUP_PILL
}

local descmods_num = 0

function mod:AddEIDescription(var, add_func, id, lang, desc_table, lang_table)
	local base_desc = ""
	local variant = Name2Variant[var]

	for idx, str in ipairs(desc_table) do
		if type(str) == "string" then
			base_desc = base_desc .. "#" .. str
		else
			descmods_num = descmods_num + 1
			---@type function, function
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

						---@diagnostic disable-next-line: redundant-parameter
						and CondFunc(descObj, player)
						and (EID:getLanguage() == lang 
							or (lang == "en_us" and not lang_table[EID:getLanguage()])
						)
			end

			local function Modifier(descObj)
				local player = EID:ClosestPlayerTo(descObj.Entity)
				local old_desc = descObj.Description
				local add = "#" .. ModFunc(descObj, player)
				local start = 0

				if idx == 1 then
					descObj.Description = add .. old_desc
				else
					for i = 1, idx do
						start, _ = old_desc:find("#", start + 1) or 0
					end

					descObj.Description = old_desc:sub(1, start - 1) .. add .. old_desc:sub(start == 0 and -1 or start, -1)
				end

				return descObj
			end

			EID:addDescriptionModifier("DiesIraeModEIDModifier #" .. descmods_num, 
										Condition,
										Modifier)
		end
	end

	---@diagnostic disable-next-line: undefined-global
	add_func(id, base_desc, _, lang)
end

---@diagnostic disable-next-line: undefined-field
for var, t1 in pairs(mod.EIDescs) do
	for id, t2 in pairs(t1) do
		if type(t2) == "table" then
			for lang, desc in pairs(t2) do
				mod:AddEIDescription(var, t1.EIDadd, id, lang, desc, t2)
			end
		end
	end
end