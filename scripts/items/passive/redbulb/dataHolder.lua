--https://isaacblueprints.com/tutorials/concepts/entity_data/

local dataHolder = {}
dataHolder.Data = {}

local data = require("scripts.items.passive.redbulb.data")
local level = Game():GetLevel()


local function GetEntityData(entity)
	local ptrHash = GetPtrHash(entity)
	if not dataHolder.Data[ptrHash] then
		dataHolder.Data[ptrHash] = {}
		local entityData = dataHolder.Data[ptrHash]

		entityData.Pointer = EntityPtr(entity)
		entityData.touched = false
		entityData.position = nil
		entityData.brokenHearts = nil
		entityData.blockAngel = false
	end

	return dataHolder.Data[ptrHash]
end

dataHolder.RoomData = {}
dataHolder.RoomData.collectibles = {}
function dataHolder:GetEntityData_demonicAngel()
	if not data.doInversion then
	return end

	local roomDesc = level:GetCurrentRoomDesc()
	if roomDesc.Data.Type ~= data.rooms.demonicAngelType or roomDesc.Data.Subtype ~= data.rooms.demonicAngelSubtype then
	return end

	local collectiblesLength = 0
	for _, _ in pairs(dataHolder.RoomData.collectibles) do
		collectiblesLength = collectiblesLength + 1
	end

	if collectiblesLength == 0 or roomDesc.VisitedCount == 1 then
		dataHolder.RoomData.collectibles = {}
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.Type == 5 and entity.Variant == 100 then
				GetEntityData(entity)
			
				local ptrHash = GetPtrHash(entity)
				dataHolder.Data[ptrHash].position = entity.Position
	
				local itemConfig = Isaac.GetItemConfig()
				local itemConfig_Item = itemConfig:GetCollectible(entity.SubType)
				if itemConfig_Item.Quality >= 3 then
					dataHolder.Data[ptrHash].brokenHearts = 2
				else
					dataHolder.Data[ptrHash].brokenHearts = 1
				end

				if dataHolder.RoomData.collectibles[entity.SubType] == nil then
					dataHolder.RoomData.collectibles[entity.SubType] = 1
				else
					dataHolder.RoomData.collectibles[entity.SubType] = dataHolder.RoomData.collectibles[entity.SubType] + 1
				end
		end end 
	else
		local collectiblesTmp = {}
		for i, j in pairs(dataHolder.RoomData.collectibles) do
			collectiblesTmp[i] = j
		end

		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.Type == 5 and entity.Variant == 100 then
				for collectibleType, collectibleCount in pairs(collectiblesTmp) do
					if entity.SubType == collectibleType then
						if collectibleCount > 0 then
							GetEntityData(entity)
					
							local ptrHash = GetPtrHash(entity)
							dataHolder.Data[ptrHash].position = entity.Position
				
							local itemConfig = Isaac.GetItemConfig()
							local itemConfig_Item = itemConfig:GetCollectible(entity.SubType)
							if itemConfig_Item.Quality >= 3 then
								dataHolder.Data[ptrHash].brokenHearts = 2
							else
								dataHolder.Data[ptrHash].brokenHearts = 1
							end
					
							collectiblesTmp[collectibleType] = collectibleCount - 1
				end end end
		end end
	end
end

function dataHolder:GetEntityData_blockAngel()
	if not data.doInversion then
	return end

	local roomDesc = level:GetCurrentRoomDesc()
	if roomDesc.GridIndex ~= GridRooms.ROOM_DEVIL_IDX then
	return end
	if roomDesc.Data.Type == data.rooms.angelicDevilPortalType and roomDesc.Data.Variant == data.rooms.angelicDevilPortalVar then
	return end

	if not ((roomDesc.Data.Type == data.rooms.angelicDevilType and roomDesc.Data.Subtype == data.rooms.angelicDevilSubtype) or (roomDesc.Data.Type == data.rooms.angelicDevilNumberMagnetType and roomDesc.Data.Subtype == data.rooms.angelicDevilNumberMagnetSubtype)) then
	return end

	local collectiblesLength = 0
	for _, _ in pairs(dataHolder.RoomData.collectibles) do
		collectiblesLength = collectiblesLength + 1
	end

	if collectiblesLength == 0 or roomDesc.VisitedCount == 1 then
		dataHolder.RoomData.collectibles = {}
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.Type == 5 and entity.Variant == 100 then
				GetEntityData(entity)
		
				local ptrHash = GetPtrHash(entity)
				dataHolder.Data[ptrHash].blockAngel = true

				if dataHolder.RoomData.collectibles[entity.SubType] == nil then
					dataHolder.RoomData.collectibles[entity.SubType] = 1
				else
					dataHolder.RoomData.collectibles[entity.SubType] = dataHolder.RoomData.collectibles[entity.SubType] + 1
				end
		end end
	else
		local collectiblesTmp = {}
		for i, j in pairs(dataHolder.RoomData.collectibles) do
			collectiblesTmp[i] = j
		end

		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.Type == 5 and entity.Variant == 100 then
				for collectibleType, collectibleCount in pairs(collectiblesTmp) do
					if entity.SubType == collectibleType then
						if collectibleCount > 0 then
							GetEntityData(entity)

							local ptrHash = GetPtrHash(entity)
							dataHolder.Data[ptrHash].blockAngel = true

							collectiblesTmp[collectibleType] = collectibleCount - 1
				end end end
		end end
	end
end


function dataHolder:ClearDataOfEntity(entity)
	local ptrHash = GetPtrHash(entity)
	dataHolder.Data[ptrHash] = nil
end


return dataHolder
