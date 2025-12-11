local mod = DiesIraeMod

local DavidChallenges = {}

local DavidPlateIndex = nil
local DavidBackdropSpawned = false
local DavidFloorID = nil
local DavidFloorFrame = nil
local UsedDavidFrames = {}

------------------------------
-- UNIQUE FRAME SELECTION
------------------------------
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

local function AddEventPlateInStartRoom(player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local game = Game()
    local level = game:GetLevel()
    local room = game:GetRoom()

    if level:GetCurrentRoomIndex() ~= level:GetStartingRoomIndex() then return end
    if level:GetStage() < 2 then return end

    for i = 0, room:GetGridSize() - 1 do
        local grid = room:GetGridEntity(i)
        if grid and grid:GetType() == mod.Grid.DavidPlate.Type 
           and grid:GetVariant() == mod.Grid.DavidPlate.Var then
            return
        end
    end

    local GRID_WIDTH = 13
    local gridSize = room:GetGridSize()
    local roomHeight = math.floor(gridSize / GRID_WIDTH)

    local centerColumn = math.floor(GRID_WIDTH / 2)
    local centerRow = math.floor(roomHeight / 2)
    local targetIndex = (centerRow + 2) * GRID_WIDTH + centerColumn

    if targetIndex < 0 or targetIndex >= gridSize then return end

    room:RemoveGridEntity(targetIndex, 0, false)
    room:SpawnGridEntity(
        targetIndex,
        mod.Grid.DavidPlate.Type,
        mod.Grid.DavidPlate.Var,
        0, 0
    )

    local grid = room:GetGridEntity(targetIndex)
    if grid then
        local spr = grid:GetSprite()
        spr:Load("gfx/grid/David_challenges/challengebutton.anm2", true)
        spr:Play("Off", true)
        DavidPlateIndex = targetIndex
    end
end


local function CheckDavidPlate()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end
    if not DavidPlateIndex then return end

    local room = Game():GetRoom()
    local grid = room:GetGridEntity(DavidPlateIndex)
    if not grid or grid:GetType() ~= mod.Grid.DavidPlate.Type then return end

    local spr = grid:GetSprite()

    if player.Position:Distance(grid.Position) < 20 and spr:GetAnimation() == "Off" then
        spr:Play("Switched", true)
    end

    if spr:IsPlaying("Switched") and spr:GetFrame() == 0 then
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
    end

    if spr:IsFinished("Switched") then
        spr:Play("On", true)

        if not DavidBackdropSpawned then
            if not DavidFloorFrame then
                DavidFloorFrame = GetUniqueDavidFrame()
            end

            local effectPos = room:GetCenterPos() + Vector(-15, -40)
            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, 0, 0, effectPos, Vector.Zero, nil)
            effect:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)

            local eSpr = effect:GetSprite()
            eSpr:Load("gfx/grid/David_challenges/challenges.anm2", true)
            eSpr:Play("Idle", true)
            eSpr:SetFrame(DavidFloorFrame)

            DavidBackdropSpawned = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CheckDavidPlate)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local game = Game()
    local level = game:GetLevel()

    local newFloor = level:GetStage()
    if DavidFloorID ~= newFloor then
        DavidFloorID = newFloor
        DavidFloorFrame = nil
    end

    DavidBackdropSpawned = false
    AddEventPlateInStartRoom(Isaac.GetPlayer(0))
end)

return DavidChallenges
