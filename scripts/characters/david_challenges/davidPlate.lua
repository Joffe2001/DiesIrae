local mod = DiesIraeMod
local game = Game()

DavidPlates = DavidPlates or {}
UsedChallenges = UsedChallenges or {}

local DavidChallengeFloorRules = {
    [1] = {
        { stage = LevelStage.STAGE3_1},
        { stage = LevelStage.STAGE4_1},
    },
    [9] = {
        { stage = LevelStage.STAGE1_2},
        { stage = LevelStage.STAGE2_1},
        { stage = LevelStage.STAGE2_2},
        { stage = LevelStage.STAGE3_1},
    }
}

local function IsChallengeAllowedOnFloor(variant, stage, stageType)
    local rules = DavidChallengeFloorRules[variant]
    if not rules then
        return true
    end

    for _, rule in ipairs(rules) do
        if rule.stage == stage then
            if not rule.stageType or rule.stageType == stageType then
                return true
            end
        end
    end

    return false
end

local function RestoreBackdrop(plateData)
    if plateData.backdrop and plateData.backdrop:Exists() then
        return
    end

    local room = game:GetRoom()
    local frame = nil

    if plateData.wasPressed and plateData.challengeVariant then
        frame = plateData.challengeVariant
    elseif plateData.missed then
        frame = 0
    end

    if not frame then return end

    local effect = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        0,
        0,
        room:GetCenterPos() + Vector(-15, -40),
        Vector.Zero,
        nil
    )

    effect:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
    local spr = effect:GetSprite()
    spr:Load("gfx/grid/David_challenges/challenges.anm2", true)
    spr:Play("Idle", true)
    spr:SetFrame(frame)

    plateData.backdrop = effect
end

---@param player EntityPlayer
local function SpawnDavidPlate(player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local stage = level:GetStage()
    local room = game:GetRoom()
    local currentFloor = level:GetStage()
    local roomIndex = level:GetCurrentRoomIndex()

    if mod:GetCompletedDavidChallengeCount() >= 4
    or stage > LevelStage.STAGE4_2 then
        return
    end

    if currentFloor < 2 then return end
    if roomIndex ~= level:GetStartingRoomIndex() then return end

    DavidPlates[currentFloor] = DavidPlates[currentFloor] or {}

    if DavidPlates[currentFloor][roomIndex] then
        local plateData = DavidPlates[currentFloor][roomIndex]
        local grid = room:GetGridEntity(plateData.index)

        if not grid then
            room:RemoveGridEntity(plateData.index, 0, false)
            room:SpawnGridEntity(
                plateData.index,
                GridEntityType.GRID_DECORATION,
                4500,
                Random(),
                0
            )

            grid = room:GetGridEntity(plateData.index)
            if grid then
                local spr = grid:GetSprite()
                spr:Load("gfx/grid/David_challenges/challengebutton.anm2", true)
                spr:Play(plateData.state, true)
            end
        else
            grid:GetSprite():Play(plateData.state, true)
        end

        RestoreBackdrop(plateData)
        return
    end

    local GRID_WIDTH = 13
    local gridSize = room:GetGridSize()
    local roomHeight = math.floor(gridSize / GRID_WIDTH)
    local targetIndex =
        (math.floor(roomHeight / 2) + 2) * GRID_WIDTH
        + math.floor(GRID_WIDTH / 2)

    if targetIndex < 0 or targetIndex >= gridSize then return end

    room:RemoveGridEntity(targetIndex, 0, false)
    room:SpawnGridEntity(
        targetIndex,
        GridEntityType.GRID_DECORATION,
        4500,
        Random(),
        0
    )

    local grid = room:GetGridEntity(targetIndex)
    if grid then
        local spr = grid:GetSprite()
        spr:Load("gfx/grid/David_challenges/challengebutton.anm2", true)
        spr:Play("Off", true)
    end

    DavidPlates[currentFloor][roomIndex] = {
        index = targetIndex,
        state = "Off",
        challengeVariant = nil, -- 1–11
        wasPressed = false,
        missed = false,
        backdrop = nil
    }
end

---@param player EntityPlayer
local function CheckDavidPlate(player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local currentFloor = level:GetStage()
    local roomIndex = level:GetCurrentRoomIndex()

    local plateData =
        DavidPlates[currentFloor]
        and DavidPlates[currentFloor][roomIndex]

    if not plateData then return end

    if plateData.missed then
        return
    end
    
    local room = game:GetRoom()
    local grid = room:GetGridEntity(plateData.index)
    if not grid then return end

    local distance =
        player.Position:Distance(room:GetGridPosition(plateData.index))
    local spr = grid:GetSprite()

    if distance < 35 then
        if plateData.state == "Off" then
            plateData.state = "Switched"
            spr:Play("Switched", true)
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)

        elseif plateData.state == "Switched"
            and not spr:IsPlaying("Switched") then

            plateData.state = "On"
            plateData.wasPressed = true
            spr:Play("On", true)

            if not plateData.challengeVariant then
                local level = game:GetLevel()
                local stage = level:GetStage()
                local stageType = level:GetStageType()
            
                local available = {}
                for i = 1, 11 do
                    if i == 9 and (level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0) then
                        goto continue
                    end
            
                    if not UsedChallenges[i]
                        and IsChallengeAllowedOnFloor(i, stage, stageType)
                    then
                        available[#available + 1] = i
                    end

                    ::continue::
                end
            
                if #available == 0 then return end
            
                plateData.challengeVariant =
                    available[math.random(#available)]
                UsedChallenges[plateData.challengeVariant] = true
            end

            RestoreBackdrop(plateData)
            mod:StartDavidChallenge(
                currentFloor,
                plateData.challengeVariant
            )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end

    local level = game:GetLevel()
    local floor = level:GetStage()
    local startRoom = level:GetStartingRoomIndex()
    local roomIndex = level:GetCurrentRoomIndex()

    if floor < 2 then return end

    local pdata = player:GetData()
    pdata.LastRoomIndex = pdata.LastRoomIndex or roomIndex

    local lastRoom = pdata.LastRoomIndex
    pdata.LastRoomIndex = roomIndex

    if lastRoom ~= startRoom then return end
    if roomIndex == startRoom then return end

    local plateData =
        DavidPlates[floor]
        and DavidPlates[floor][startRoom]

    if not plateData or plateData.wasPressed then return end

    plateData.missed = true

    pdata.MissedPlateFloors = pdata.MissedPlateFloors or {}
    if pdata.MissedPlateFloors[floor] then return end

    pdata.MissedPlateFloors[floor] = true
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    SpawnDavidPlate(Isaac.GetPlayer(0))
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    CheckDavidPlate(Isaac.GetPlayer(0))
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    DavidPlates = {}
    UsedChallenges = {}
end)