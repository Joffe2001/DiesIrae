local mod = DiesIraeMod
local game = Game()

mod.CollectibleType.COLLECTIBLE_HIT_LIST = Isaac.GetItemIdByName("Hit List")

local HitList = {}
local EnemyKillBonus = {}


function HitList:OnGameStart(isContinued)
    EnemyKillBonus = {}
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, HitList.OnGameStart)

function HitList:OnCollectibleAdded(player, collectibleType, rng, something1, something2, something3)
    if collectibleType ~= mod.CollectibleType.COLLECTIBLE_HIT_LIST then return end

    EnemyKillBonus = {}

    local room = game:GetRoom()
    local candidates = {}

    for _, e in ipairs(Isaac.GetRoomEntities()) do
        if e:IsActiveEnemy(false) and not e:IsBoss() then
            table.insert(candidates, e)
        end
    end
    if #candidates > 0 then
        local chosen = candidates[math.random(#candidates)]
        local spawnPos = chosen.Position
        Isaac.Spawn(chosen.Type, chosen.Variant, chosen.SubType, spawnPos, Vector(0,0), player)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, HitList.OnCollectibleAdded)

function HitList:OnEnemyDeath(entity)
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_HIT_LIST) then return end
    if not entity:IsActiveEnemy(false) or entity:IsBoss() then return end

    local id = entity.Type .. "_" .. entity.Variant
    EnemyKillBonus[id] = (EnemyKillBonus[id] or 0) + 0.2

    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, HitList.OnEnemyDeath)

function HitList:OnCache(player, flag)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_HIT_LIST) then return end
    if flag == CacheFlag.CACHE_DAMAGE then
        local totalBonus = 0
        for _, bonus in pairs(EnemyKillBonus) do
            totalBonus = totalBonus + bonus
        end
        player.Damage = player.Damage + totalBonus
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, HitList.OnCache)
