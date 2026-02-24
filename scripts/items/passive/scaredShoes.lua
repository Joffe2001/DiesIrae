local mod = DiesIraeMod
local ScaredShoes = {}
local game = Game()

mod.CollectibleType.COLLECTIBLE_SCARED_SHOES = Isaac.GetItemIdByName("Scared Shoes")

local PEECREEP_CHANCE = 0.10    
local PEECREEP_INTERVAL = 15     
local PEECREEP_TIMEOUT = 45     
local PEECREEP_SCALE = 1.5     

ScaredShoes.peeTimers = {}       
local shouldBoostSpeed = {}  

function ScaredShoes:OnPlayerUpdate(player)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_SCARED_SHOES) then return end

    local rng = player:GetCollectibleRNG(mod.CollectibleType.COLLECTIBLE_SCARED_SHOES)
    local id = rng:GetSeed()
    local room = game:GetRoom()

    shouldBoostSpeed[id] = room:IsClear()
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:EvaluateItems()

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
                if creep== nil then return end

                creep.Scale = PEECREEP_SCALE
                creep.Timeout = PEECREEP_TIMEOUT
                creep:Update()
            end
        end
    else
        ScaredShoes.peeTimers[id] = 0
    end
end

function ScaredShoes:OnEvaluateCache(player, cacheFlag)
    if cacheFlag ~= CacheFlag.CACHE_SPEED then return end
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_SCARED_SHOES) then return end

    local rng = player:GetCollectibleRNG(mod.CollectibleType.COLLECTIBLE_SCARED_SHOES)
    local id = rng:GetSeed()

    if shouldBoostSpeed[id] then
        local boost = math.max(0, 2.0 - player.MoveSpeed)
        player.MoveSpeed = player.MoveSpeed + boost
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ScaredShoes.OnPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ScaredShoes.OnEvaluateCache)
