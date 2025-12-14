---@class ModReference
local mod = DiesIraeMod
local game = Game()

local function AddTearsBoost(player, amount)
    local data = player:GetData()
    data.PermanentTearsBoost = (data.PermanentTearsBoost or 0) + amount
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    player:EvaluateItems()
end

function mod:OnNewRoom()
    local room = game:GetRoom()

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.DevilsMap) then
            local data = player:GetData()
            data.BoostedRooms = data.BoostedRooms or {}
            local roomType = room:GetType()
            if not data.BoostedRooms[roomType] then
                if roomType == RoomType.ROOM_CURSE or roomType == RoomType.ROOM_SACRIFICE or roomType == RoomType.ROOM_DEVIL then
                    AddTearsBoost(player, 0.6)
                    data.BoostedRooms[roomType] = true
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)

-- duplicate in mod
function mod:OnCache(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local boost = data.PermanentTearsBoost or 0
        player.MaxFireDelay = math.max(1, player.MaxFireDelay - boost)
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnCache)

function mod:OnNewFloor()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()
        data.BoostedRooms = {}
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewFloor)

function mod:DevilsMapRender()
    local level = game:GetLevel()

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.DevilsMap) then
            for j = 0, level:GetRooms().Size - 1 do
                local roomDesc = level:GetRooms():Get(j)
                local rType = roomDesc.Data.Type
                if rType == RoomType.ROOM_SACRIFICE or rType == RoomType.ROOM_CURSE then
                    roomDesc.DisplayFlags = roomDesc.DisplayFlags | RoomDescriptor.DISPLAY_ICON
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.DevilsMapRender)
