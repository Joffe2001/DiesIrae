local mod = DiesIraeMod
local TravelerLogbook = {}
local game = Game()

mod.CollectibleType.COLLECTIBLE_TRAVELER_LOGBOOK = Isaac.GetItemIdByName("Traveler Logbook")

local visitedRooms = {}
local tempStatBonuses = {}
local permStatBonuses = {}

local StatList = { "damage", "speed", "tears", "range" }

local function ResetTempStats(index)
    tempStatBonuses[index] = {
        damage = 0,
        speed = 0,
        tears = 0,
        range = 0
    }
end

local function InitPlayerStats(player)
    local index = player:GetCollectibleRNG(mod.CollectibleType.COLLECTIBLE_TRAVELER_LOGBOOK):GetSeed()
    if not permStatBonuses[index] then
        permStatBonuses[index] = {
            damage = 0,
            speed = 0,
            tears = 0,
            range = 0
        }
    end
    if not tempStatBonuses[index] then
        ResetTempStats(index)
    end
end

function TravelerLogbook:ApplyStatBoost(player, isPermanent)
    local index = player:GetCollectibleRNG(mod.CollectibleType.COLLECTIBLE_TRAVELER_LOGBOOK):GetSeed()
    InitPlayerStats(player)

    local stat = StatList[math.random(#StatList)]
    local amount = isPermanent and 0.2 or 0.1

    if isPermanent then
        permStatBonuses[index][stat] = permStatBonuses[index][stat] + amount
        ResetTempStats(index)
    else
        tempStatBonuses[index][stat] = tempStatBonuses[index][stat] + amount
    end

    player:AddCacheFlags(
        CacheFlag.CACHE_DAMAGE |
        CacheFlag.CACHE_SPEED |
        CacheFlag.CACHE_FIREDELAY |
        CacheFlag.CACHE_RANGE
    )
    player:EvaluateItems()
end

function TravelerLogbook:OnNewRoom()
    local room = game:GetRoom()
    local level = game:GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    local roomID = roomDesc and roomDesc.SafeGridIndex or -1

    if roomID < 0 or visitedRooms[roomID] then return end

    local isErrorRoom = room:GetType() == RoomType.ROOM_ERROR

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_TRAVELER_LOGBOOK) then
            local index = player:GetCollectibleRNG(mod.CollectibleType.COLLECTIBLE_TRAVELER_LOGBOOK):GetSeed()
            InitPlayerStats(player)

            if isErrorRoom then
                TravelerLogbook:ApplyStatBoost(player, true)
            else
                TravelerLogbook:ApplyStatBoost(player, false)
                visitedRooms[roomID] = true
            end
        end
    end
end

function TravelerLogbook:OnNewLevel()
    visitedRooms = {}
    for _, _ in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
        local player = Isaac.GetPlayer(0)
        local index = player:GetCollectibleRNG(mod.CollectibleType.COLLECTIBLE_TRAVELER_LOGBOOK):GetSeed()
        ResetTempStats(index)
        player:AddCacheFlags(
            ---@diagnostic disable-next-line: param-type-mismatch
            CacheFlag.CACHE_DAMAGE |
            CacheFlag.CACHE_SPEED |
            CacheFlag.CACHE_FIREDELAY |
            CacheFlag.CACHE_RANGE
        )
        player:EvaluateItems()
    end
end

function TravelerLogbook:OnEvaluateCache(player, cacheFlag)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_TRAVELER_LOGBOOK) then return end

    local index = player:GetCollectibleRNG(mod.CollectibleType.COLLECTIBLE_TRAVELER_LOGBOOK):GetSeed()
    InitPlayerStats(player)

    local total = {
        damage = permStatBonuses[index].damage + tempStatBonuses[index].damage,
        speed  = permStatBonuses[index].speed + tempStatBonuses[index].speed,
        tears  = permStatBonuses[index].tears + tempStatBonuses[index].tears,
        range  = permStatBonuses[index].range + tempStatBonuses[index].range
    }

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + total.damage
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + total.speed
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        if total.tears > 0 then
            local tearsPerSecond = 30 / (player.MaxFireDelay + 1)
            player.MaxFireDelay = 30 / (tearsPerSecond + total.tears) - 1
        end
    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearHeight = player.TearHeight - total.range
        player.TearFallingSpeed = player.TearFallingSpeed + total.range
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, TravelerLogbook.OnNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, TravelerLogbook.OnNewLevel)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, TravelerLogbook.OnEvaluateCache)
