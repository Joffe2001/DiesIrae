local mod = DiesIraeMod
local game = Game()

local function PlayerHasRighteous()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		if player:HasCollectible(mod.Items.PathOfTheRighteous) then
			return true
		end
	end
	return false
end

function mod:ForceAngelOverDevil(_, angelChance, devilChance)
    if PlayerHasRighteous() then
        return 1.0, 0.0
    end
    return angelChance, devilChance
end
mod:AddCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, mod.ForceAngelOverDevil)

function mod:OnNewLevel()
    if PlayerHasRighteous() then
        local level = game:GetLevel()
        local room = game:GetRoom()

        if room:GetType() == RoomType.ROOM_DEVIL then
            print("[Path of the Righteous] Converting Devil Room to Angel Room")
            level:InitializeDevilAngelRoom(true, false)
        end
        level:InitializeDevilAngelRoom(true, false)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewLevel)