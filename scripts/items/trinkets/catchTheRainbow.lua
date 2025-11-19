local CatchTheRainbow = {}
CatchTheRainbow.TRINKET_ID = DiesIraeMod.Trinkets.CatchTheRainbow
local game = Game()

local BASE_CHANCE   = 1 -- 2%
local GOLDEN_CHANCE = 1 -- 5%

local processed = {}

local function getChanceAndRNG()
    local bestChance = 0
    local bestRNG = nil
    for i = 0, game:GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(i)
        if p:HasTrinket(CatchTheRainbow.TRINKET_ID) then
            local mult = p:GetTrinketMultiplier(CatchTheRainbow.TRINKET_ID)
            local chance = (mult > 1) and GOLDEN_CHANCE or BASE_CHANCE
            if chance > bestChance then
                bestChance = chance
                bestRNG = p:GetTrinketRNG(CatchTheRainbow.TRINKET_ID)
            end
        end
    end
    return bestChance, bestRNG
end

local function tryConvertPoopAtIndex(room, idx, chance, rng)
    if processed[idx] then return end
    local grid = room:GetGridEntity(idx)
    if grid and grid:GetType() == GridEntityType.GRID_POOP then
        local poop = grid:ToPoop()
        if poop and poop:GetVariant() == 0 then 
            processed[idx] = true
            if rng and rng:RandomFloat() < chance then
                local pos = room:GetGridPosition(idx)
                room:RemoveGridEntity(idx, 0, false)
                room:SpawnGridEntity(idx, GridEntityType.GRID_POOP, 2, Random(), 0)
                SFXManager():Play(SoundEffect.SOUND_PLOP, 1.0, 0, false, 1.0)
            end
        else
            processed[idx] = true 
        end
    end
end

function CatchTheRainbow:onNewRoom()
    processed = {}
    local room = game:GetRoom()
    local chance, rng = getChanceAndRNG()
    if chance <= 0 then return end

    for i = 0, room:GetGridSize() - 1 do
        tryConvertPoopAtIndex(room, i, chance, rng)
    end
end

function CatchTheRainbow:onUpdate()
    local room = game:GetRoom()
    local chance, rng = getChanceAndRNG()
    if chance <= 0 then return end

    for i = 0, room:GetGridSize() - 1 do
        if not processed[i] then
            tryConvertPoopAtIndex(room, i, chance, rng)
        end
    end
end

function CatchTheRainbow:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() CatchTheRainbow:onNewRoom() end)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE,   function() CatchTheRainbow:onUpdate() end)
end

return CatchTheRainbow
