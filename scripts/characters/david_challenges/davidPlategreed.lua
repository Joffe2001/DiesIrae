local mod = DiesIraeMod
local game = Game()

DavidPlatesGreed = DavidPlatesGreed or {}
UsedChallengesGreed = UsedChallengesGreed or {}

local function RestoreBackdropGreed(plateData)
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
local function SpawnDavidPlateGreed(player)
    if player:GetPlayerType() ~= mod.Players.David then return end
    if not game:IsGreedMode() then return end

    local level = game:GetLevel()
    local stage = level:GetStage()
    if not stage then return end
    local room = game:GetRoom()
    local roomIndex = level:GetCurrentRoomIndex()
    local currentFloor = stage

    if mod:GetCompletedDavidChallengeCount() >= 4 then return end

    DavidPlatesGreed[currentFloor] = DavidPlatesGreed[currentFloor] or {}

    -- Already exists
    if DavidPlatesGreed[currentFloor][roomIndex] then
        local plateData = DavidPlatesGreed[currentFloor][roomIndex]
        local grid = room:GetGridEntity(plateData.index)
        if grid then
            grid:GetSprite():Play(plateData.state, true)
        end
        RestoreBackdropGreed(plateData)
        return
    end

    local gridSize = room:GetGridSize()
    if gridSize == 0 then return end
    local targetIndex = math.floor(gridSize / 2)

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

    DavidPlatesGreed[currentFloor][roomIndex] = {
        index = targetIndex,
        state = "Off",
        challengeVariant = nil,
        wasPressed = false,
        missed = false,
        backdrop = nil
    }
end

---@param player EntityPlayer
local function CheckDavidPlateGreed(player)
    if player:GetPlayerType() ~= mod.Players.David then return end
    if not game:IsGreedMode() then return end

    local level = game:GetLevel()
    local stage = level:GetStage()
    if not stage then return end
    local currentFloor = stage
    local roomIndex = level:GetCurrentRoomIndex()

    local plateData =
        DavidPlatesGreed[currentFloor]
        and DavidPlatesGreed[currentFloor][roomIndex]

    if not plateData or plateData.missed then return end

    local room = game:GetRoom()
    local grid = room:GetGridEntity(plateData.index)
    if not grid then return end

    local distance = player.Position:Distance(room:GetGridPosition(plateData.index))
    local spr = grid:GetSprite()

    if distance < 35 then
        if plateData.state == "Off" then
            plateData.state = "Switched"
            spr:Play("Switched", true)
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)

        elseif plateData.state == "Switched" and not spr:IsPlaying("Switched") then
            plateData.state = "On"
            plateData.wasPressed = true
            spr:Play("On", true)

            if not plateData.challengeVariant then
                local available = {}
                for i = 1, 11 do
                    if i == 9 and (level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0) then
                        goto continue
                    end

                    if not UsedChallengesGreed[i] then
                        available[#available + 1] = i
                    end

                    ::continue::
                end

                if #available == 0 then return end

                plateData.challengeVariant = available[math.random(#available)]
                UsedChallengesGreed[plateData.challengeVariant] = true
            end

            RestoreBackdropGreed(plateData)
            mod:StartDavidChallenge(currentFloor, plateData.challengeVariant)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end
    if not game:IsGreedMode() then return end

    local level = game:GetLevel()
    local stage = level:GetStage()
    if not stage then return end
    local floor = stage
    local startRoom = level:GetStartingRoomIndex()
    local roomIndex = level:GetCurrentRoomIndex()

    local pdata = player:GetData()
    pdata.LastRoomIndexGreed = pdata.LastRoomIndexGreed or roomIndex

    local lastRoom = pdata.LastRoomIndexGreed
    pdata.LastRoomIndexGreed = roomIndex

    if lastRoom ~= startRoom or roomIndex == startRoom then return end

    local plateData = DavidPlatesGreed[floor] and DavidPlatesGreed[floor][startRoom]
    if not plateData or plateData.wasPressed then return end

    plateData.missed = true

    pdata.MissedPlateFloorsGreed = pdata.MissedPlateFloorsGreed or {}
    if pdata.MissedPlateFloorsGreed[floor] then return end

    pdata.MissedPlateFloorsGreed[floor] = true
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    SpawnDavidPlateGreed(Isaac.GetPlayer(0))
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    CheckDavidPlateGreed(Isaac.GetPlayer(0))
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    DavidPlatesGreed = {}
    UsedChallengesGreed = {}
end)
