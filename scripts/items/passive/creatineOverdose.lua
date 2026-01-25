local mod = DiesIraeMod

local CreatineOverdose = {}

function CreatineOverdose:onPostUpdate()
    local game = Game()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local queued = player.QueuedItem

        if queued and queued.Item and queued.Item.ID == mod.Items.CreatineOverdose then
            MusicManager():Play(mod.Music.GigaChad, 1.0, 0, false, 1.0)
            player:FlushQueueItem()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, CreatineOverdose.onPostUpdate)
