---@class ModReference
local mod = DiesIraeMod
local game = Game()

local BossTearBonuses = {}

function mod:PTSD_NewRoom()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.PTSD) then
            local room = game:GetRoom()
            if room:GetType() == RoomType.ROOM_BOSS then
                for _, entity in ipairs(Isaac.GetRoomEntities()) do
                    if entity:IsBoss() then
                        local bossType = entity.Type
                        local bossVariant = entity.Variant
                        local deaths = Isaac.GetPersistentGameData():GetBestiaryDeathCount(bossType, bossVariant)
                        BossTearBonuses[player.Index] = (BossTearBonuses[player.Index] or 0) + (0.2 * deaths)
                        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                        player:EvaluateItems()
                        break
                    end
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.PTSD_NewRoom)

function mod:PTSD_EvaluateCache(player, cacheFlag)
    if player:HasCollectible(mod.Items.PTSD) and cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local bonus = BossTearBonuses[player.Index] or 0
        if bonus > 0 then
            local baseTears = 30 / (player.MaxFireDelay + 1)
            local newTears = baseTears + bonus
            local newDelay = math.max(1, (30 / newTears) - 1)
            player.MaxFireDelay = newDelay
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.PTSD_EvaluateCache)
