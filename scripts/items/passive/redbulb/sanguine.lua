local sanguine = {}
local data = require("scripts.data")
local game = Game()
local level = game:GetLevel()


local sanguineBlocked = true
function sanguine:blockSanguineBond(index)
	if not data.doInversion then
	return end
	
	if index == GridRooms.ROOM_DEVIL_IDX then
		local players = PlayerManager.GetPlayers()
		for _, player in ipairs(players) do
			player:BlockCollectible(CollectibleType.COLLECTIBLE_SANGUINE_BOND)
		end
		sanguineBlocked = true
	elseif sanguineBlocked then
		local players = PlayerManager.GetPlayers()
		for _, player in ipairs(players) do
			player:UnblockCollectible(CollectibleType.COLLECTIBLE_SANGUINE_BOND)
		end
		sanguineBlocked = false
	end
end


local hasSanguine = false
function sanguine:checkForSanguine()
	if not data.doInversion then
	return end

	hasSanguine = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_SANGUINE_BOND)
end

function sanguine:spawnConfessional()
	if not data.doInversion then
	return end
	if not hasSanguine then
	return end

	local roomDesc = level:GetCurrentRoomDesc()
	if roomDesc.GridIndex ~= GridRooms.ROOM_DEVIL_IDX then
	return end
	if (roomDesc.Data.Type ~= data.rooms.angelicDevilType and roomDesc.Data.Subtype ~= data.rooms.angelicDevilSubtype) or 
	(roomDesc.Data.Type ~= data.rooms.angelicDevilNumberMagnetType and roomDesc.Data.Subtype ~= data.rooms.angelicDevilNumberMagnetSubtype) or
	roomDesc.Data.Variant == data.rooms.angelicDevilPortalVar then
	return end

	local room = game:GetRoom()
	local pos = room:GetGridPosition(47)
	game:Spawn(EntityType.ENTITY_SLOT, 17 --[[Variant: confessional]], pos, Vector(0, 0) --[[velocity]], nil --[[parent]], 0 --[[Subtype]], room:GetSpawnSeed())
end


return sanguine
