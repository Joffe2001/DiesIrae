local mod = DiesIraeMod

local CreatineOverdose = {}

local BASE_BONUS = 0.2
local BONUS_MULT = 1.2

function CreatineOverdose:onEvaluateCache(player, cacheFlag)
    if not player:HasCollectible(mod.Items.CreatineOverdose) then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + BASE_BONUS

        local effectiveBase = player:GetData().CreatineBase or 3.5 
        local current = player.Damage

        local bonus = current - effectiveBase - BASE_BONUS
        if bonus > 0 then
            player.Damage = effectiveBase + BASE_BONUS + bonus * BONUS_MULT
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local queued = player.QueuedItem

        if queued and queued.Item and queued.Item.ID == mod.Items.CreatineOverdose then
            MusicManager():Play(mod.Music.GigaChad, 1.0, 0, false, 1.0)
            player:FlushQueueItem()
        end
    end
end)

function CreatineOverdose:onPlayerInit(player)
    player:GetData().CreatineBase = player.Damage
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CreatineOverdose.onEvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, CreatineOverdose.onPlayerInit)

