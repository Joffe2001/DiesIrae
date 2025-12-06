local mod = DiesIraeMod
local David = {}

local DavidPlateIndex = nil
local DavidBackdropSpawned = false

local DAMAGE_MODIFIER = 1
local SPEED_MODIFIER = 0.2
local TEAR_DELAY_MODIFIER = 1
local LUCK_MODIFIER = 1

function David:TearGFXApply(tear)
    if not (tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() 
        and tear.SpawnerEntity:ToPlayer():GetPlayerType() == mod.Players.David) then return end
    tear:GetSprite():ReplaceSpritesheet(0, "gfx/proj/music_tears.png", true)
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, David.TearGFXApply)

function David:OnPlayerInit(player)
    if player:GetPlayerType() ~= mod.Players.David then return end
    player:AddCollectible(mod.Items.SlingShot)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, David.OnPlayerInit)

function David:OnEvaluateCache(player, flag)
    if player:GetPlayerType() ~= mod.Players.David then return end

    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + DAMAGE_MODIFIER
    elseif flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + SPEED_MODIFIER
    elseif flag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = math.max(1, player.MaxFireDelay + TEAR_DELAY_MODIFIER)
    elseif flag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + LUCK_MODIFIER
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, David.OnEvaluateCache)

function David:OnEntityTakeDamage(entity, amount, flags, source, countdown)
    local player = source.Entity and source.Entity:ToPlayer()
    if not player then return end

    if player:GetPlayerType() == mod.Players.David
       and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        local npc = entity:ToNPC()
        if npc and npc:IsBoss() then
            return amount * 2
        end
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, David.OnEntityTakeDamage)

local function AddPressurePlateInStartRoom(player)
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

    local offsetX = 0  
    local offsetY = 2  

    local targetColumn = centerColumn + offsetX
    local targetRow    = centerRow + offsetY

    local targetIndex = targetRow * GRID_WIDTH + targetColumn

    if targetIndex < 0 or targetIndex >= gridSize then return end

    if not room:GetGridEntity(targetIndex) then
        room:SpawnGridEntity(targetIndex, GridEntityType.GRID_PRESSURE_PLATE, 0, 0, 0)
        local grid = room:GetGridEntity(targetIndex)
        if grid then
            local spr = grid:GetSprite()
            spr:Load("gfx/grid/David_challenges/challengebutton.anm2", true)
            spr:Play("Off", true)
            DavidPlateIndex = targetIndex
        end
    end
end

local function CheckDavidPlate()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() ~= mod.Players.David then return end
    local room = Game():GetRoom()

    if not DavidPlateIndex then return end
    local grid = room:GetGridEntity(DavidPlateIndex)
    if not grid or grid:GetType() ~= GridEntityType.GRID_PRESSURE_PLATE then return end

    if grid:GetSprite():GetAnimation() == "On" and not DavidBackdropSpawned then
        local roomCenter = room:GetCenterPos()
        local effectPos = roomCenter + Vector(-15, -40)
        local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, 0, 0, effectPos, Vector(0,0), nil)
        effect:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
        local eSpr = effect:GetSprite()
        eSpr:Load("gfx/grid/David_challenges/challenges.anm2", true)
        eSpr:Play("Idle", true)
        eSpr:SetFrame(math.random(0,8))
        DavidBackdropSpawned = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CheckDavidPlate)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    AddPressurePlateInStartRoom(Isaac.GetPlayer(0))
    DavidBackdropSpawned = false
end)

if EID then
    local icons = Sprite("gfx/ui/eid/david_eid.anm2", true)
    EID:addIcon("Player"..mod.Players.David, "David", 0, 16, 16, 0, 0, icons)
    EID:addBirthright(mod.Players.David, "David deals double damage to bosses.", "David")
end
