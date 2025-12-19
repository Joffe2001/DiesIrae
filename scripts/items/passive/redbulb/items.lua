local items = {}
local data = require("scripts.data")
local dataHolder = require("scripts.dataHolder")
local game = Game()
local level = game:GetLevel()


function items:demonicAngelNoRedHearts(pickup, variant)
	if not data.doInversion then
	return end

	local roomDescData = level:GetCurrentRoomDesc().Data
	if roomDescData.Type ~= data.rooms.demonicAngelType or roomDescData.Subtype ~= data.rooms.demonicAngelSubtype then
	return end

	if variant ~= 100 or not (pickup.Price < 0 and pickup.Price > -10) then
	return end

	pickup.Price = 0
end


function items:demonicAngelBrokenHearts(player, entity)
	if not data.doInversion or entity.Type ~= 5 or entity.Variant ~= 100 then
	return end

	local ptrHash = GetPtrHash(entity)
	local entityData = dataHolder.Data[ptrHash]
	if entityData == nil then
	return end
	if entityData.blockAngel then
	return end
	
	if entityData.touched then
	return end
	
	dataHolder.Data[ptrHash].touched = true
	player:AddBrokenHearts(entityData.brokenHearts)

	dataHolder.RoomData.collectibles[entity.SubType] = dataHolder.RoomData.collectibles[entity.SubType] - 1
	if dataHolder.RoomData.collectibles[entity.SubType] == 0 then
		dataHolder.RoomData.collectibles[entity.SubType] = nil
	end
end


local brokenHeartSprite = Sprite()
brokenHeartSprite:Load("gfx/ui/ui_hearts.anm2", true)
brokenHeartSprite:Play("BrokenHeart", true)
function items:renderBrokenHeartsSprite()
	if not data.doInversion then
	return end

	local roomDescData = level:GetCurrentRoomDesc().Data
	if roomDescData.Type ~= data.rooms.demonicAngelType or roomDescData.Subtype ~= data.rooms.demonicAngelSubtype then
	return end

	for i, entity in ipairs(Isaac.GetRoomEntities()) do
		local ptrHash = GetPtrHash(entity)
		local entityData = dataHolder.Data[ptrHash]

		if entityData ~= nil then
			if entityData.touched == false then

				local screenPos = Isaac.WorldToScreen(entityData.position)
				local offset = {}
				offset.Y = -10
				offset.X = 3
				screenPos.Y = screenPos.Y + offset.Y
				screenPos.X = screenPos.X + offset.X

				brokenHeartSprite:Update()
				brokenHeartSprite:Render(screenPos)

				if entityData.brokenHearts == 2 then
					local secPos = screenPos
					local secOffset = {}
					secOffset.Y = 5
					secOffset.X = 3
					secPos.Y = secPos.Y + secOffset.Y
					secPos.X = secPos.X + secOffset.X

					brokenHeartSprite:Render(secPos)
				end
	end end end
end


function items:blockDemonicAngel(player, entity)
	if not data.doInversion or entity.Type ~= 5 or entity.Variant ~= 100 then
	return end

	local ptrHash = GetPtrHash(entity)
	local entityData = dataHolder.Data[ptrHash]
	if entityData == nil then
	return end
	if not entityData.blockAngel then
	return end

	if entityData.touched then
	return end

	dataHolder.Data[ptrHash].touched = true
	game:AddDevilRoomDeal()

	dataHolder.RoomData.collectibles[entity.SubType] = dataHolder.RoomData.collectibles[entity.SubType] - 1
	if dataHolder.RoomData.collectibles[entity.SubType] == 0 then
		dataHolder.RoomData.collectibles[entity.SubType] = nil
	end
end


return items
