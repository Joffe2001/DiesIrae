local mod = DiesIraeMod
local DavidChallenges = {}

local DavidPlateIndex = nil
local DavidBackdropSpawned = false
local DavidFloorID = nil
local DavidFloorFrame = nil
local UsedDavidFrames = {}
local LeftRoomWithoutPress = false

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

    local centerColumn = math.floor(GRID_WIDTH / 2)
    local centerRow = math.floor(roomHeight / 2)

    local targetColumn = centerColumn
    local targetRow    = centerRow + 2

    local targetIndex = targetRow * GRID_WIDTH + targetColumn

    if targetIndex < 0 or targetIndex >= gridSize then return end

    room:RemoveGridEntity(targetIndex, 0, false)
    room:SpawnGridEntity(targetIndex, GridEntityType.GRID_PRESSURE_PLATE, 0, 0, 0)

    local grid = room:GetGridEntity(targetIndex)
    if grid then
        local spr = grid:GetSprite()
        spr:Load("gfx/grid/David_challenges/challengebutton.anm2", true)
        spr:Play("Off", true)
        DavidPlateIndex = targetIndex
        LeftRoomWithoutPress = false
    end
end

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

function DavidChallenges.CheckDavidPlate()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local room = Game():GetRoom()
    if not DavidPlateIndex then return end

    local grid = room:GetGridEntity(DavidPlateIndex)
    if not grid or grid:GetType() ~= GridEntityType.GRID_PRESSURE_PLATE then return end

    if grid:GetSprite():GetAnimation() == "On" and not DavidBackdropSpawned then

        if not DavidFloorFrame then
            if LeftRoomWithoutPress then
                DavidFloorFrame = 0 
            else
                DavidFloorFrame = GetUniqueDavidFrame()
            end
        end

        local roomCenter = room:GetCenterPos()
        local effectPos = roomCenter + Vector(-15, -40)
        local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, 0, 0, effectPos, Vector(0,0), nil)
        effect:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)

        local eSpr = effect:GetSprite()
        eSpr:Load("gfx/grid/David_challenges/challenges.anm2", true)
        eSpr:Play("Idle", true)
        eSpr:SetFrame(DavidFloorFrame)

        DavidBackdropSpawned = true
    end
end

function DavidChallenges.OnNewRoom()
    local level = Game():GetLevel()
    local currentFloor = level:GetStage()

    if DavidFloorID ~= currentFloor then
        DavidFloorID = currentFloor
        DavidFloorFrame = nil
    end

    DavidBackdropSpawned = false

    if DavidPlateIndex and not DavidBackdropSpawned then
        LeftRoomWithoutPress = true
    end

    DavidChallenges.AddPressurePlateInStartRoom(Isaac.GetPlayer(0))
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, DavidChallenges.CheckDavidPlate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, DavidChallenges.OnNewRoom)

return DavidChallenges