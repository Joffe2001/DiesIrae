local mod = DiesIraeMod
local DavidChallenges = {}

local DavidPlateIndex = nil
local DavidBackdropSpawned = false
local DavidFloorID = nil
local DavidFloorFrame = nil
local UsedDavidFrames = {}
local LeftRoomWithoutPress = false
local GaveDavidPenalty = false

---@param player EntityPlayer
function DavidChallenges.AddPressurePlateInStartRoom(player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = Game():GetLevel()
    local room = Game():GetRoom()

    if level:GetCurrentRoomIndex() ~= level:GetStartingRoomIndex() then return end
    if level:GetStage() < 2 then return end


    for i = 0, room:GetGridSize() - 1 do
        local grid = room:GetGridEntity(i)
        if grid and grid:GetType() == GridEntityType.GRID_PRESSURE_PLATE then
            return
        end
    end

    local GRID_WIDTH = 13
    local gridSize = room:GetGridSize()
    local roomHeight = math.floor(gridSize / GRID_WIDTH)

    local targetIndex =
        (math.floor(roomHeight / 2) + 2) * GRID_WIDTH +
        math.floor(GRID_WIDTH / 2)

    if targetIndex < 0 or targetIndex >= gridSize then return end

    room:RemoveGridEntity(targetIndex, 0, false)
    room:SpawnGridEntity(
        targetIndex,
        GridEntityType.GRID_PRESSURE_PLATE,
        0,
        0,
        0
    )

    local grid = room:GetGridEntity(targetIndex)
    if grid then
        local spr = grid:GetSprite()
        spr:Load("gfx/grid/David_challenges/challengebutton.anm2", true)
        spr:Play("Off", true)
    end

    DavidPlateIndex = targetIndex
end

---@return integer
local function GetUniqueDavidFrame()
    local frames = {1,2,3,4,5,6,7,8,9}

    for _, used in ipairs(UsedDavidFrames) do
        for i = #frames, 1, -1 do
            if frames[i] == used then
                table.remove(frames, i)
            end
        end
    end

    if #frames == 0 then
        UsedDavidFrames = {}
        frames = {1,2,3,4,5,6,7,8,9}
    end

    local choice = frames[math.random(#frames)]
    table.insert(UsedDavidFrames, choice)
    return choice
end

---@param player EntityPlayer
function DavidChallenges.CheckDavidPlate(player)
    local room = Game():GetRoom()
    if not DavidPlateIndex then return end

    local grid = room:GetGridEntity(DavidPlateIndex)
    if not grid or grid:GetType() ~= GridEntityType.GRID_PRESSURE_PLATE then return end

    if grid:GetSprite():GetAnimation() == "On"
        and not DavidBackdropSpawned
    then
        if not DavidFloorFrame then
            if LeftRoomWithoutPress then
                DavidFloorFrame = 0
            else
                DavidFloorFrame = GetUniqueDavidFrame()
            end
        end

        local effect = Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            0,
            0,
            room:GetCenterPos() + Vector(-15, -40),
            Vector.Zero,
            nil
        )

        effect:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)

        local eSpr = effect:GetSprite()
        eSpr:Load("gfx/grid/David_challenges/challenges.anm2", true)
        eSpr:Play("Idle", true)
        eSpr:SetFrame(DavidFloorFrame)

        DavidBackdropSpawned = true
    end
end

---@param player EntityPlayer
---@param cacheFlag CacheFlag
function DavidChallenges.EvaluateDavidStats(player, cacheFlag)
    local localPlayer = Isaac.GetPlayer(0)
    if not localPlayer then return end
    if localPlayer:GetPlayerType() ~= mod.Players.David then return end

    if GaveDavidPenalty then return end

    if LeftRoomWithoutPress then
        GaveDavidPenalty = true
        print("Applying penalty...")

        localPlayer.Damage = localPlayer.Damage - 0.2
        localPlayer.MaxFireDelay = localPlayer.MaxFireDelay + 0.2
        localPlayer.TearRange = localPlayer.TearRange - 0.2 * 40
        localPlayer.ShotSpeed = localPlayer.ShotSpeed - 0.2
        localPlayer.Luck = localPlayer.Luck - 0.5
        localPlayer.MoveSpeed = localPlayer.MoveSpeed - 0.05

        localPlayer:AddCacheFlags(
            CacheFlag.CACHE_DAMAGE
            | CacheFlag.CACHE_FIREDELAY
            | CacheFlag.CACHE_RANGE
            | CacheFlag.CACHE_SHOTSPEED
            | CacheFlag.CACHE_LUCK
            | CacheFlag.CACHE_SPEED
        )
        localPlayer:EvaluateItems()

        print("Stats evaluated after penalty.")
    end
end

function DavidChallenges.OnNewRoom()
    local level = Game():GetLevel()
    local player = Isaac.GetPlayer(0)

    local currentFloor = level:GetStage()
    local currentRoomIndex = level:GetCurrentRoomIndex()

    if DavidFloorID ~= currentFloor then
        GaveDavidPenalty = false
        DavidFloorID = currentFloor
        DavidFloorFrame = nil
        LeftRoomWithoutPress = false
        DavidPlateIndex = nil

        print("OnNewRoom: Resetting penalty flags for new floor")
    end

    if DavidPlateIndex
        and not DavidBackdropSpawned
        and currentRoomIndex ~= level:GetStartingRoomIndex()
        and not GaveDavidPenalty
    then
        LeftRoomWithoutPress = true

        player:AddCacheFlags(
            CacheFlag.CACHE_DAMAGE
            | CacheFlag.CACHE_FIREDELAY
            | CacheFlag.CACHE_RANGE
            | CacheFlag.CACHE_SHOTSPEED
            | CacheFlag.CACHE_LUCK
            | CacheFlag.CACHE_SPEED
        )
        player:EvaluateItems()

        GaveDavidPenalty = true
        print("OnNewRoom: GaveDavidPenalty = " .. tostring(GaveDavidPenalty))
    end

    DavidBackdropSpawned = false
    DavidChallenges.AddPressurePlateInStartRoom(player)
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, DavidChallenges.CheckDavidPlate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, DavidChallenges.OnNewRoom)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DavidChallenges.EvaluateDavidStats)

return DavidChallenges
