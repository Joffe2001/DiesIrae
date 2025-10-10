local mod = DiesIraeMod

local NumToCurse = {}

for name, _ in pairs(mod.Curses) do
	table.insert(NumToCurse, name)
end

local function ApplyCurse(_, curses)
	if curses == LevelCurse.CURSE_NONE then return end

	local rng = RNG()
	rng:SetSeed(Game():GetSeeds():GetStartSeed(), 1)

	local chance = rng:RandomFloat()

	if chance <= 1 / (LevelCurse.NUM_CURSES - 1) * #NumToCurse then
		local curse = NumToCurse[#NumToCurse]

		for idx = 1, #NumToCurse do
			if chance <= 1 / (LevelCurse.NUM_CURSES - 1) * idx then
				curse = NumToCurse[idx]
			end
		end

		return 1 << mod.Curses[curse]
	end
end

mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, ApplyCurse)
