local room = {}
local data = require("scripts.items.passive.redbulb.data")
local dataHolder = require("scripts.items.passive.redbulb.dataHolder")
local game = Game()
local level = game:GetLevel()


function room:swapRoomlayoutPools(index, dimension)
    if (index ~= GridRooms.ROOM_DEVIL_IDX and index ~= GridRooms.ROOM_ANGEL_SHOP_IDX) or not data.doInversion then
    return end

    local roomDesc = level:GetRoomByIdx(index, dimension)
    local newRoomData = nil
    local rooms = data.rooms

    if roomDesc.Data.Type == RoomType.ROOM_DEVIL then
        if roomDesc.Data.Variant == 100 then
            newRoomData = RoomConfigHolder.GetRandomRoom(
                roomDesc.SpawnSeed, false, StbType.SPECIAL_ROOMS,
                rooms.angelicDevilPortalType, RoomShape.ROOMSHAPE_1x1,
                rooms.angelicDevilPortalVar, rooms.angelicDevilPortal,
                0,10,0,
                rooms.angelicDevilPortalSubtype)
		elseif roomDesc.Data.Subtype == 0 then
            newRoomData = RoomConfigHolder.GetRandomRoom(
                roomDesc.SpawnSeed, false, StbType.SPECIAL_ROOMS,
                rooms.angelicDevilType, RoomShape.ROOMSHAPE_1x1,
                rooms.angelicDevilVarMin, rooms.angelicDevilVarMax,
                0,10,0,
                rooms.angelicDevilSubtype)
        elseif roomDesc.Data.Subtype == 1 then
            newRoomData = RoomConfigHolder.GetRandomRoom(
                roomDesc.SpawnSeed, false, StbType.SPECIAL_ROOMS,
                rooms.angelicDevilNumberMagnetType, RoomShape.ROOMSHAPE_1x1,
                rooms.angelicDevilNumberMagnetVarMin, rooms.angelicDevilNumberMagnetVarMax,
                0,10,0,
                rooms.angelicDevilNumberMagnetSubtype)
        end
    elseif roomDesc.Data.Type == RoomType.ROOM_ANGEL then
        if roomDesc.Data.Variant == 100 then
            newRoomData = RoomConfigHolder.GetRandomRoom(
                roomDesc.SpawnSeed, false, StbType.SPECIAL_ROOMS,
                rooms.demonicAngelPortalType, RoomShape.ROOMSHAPE_1x1,
                rooms.demonicAngelPortalVar, rooms.demonicAngelPortal,
                0,10,0,
                rooms.demonicAngelPortalSubtype)
		elseif roomDesc.Data.Subtype == 0 then
            newRoomData = RoomConfigHolder.GetRandomRoom(
                roomDesc.SpawnSeed, false, StbType.SPECIAL_ROOMS,
                rooms.demonicAngelType, RoomShape.ROOMSHAPE_1x1,
                rooms.demonicAngelVarMin, rooms.demonicAngelVarMax,
                0,10,0,
                rooms.demonicAngelSubtype)
        elseif roomDesc.Data.Subtype == 1 then
            newRoomData = RoomConfigHolder.GetRandomRoom(
                roomDesc.SpawnSeed, false, StbType.SPECIAL_ROOMS,
                rooms.demonicAngelStairwayType, RoomShape.ROOMSHAPE_1x1,
                rooms.demonicAngelStairwayVarMin, rooms.demonicAngelStairwayVarMax,
                0,10,0,
                rooms.demonicAngelStairwaySubtype)
        end
    else return end

    roomDesc.Data = newRoomData or roomDesc.Data
end


function room:swapItemRoomPools(room, roomDesc)
    if (roomDesc.GridIndex ~= GridRooms.ROOM_DEVIL_IDX and roomDesc.GridIndex ~= GridRooms.ROOM_ANGEL_SHOP_IDX) or not data.doInversion then
    return end
	local rooms = data.rooms

    if roomDesc.Data.Type == rooms.demonicAngelType and roomDesc.Data.Subtype == rooms.demonicAngelSubtype then
        room:SetItemPool(ItemPoolType.POOL_ANGEL)
	elseif roomDesc.Data.Type == rooms.demonicAngelStairwayType and roomDesc.Data.Subtype == rooms.demonicAngelStairwaySubtype then
        room:SetItemPool(ItemPoolType.POOL_ANGEL)
	elseif roomDesc.Data.Type == rooms.angelicDevilType and roomDesc.Data.Subtype == rooms.angelicDevilSubtype then
        room:SetItemPool(ItemPoolType.POOL_DEVIL)
	elseif roomDesc.Data.Type == rooms.angelicDevilNumberMagnetType and roomDesc.Data.Subtype == rooms.angelicDevilNumberMagnetSubtype then
        room:SetItemPool(ItemPoolType.POOL_DEVIL)
    end
end


function room:spawnKeyPieces(npcEntity)
	if not data.doInversion then
	return end

	local roomDesc = level:GetCurrentRoomDesc()
	if roomDesc.GridIndex ~= GridRooms.ROOM_DEVIL_IDX then
	return end
	if roomDesc.Data.Type ~= data.rooms.demonicAngelType or roomDesc.Data.Subtype ~= data.rooms.demonicAngelSubtype then
	return end
	if roomDesc.Data.Type == data.rooms.demonicAngelPortalType and roomDesc.Data.Subtype == data.rooms.demonicAngelPortalSubtype and roomDesc.Data.Variant == data.rooms.demonicAngelPortalVar then
	return end

	local hasKey1 = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1)
	local hasKey2 = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2)
	local hasFeather = PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_FILIGREE_FEATHERS)
	
	if hasFeather and (hasKey1 == hasKey2) then
		local itemPool = game:GetItemPool()
		local collectible = itemPool:GetCollectible(ItemPoolType.POOL_ANGEL, true --[[decrease]], npcEntity:GetDropRNG():GetSeed())
		game:Spawn(EntityType.ENTITY_PICKUP, 100 --[[Variant]], npcEntity.Position, Vector(0,0) --[[Velocity]], nil --[[parent]], collectible, game:GetRoom():GetSpawnSeed())
	else
		if hasKey1 and hasKey2 then
		return end

		if hasKey1 then
			game:Spawn(EntityType.ENTITY_PICKUP, 100 --[[Variant]], npcEntity.Position, Vector(0,0) --[[Velocity]], nil --[[parent]], CollectibleType.COLLECTIBLE_KEY_PIECE_2, game:GetRoom():GetSpawnSeed())
		elseif hasKey2 then
			game:Spawn(EntityType.ENTITY_PICKUP, 100 --[[Variant]], npcEntity.Position, Vector(0,0) --[[Velocity]], nil --[[parent]], CollectibleType.COLLECTIBLE_KEY_PIECE_1, game:GetRoom():GetSpawnSeed())
		else
			rng = npcEntity:GetDropRNG()
			if rng:RandomInt(2) == 0 then -- output is 0 and 1
				game:Spawn(EntityType.ENTITY_PICKUP, 100 --[[Variant]], npcEntity.Position, Vector(0,0) --[[Velocity]], nil --[[parent]], CollectibleType.COLLECTIBLE_KEY_PIECE_1, game:GetRoom():GetSpawnSeed())
			else
				game:Spawn(EntityType.ENTITY_PICKUP, 100 --[[Variant]], npcEntity.Position, Vector(0,0) --[[Velocity]], nil --[[parent]], CollectibleType.COLLECTIBLE_KEY_PIECE_2, game:GetRoom():GetSpawnSeed())
			end
		end
	end
end


return room
