local ScaredShoes = {}
ScaredShoes.COLLECTIBLE_ID = Isaac.GetItemIdByName("Scared Shoes")
local game = Game()


-- Constants
local PEECREEP_CHANCE = 0.10      -- 10% chance
local PEECREEP_INTERVAL = 15      -- Every 15 frames 
local PEECREEP_TIMEOUT = 45       -- Creep duration 
local PEECREEP_SCALE = 1.5      -- Smaller puddle

-- Internal tracking
ScaredShoes.peeTimers = {}        -- Tracks frame counts for pee spawn per player
local shouldBoostSpeed = {}       -- Flags whether speed boost is active for player

-- Called every frame for each player
function ScaredShoes:OnPlayerUpdate(player)
    if not player:HasCollectible(ScaredShoes.COLLECTIBLE_ID) then return end

    local rng = player:GetCollectibleRNG(ScaredShoes.COLLECTIBLE_ID)
    local id = rng:GetSeed()
    local room = game:GetRoom()

    -- Speed boost logic (when room is clear)
    shouldBoostSpeed[id] = room:IsClear()
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:EvaluateItems()

    -- Pee creep logic (when in combat)
    if not room:IsClear() then
        ScaredShoes.peeTimers[id] = (ScaredShoes.peeTimers[id] or 0) + 1

        if ScaredShoes.peeTimers[id] >= PEECREEP_INTERVAL then
            ScaredShoes.peeTimers[id] = 0

            if rng:RandomFloat() < PEECREEP_CHANCE then
                local offset = Vector(rng:RandomFloat() * 20 - 10, rng:RandomFloat() * 20 - 10)
                local creep = Isaac.Spawn(
                    EntityType.ENTITY_EFFECT,
                    EffectVariant.PLAYER_CREEP_LEMON_MISHAP,
                    0,
                    player.Position + offset,
                    Vector(0, 0),
                    player
                ):ToEffect()

                creep.Scale = PEECREEP_SCALE
                creep.Timeout = PEECREEP_TIMEOUT
                creep:Update()
            end
        end
    else
        ScaredShoes.peeTimers[id] = 0
    end
end

-- Speed boost logic
function ScaredShoes:OnEvaluateCache(player, cacheFlag)
    if cacheFlag ~= CacheFlag.CACHE_SPEED then return end
    if not player:HasCollectible(ScaredShoes.COLLECTIBLE_ID) then return end

    local rng = player:GetCollectibleRNG(ScaredShoes.COLLECTIBLE_ID)
    local id = rng:GetSeed()

    if shouldBoostSpeed[id] then
        local boost = math.max(0, 2.0 - player.MoveSpeed)
        player.MoveSpeed = player.MoveSpeed + boost
    end
end

-- Initialization function (call this from main.lua)
function ScaredShoes:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ScaredShoes.OnPlayerUpdate)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ScaredShoes.OnEvaluateCache)

    if EID then
        EID:addCollectible(
            ScaredShoes.COLLECTIBLE_ID,
            "↑ Sets speed to 2.0 when no enemies are alive#Spawns random small pee creep during combat",
            "Scared Shoes",
            "en_us"
        )
    end
end

return ScaredShoes
