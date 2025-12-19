local unlock = {}
unlock.achievement_RedBulb = Isaac.GetAchievementIdByName("Red Bulb Unlock")


local isUnlocked = false

function unlock:isUnlocked()
	isUnlocked = Isaac.GetPersistentGameData():Unlocked(unlock.achievement_RedBulb)
end


local wasInDevil = nil
local wasInAngel = nil

function unlock:resetOnNewRun(isContinued)
	if isContinued or isUnlocked then
	return end

	wasInDevil = false
	wasInAngel = false
end

function unlock:checkRooms_unlock(index, dimension)
	if isUnlocked then
	return end

	if index ~= GridRooms.ROOM_DEVIL_IDX then
	return end
	if wasInDevil and wasInAngel then
	return end

	local roomDesc = Game():GetLevel():GetRoomByIdx(index, dimension)
	if not wasInDevil then
		if roomDesc.Data.Type == RoomType.ROOM_DEVIL then
			wasInDevil = true
	end end

	if not wasInAngel then
		if roomDesc.Data.Type == RoomType.ROOM_ANGEL then
			wasInAngel = true
	end end


	if wasInDevil and wasInAngel then
		Isaac.GetPersistentGameData():TryUnlock(unlock.achievement_RedBulb)
	end
end


return unlock
