---@class ModReference
local mod = DiesIraeMod
local game = Game()
local pathOfTheRighteous = {}

mod.CollectibleType.COLLECTIBLE_PATH_OF_THE_RIGHTEOUS = Isaac.GetItemIdByName("Path of the Righteous")

local function PlayerHasRighteous()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_PATH_OF_THE_RIGHTEOUS) then
			return true
		end
	end
	return false
end

function pathOfTheRighteous:ForceAngelOverDevil(_, angelChance, devilChance)
    if PlayerHasRighteous() then
        return 1.0, 0.0
    end
    return angelChance, devilChance
end
mod:AddCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, pathOfTheRighteous.ForceAngelOverDevil)

function pathOfTheRighteous:OnNewLevel()
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
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, pathOfTheRighteous.OnNewLevel)
