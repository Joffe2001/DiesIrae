local sprites = {}
local data = require("scripts.items.passive.redbulb.data")
local game = Game()
local level = game:GetLevel()


local currentRoom = nil
function sprites:checkRoom(_, roomDesc)
	if not data.doInversion then 
	return end

	if roomDesc.GridIndex ~= GridRooms.ROOM_DEVIL_IDX and roomDesc.GridIndex ~= GridRooms.ROOM_ANGEL_SHOP_IDX then
		currentRoom = nil
	return end
	
	--[[ DEMONIC ANGEL ]]--
	if roomDesc.Data.Type == data.rooms.demonicAngelPortalType and roomDesc.Data.Subtype == data.rooms.demonicAngelPortalSubtype and roomDesc.Data.Variant == data.rooms.demonicAngelPortalVar then
		currentRoom = "demonicAngelPortal"
	elseif roomDesc.Data.Type == data.rooms.demonicAngelType and roomDesc.Data.Subtype == data.rooms.demonicAngelSubtype then
		currentRoom = "demonicAngel"
	elseif roomDesc.Data.Type == data.rooms.demonicAngelStairwayType and roomDesc.Data.Subtype == data.rooms.demonicAngelStairwaySubtype then
		currentRoom = "demonicAngelStairway"

	--[[ ANGELIC DEVIL ]]--
	elseif roomDesc.Data.Type == data.rooms.angelicDevilPortalType and roomDesc.Data.Subtype == data.rooms.angelicDevilPortalSubtype and roomDesc.Data.Variant == data.rooms.angelicDevilPortalVar then
		currentRoom = "angelicDevilPortal"
	elseif roomDesc.Data.Type == data.rooms.angelicDevilType and roomDesc.Data.Subtype == data.rooms.angelicDevilSubtype then
		currentRoom = "angelicDevil"
	elseif roomDesc.Data.Type == data.rooms.angelicDevilNumberMagnetType and roomDesc.Data.Subtype == data.rooms.angelicDevilNumberMagnetSubtype then
		currentRoom = "angelicDevilNumberMagnet"
	else currentRoom = nil
    end
end

function sprites:changeBackdrop()
	if not data.doInversion then
	return end

	--[[ DEMONIC ANGEL ]]--
	if currentRoom == "demonicAngelPortal" then
		return data.backdrops.demonicAngel
	elseif currentRoom == "demonicAngel" then
		return data.backdrops.demonicAngel
	elseif currentRoom == "demonicAngelStairway" then
		return data.backdrops.demonicAngelStairway

	--[[ ANGELIC DEVIL ]]--
	elseif currentRoom == "angelicDevilPortal" then
		return data.backdrops.angelicDevil
	elseif currentRoom == "angelicDevil" then
		return data.backdrops.angelicDevil
	elseif currentRoom == "angelicDevilNumberMagnet" then
		return data.backdrops.angelicDevil
	end
end

local pathAngelicDevilDoor = "gfx/grid/angelicDevil_door.png"
local pathDemonicAngelDoor = "gfx/grid/demonicAngel_door.png"
local pathDemonicAngelStairwayDoor = "gfx/grid/demonicAngelStairway_door.png"
function sprites:changeDoorsInside()
	if not data.doInversion then
	return end

	local rightPath = nil

	--[[ DEMONIC ANGEL ]]--
	if currentRoom == "demonicAngelPortal" then
		rightPath = pathDemonicAngelDoor
	elseif currentRoom == "demonicAngel" then
		rightPath = pathDemonicAngelDoor
	elseif currentRoom == "demonicAngelStairway" then
		rightPath = pathDemonicAngelStairwayDoor

	--[[ ANGELIC DEVIL ]]--
	elseif currentRoom == "angelicDevilPortal" then
		rightPath = pathAngelicDevilDoor
	elseif currentRoom == "angelicDevil" then
		rightPath = pathAngelicDevilDoor
	elseif currentRoom == "angelicDevilNumberMagnet" then
		rightPath = pathAngelicDevilDoor
	else 
		return 
	end

	local room = game:GetRoom()
	for i = 0, DoorSlot.NUM_DOOR_SLOTS -1 do
		local door = room:GetDoor(i)
		if door ~= nil then
			local sprite = door:GetSprite()
			for i = 0, 4 do
				sprite:ReplaceSpritesheet(i, rightPath, true)
			end
	end end
end


local function getStatueEffects(room)
	local statueEffects = {}
	statueEffects.devil = {}
	statueEffects.angel = {}

	local roomEntities = Isaac.GetRoomEntities()
	for _, entity in ipairs(roomEntities) do
		if entity.Type == EntityType.ENTITY_EFFECT then
			local gridEntity = room:GetGridEntityFromPos(entity.Position)
			if gridEntity ~= nil then
				local gridEntityDesc = gridEntity:GetSaveState()	
				if gridEntityDesc.Type == GridEntityType.GRID_STATUE then
					if gridEntityDesc.Variant == 0 then -- 0 == devil
						statueEffects.devil[#statueEffects.devil +1] = entity
					elseif gridEntityDesc.Variant == 1 then -- 1 == angel
						statueEffects.angel[#statueEffects.angel +1] = entity
	end end end end end

	return statueEffects
end

local pathStatueDemonicAngel = "gfx/statues/demonicAngelStatue.png"
local pathStatueAngelicDevil = "gfx/statues/angelicDevilStatue.png"
function sprites:changeStatues()
	if not data.doInversion then
	return end

	local roomDesc = level:GetCurrentRoomDesc()
	if roomDesc.GridIndex ~= GridRooms.ROOM_DEVIL_IDX and roomDesc.GridIndex ~= GridRooms.ROOM_ANGEL_SHOP_IDX then
	return end
	
	local room = level:GetCurrentRoom()

	--[[ DEMONIC ANGEL ]]--
	if currentRoom == "demonicAngelPortal" then
		local statueEffects = getStatueEffects(room)
		for _, effect in ipairs(statueEffects.angel) do
			local sprite = effect:GetSprite()
			sprite:ReplaceSpritesheet(0, pathStatueDemonicAngel, true)
		end	
	elseif currentRoom == "demonicAngel" then
		local statueEffects = getStatueEffects(room)
		for _, effect in ipairs(statueEffects.angel) do
			local sprite = effect:GetSprite()
			sprite:ReplaceSpritesheet(0, pathStatueDemonicAngel, true)
		end	
	elseif currentRoom == "demonicAngelStairway" then
		local statueEffects = getStatueEffects(room)
		for _, effect in ipairs(statueEffects.angel) do
			local sprite = effect:GetSprite()
			sprite:ReplaceSpritesheet(0, pathStatueDemonicAngel, true)
		end

	--[[ ANGELIC DEVIL ]]--
	elseif currentRoom == "angelicDevilPortal" then
		local statueEffects = getStatueEffects(room)
		for _, effect in ipairs(statueEffects.devil) do
			local sprite = effect:GetSprite()
			sprite:ReplaceSpritesheet(0, pathStatueAngelicDevil, true)
		end	
	elseif currentRoom == "angelicDevil" then
		local statueEffects = getStatueEffects(room)
		for _, effect in ipairs(statueEffects.devil) do
			local sprite = effect:GetSprite()
			sprite:ReplaceSpritesheet(0, pathStatueAngelicDevil, true)
		end	
	elseif currentRoom == "angelicDevilNumberMagnet" then
		local statueEffects = getStatueEffects(room)
		for _, effect in ipairs(statueEffects.devil) do
			local sprite = effect:GetSprite()
			sprite:ReplaceSpritesheet(0, pathStatueAngelicDevil, true)
		end	
    end
end


local pathDemonicAngel = "gfx/bosses/rebirth/demonicAngel.png"
local pathDemonicAngel2 = "gfx/bosses/rebirth/demonicAngel2.png"
function sprites:changeAngelBoss(npcEntity)
	if not data.doInversion then
	return end

	local roomDesc = level:GetCurrentRoomDesc()
	if roomDesc.GridIndex ~= GridRooms.ROOM_DEVIL_IDX and roomDesc.GridIndex ~= GridRooms.ROOM_ANGEL_SHOP_IDX then
	return end

	if not ((roomDesc.Data.Type == data.rooms.demonicAngelType and roomDesc.Data.Subtype == data.rooms.demonicAngelSubtype) or (roomDesc.Data.Type == data.rooms.demonicAngelStairwayType and roomDesc.Data.Subtype == data.rooms.demonicAngelStairwaySubtype)) then
	return end


	local sprite = npcEntity:GetSprite()
	if npcEntity.Type == EntityType.ENTITY_URIEL then
		sprite:ReplaceSpritesheet(0, pathDemonicAngel, true)
	elseif npcEntity.Type == EntityType.ENTITY_GABRIEL then
		sprite:ReplaceSpritesheet(0, pathDemonicAngel2, true)
	end
end


function sprites:changeDoorsPostBoss()
	if not data.doInversion then
	return end

	local room = game:GetRoom()
	if room:GetType() ~= RoomType.ROOM_BOSS then
	return end

	for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
		local door = room:GetDoor(i)
		if door ~= nil then
			if door.TargetRoomIndex == GridRooms.ROOM_DEVIL_IDX then
				if door.TargetRoomType == RoomType.ROOM_DEVIL then
					local sprite = door:GetSprite()
					for i = 0, 4 do
						sprite:ReplaceSpritesheet(i, pathAngelicDevilDoor, true)
					end
				elseif door.TargetRoomType == RoomType.ROOM_ANGEL then
					local sprite = door:GetSprite()
					for i = 0, 4 do
						sprite:ReplaceSpritesheet(i, pathDemonicAngelDoor, true)
					end
				end
	end end end
end

function sprites:changeDoorsOutside()
	if not data.doInversion then
	return end

	local room = game:GetRoom()
	if room:GetType() ~= RoomType.ROOM_BOSS then
	return end

	for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
		local door = room:GetDoor(i)
		if door ~= nil then
			if door.TargetRoomIndex == GridRooms.ROOM_DEVIL_IDX then
				if door.TargetRoomType == RoomType.ROOM_DEVIL then
					local targetRoomDesc = level:GetRoomByIdx(door.TargetRoomIndex, 0) --0 = main dimension
					if targetRoomDesc.VisitedCount == 0 then
						local sprite = door:GetSprite()
						for i = 0, 4 do
							sprite:ReplaceSpritesheet(i, pathAngelicDevilDoor, true)
						end
					else
						local sprite = door:GetSprite()
						for i = 0, 4 do
							sprite:ReplaceSpritesheet(i, pathDemonicAngelDoor, true)
						end
					end
				elseif door.TargetRoomType == RoomType.ROOM_ANGEL then
					local targetRoomDesc = level:GetRoomByIdx(door.TargetRoomIndex, 0) --0 = main dimension
					if targetRoomDesc.VisitedCount == 0 then
						local sprite = door:GetSprite()
						for i = 0, 4 do
							sprite:ReplaceSpritesheet(i, pathDemonicAngelDoor, true)
						end
					else
						local sprite = door:GetSprite()
						for i = 0, 4 do
							sprite:ReplaceSpritesheet(i, pathAngelicDevilDoor, true)
						end
				end end
	end end end
end


return sprites
