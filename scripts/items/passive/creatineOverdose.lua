local mod = DiesIraeMod

local CreatineOverdose = {}

mod.CollectibleType.COLLECTIBLE_CREATINE_OVERDOSE = Isaac.GetItemIdByName("Creatine Overdose")

function CreatineOverdose:onPostUpdate()
    local game = Game()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local queued = player.QueuedItem

        if queued and queued.Item and queued.Item.ID == mod.CollectibleType.COLLECTIBLE_CREATINE_OVERDOSE then
            MusicManager():Play(mod.Music.GigaChad, 1.0, 0, false, 1.0)
            player:FlushQueueItem()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, CreatineOverdose.onPostUpdate)
