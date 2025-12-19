local data = {}
data.functions = {}
data.redBulb = Isaac.GetItemIdByName("Red Bulb")


data.doInversion = nil
function data.functions:checkForRedBulb()
	local numRb = PlayerManager.GetNumCollectibles(data.redBulb)

	data.doInversion = false
	if numRb%2 == 0 or numRb == 0 then
		data.doInversion = false
	else
		data.doInversion = true
	end
end


data.rooms = {}
data.rooms.angelicDevilType = nil
data.rooms.angelicDevilVarMin = nil
data.rooms.angelicDevilVarMax = nil
data.rooms.angelicDevilSubtype = nil
data.rooms.angelicDevilNumberMagnetType = nil
data.rooms.angelicDevilNumberMagnetVarMin = nil
data.rooms.angelicDevilNumberMagnetVarMax = nil
data.rooms.angelicDevilNumberMagnetSubtype = nil
data.rooms.angelicDevilPortalType = nil
data.rooms.angelicDevilPortalVar = nil
data.rooms.angelicDevilPortalSubtype = nil
data.rooms.demonicAngelType = nil
data.rooms.demonicAngelVarMin = nil
data.rooms.demonicAngelVarMax = nil
data.rooms.demonicAngelSubtype = nil
data.rooms.demonicAngelStairwayType = nil
data.rooms.demonicAngelStairwayVarMin = nil
data.rooms.demonicAngelStairwayVarMax = nil
data.rooms.demonicAngelStairwaySubtype = nil
data.rooms.demonicAngelPortalType = nil
data.rooms.demonicAngelPortalVar = nil
data.rooms.demonicAngelPortalSubtype = nil

function data.functions:getCustomRoomData()
	local isGreedMode = 0
	if Game():IsGreedMode() then
		isGreedMode = 1
	end

	local roomConfigSet = RoomConfig.GetStage(StbType.SPECIAL_ROOMS):GetRoomSet(isGreedMode)	-- 0 = not greed; 1 = greed

	for i = 0, roomConfigSet.Size - 1, 1 do
		local roomConfig = roomConfigSet:Get(i)
		local roomType = roomConfig.Type

		if roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_ANGEL then

			local roomName = roomConfig.Name
			local roomVariant = roomConfig.Variant
			local roomSubtype = roomConfig.Subtype

			--[[ ANGELIC DEVIL ]]--
			if roomName == "Angelic Devil (s)" then
				data.rooms.angelicDevilType = roomType
				data.rooms.angelicDevilVarMin = roomVariant
			elseif roomName == "Angelic Devil (copy) (e)" then
				data.rooms.angelicDevilVarMax = roomVariant
				data.rooms.angelicDevilSubtype = roomSubtype
			elseif roomName == "Angelic Devil (6 Room) (s)" then
				data.rooms.angelicDevilNumberMagnetType = roomType
				data.rooms.angelicDevilNumberMagnetVarMin = roomVariant
			elseif roomName == "Angelic Devil (6 Room) (copy) (e)" then
				data.rooms.angelicDevilNumberMagnetVarMax = roomVariant
				data.rooms.angelicDevilNumberMagnetSubtype = roomSubtype
			elseif roomName == "Angelic Devil (portal)" then
				data.rooms.angelicDevilPortalType = roomType
				data.rooms.angelicDevilPortalVar = roomVariant
				data.rooms.angelicDevilPortalSubtype = roomSubtype

			--[[ DEMONIC ANGEL ]]--
			elseif roomName == "Demonic Angel (s)" then
				data.rooms.demonicAngelType = roomType
				data.rooms.demonicAngelVarMin = roomVariant
			elseif roomName == "Demonic Angel (copy) (e)" then
				data.rooms.demonicAngelVarMax = roomVariant
				data.rooms.demonicAngelSubtype = roomSubtype
			elseif roomName == "Demonic Stairway (s)" then
				data.rooms.demonicAngelStairwayType = roomType
				data.rooms.demonicAngelStairwayVarMin = roomVariant
			elseif roomName == "Demonic Stairway (copy) (e)" then
				data.rooms.demonicAngelStairwayVarMax = roomVariant
				data.rooms.demonicAngelStairwaySubtype = roomSubtype
			elseif roomName == "Demonic Angel (portal)" then
				data.rooms.demonicAngelPortalType = roomType
				data.rooms.demonicAngelPortalVar = roomVariant
				data.rooms.demonicAngelPortalSubtype = roomSubtype
		end end
	end
end


data.backdrops = {}
data.backdrops.demonicAngel = nil
data.backdrops.demonicAngelStairway = nil
data.backdrops.angelicDevil = nil

function data.functions:getCustomBackdropData()
	data.backdrops.demonicAngel = Isaac.GetBackdropIdByName("demonic Angel")
	data.backdrops.demonicAngelStairway = Isaac.GetBackdropIdByName("demonic Angel Stairway")
	data.backdrops.angelicDevil = Isaac.GetBackdropIdByName("angelic Devil")
end


return data
