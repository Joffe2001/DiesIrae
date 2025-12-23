local mod = DiesIraeMod
local game = Game()

DavidPlates = DavidPlates or {}
UsedChallenges = UsedChallenges or {}


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
    local room = game:GetRoom()
    local currentFloor = level:GetStage()
    local roomIndex = level:GetCurrentRoomIndex()

    if currentFloor < 2 then return end
    if roomIndex ~= level:GetStartingRoomIndex() then return end

    DavidPlates[currentFloor] = DavidPlates[currentFloor] or {}

    if DavidPlates[currentFloor][roomIndex] then
        local plateData = DavidPlates[currentFloor][roomIndex]
        local grid = room:GetGridEntity(plateData.index)

        if grid then
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
        challengeVariant = nil, -- 1–9
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
                local available = {}
                for i = 1, 9 do
                    if not UsedChallenges[i] then
                        available[#available + 1] = i
                    end
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
