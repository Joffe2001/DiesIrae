local stairway = {}
local data = require("scripts.data")
local level = Game():GetLevel()


local AddedPound = true
function stairway:givePound(index, dimension)
	if not data.doInversion then
	return end

	if index == GridRooms.ROOM_ANGEL_SHOP_IDX then
		local player = Isaac.GetPlayer() --not PlayerManager.GetPlayers(), one instant of Sanguine Bond is enough
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH, 1) -- 1 = Amount
		AddedPound = true
	elseif AddedPound then
		local player = Isaac.GetPlayer()
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH, -1)
		AddedPound = false
	end
end

function stairway:givePoundOnInit()
	if not data.doInversion then
	return end

	AddedPound = false

	local roomDesc = level:GetCurrentRoomDesc()
	if roomDesc.GridIndex ~= GridRooms.ROOM_ANGEL_SHOP_IDX then
	return end

	local player = Isaac.GetPlayer()
	player:AddInnateCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH, 1)
	AddedPound = true
end


return stairway
