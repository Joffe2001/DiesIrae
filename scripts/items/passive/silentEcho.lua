local mod = DiesIraeMod
local game = Game()

local SilentEcho = {}

function SilentEcho:OnNewRoom()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()

        if player:HasCollectible(mod.Items.SilentEcho) then
            if not data.SilentEchoUsedThisRoom then
                data.SilentEchoUsedThisRoom = true

                local activeItem = player:GetActiveItem()
                if activeItem ~= 0 then
                    player:UseActiveItem(activeItem, UseFlag.USE_NOCOSTUME)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SilentEcho.OnNewRoom)

function SilentEcho:OnUpdate()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()

        if not player:IsFrameDelayed() then
            data.SilentEchoUsedThisRoom = nil
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, SilentEcho.OnUpdate)
