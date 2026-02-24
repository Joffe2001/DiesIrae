---@class ModReference
local mod = DiesIraeMod
local game = Game()
local stillStanding = {}

mod.CollectibleType.COLLECTIBLE_STILL_STANDING = Isaac.GetItemIdByName("Still Standing")

local DAMAGE_STEP = 0.2
local STAND_INTERVAL = 30
local DECAY_RATE = 0.5

function stillStanding:StillStanding_Update(player)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_STILL_STANDING) then return end

    local data = player:GetData()
    data.standTimer = data.standTimer or 0
    data.lastPos = data.lastPos or player.Position
    data.damageBonus = data.damageBonus or 0

    local baseDamage = player.Damage - data.damageBonus
    local maxBonus = baseDamage 

    if player.Position:DistanceSquared(data.lastPos) < 0.01 then
        data.standTimer = data.standTimer + 1

        if data.standTimer % STAND_INTERVAL == 0 then
            if data.damageBonus < maxBonus then
                data.damageBonus = math.min(data.damageBonus + DAMAGE_STEP, maxBonus)
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end
        end
    else
        if data.damageBonus > 0 then
            data.damageBonus = math.max(data.damageBonus - DECAY_RATE, 0)
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
        data.standTimer = 0
    end

    data.lastPos = player.Position
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, stillStanding.StillStanding_Update)

function stillStanding:StillStanding_EvaluateCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE and player:HasCollectible(mod.CollectibleType.COLLECTIBLE_STILL_STANDING) then
        local data = player:GetData()
        if data.damageBonus then
            player.Damage = player.Damage + data.damageBonus
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, stillStanding.StillStanding_EvaluateCache)
