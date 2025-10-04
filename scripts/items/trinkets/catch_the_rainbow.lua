local CatchTheRainbow = {}
CatchTheRainbow.TRINKET_ID = Enums.Trinkets.CatchTheRainbow
local game = Game()

-- Chances (set to 1.0 = 100% for testing)
local BASE_CHANCE   = 1 -- 2%
local GOLDEN_CHANCE = 1 -- 5%

-- Track which grid indices we’ve checked in the current room
local processed = {}

-- Get best chance & RNG based on players
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

-- Attempt to convert a poop at this grid index
local function tryConvertPoopAtIndex(room, idx, chance, rng)
    if processed[idx] then return end
    local grid = room:GetGridEntity(idx)
    if grid and grid:GetType() == GridEntityType.GRID_POOP then
        local poop = grid:ToPoop()
        if poop and poop:GetVariant() == 0 then -- normal poop only
            processed[idx] = true
            if rng and rng:RandomFloat() < chance then
                local pos = room:GetGridPosition(idx)
                room:RemoveGridEntity(idx, 0, false)
                room:SpawnGridEntity(idx, GridEntityType.GRID_POOP, 2, Random(), 0)
                SFXManager():Play(SoundEffect.SOUND_PLOP, 1.0, 0, false, 1.0)
            end
        else
            processed[idx] = true -- non-normal poop, don’t retry
        end
    end
end

-- Reset state and process all poops on room entry
function CatchTheRainbow:onNewRoom()
    processed = {}
    local room = game:GetRoom()
    local chance, rng = getChanceAndRNG()
    if chance <= 0 then return end

    for i = 0, room:GetGridSize() - 1 do
        tryConvertPoopAtIndex(room, i, chance, rng)
    end
end

-- Handle poops spawned during room (The Poop item, enemies, etc.)
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

-- Init
function CatchTheRainbow:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() CatchTheRainbow:onNewRoom() end)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE,   function() CatchTheRainbow:onUpdate() end)

    if EID then
        EID:addTrinket(
            CatchTheRainbow.TRINKET_ID,
            "Each {{Poop}} poop has a 2% chance to be {{RainbowPoop}} Rainbow.#{{GoldenTrinket}} Golden: 5%.",
            "Catch the Rainbow",
            "en_us"
        )
    end
end

return CatchTheRainbow
