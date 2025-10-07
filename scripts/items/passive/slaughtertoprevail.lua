local mod = DiesIraeMod

local SlaughterToPrevail = {}
local game = Game()

local DAMAGE_INCREASE = 0.01
local MAX_KILLS_PER_ROOM = 10 

local killsThisRoom = 0

local function increaseDamage(player)
    if math.random() < 0.5 then
        player.Damage = player.Damage + DAMAGE_INCREASE
        player:EvaluateItems()
        
        SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1.0, 0, false, 1.0)
        Isaac.DebugString("Slaughter to Prevail: Damage increased by +0.01")
    end
end


function SlaughterToPrevail:onKillEntity(entity)
    if entity:IsVulnerableEnemy() and not entity:IsBoss() and not entity.SpawnsEnemy then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(mod.Items.SlaughterToPrevail) then
                if killsThisRoom < MAX_KILLS_PER_ROOM then
                    increaseDamage(player)
                    killsThisRoom = killsThisRoom + 1
                end
            end
        end
    end
end

function SlaughterToPrevail:OnNewRoom()
    killsThisRoom = 0
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, SlaughterToPrevail.onKillEntity)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SlaughterToPrevail.OnNewRoom)
