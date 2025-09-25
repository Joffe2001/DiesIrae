local SlaughterToPrevail = {}
SlaughterToPrevail.COLLECTIBLE_ID = Isaac.GetItemIdByName("Slaughter to Prevail")
local game = Game()

-- Balance values
local DAMAGE_INCREASE = 0.01
local MAX_KILLS_PER_ROOM = 10 -- Cap the number of kills per room

-- Track the number of kills per room
local killsThisRoom = 0

-- Helper function to increase damage with a 50% chance
local function increaseDamage(player)
    -- 50% chance to increase damage
    if math.random() < 0.5 then
        player.Damage = player.Damage + DAMAGE_INCREASE
        player:EvaluateItems()  -- Recalculate the player's stats
        
        -- Optional: Play sound or effect to indicate the damage increase
        SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1.0, 0, false, 1.0)
        Isaac.DebugString("Slaughter to Prevail: Damage increased by +0.01")
    end
end

-- Callback when an enemy is killed
function SlaughterToPrevail:onKillEntity(entity)
    -- Ensure the entity is an enemy and not a boss, and exclude entities that spawn others
    if entity:IsVulnerableEnemy() and not entity:IsBoss() and not entity.SpawnsEnemy then
        -- Get the player who killed the enemy
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(SlaughterToPrevail.COLLECTIBLE_ID) then
                -- Only trigger the effect if the kill count is under the cap
                if killsThisRoom < MAX_KILLS_PER_ROOM then
                    -- Increase the player's damage with a 50% chance
                    increaseDamage(player)
                    killsThisRoom = killsThisRoom + 1
                end
            end
        end
    end
end

-- Reset kill counter when entering a new room
function SlaughterToPrevail:OnNewRoom()
    killsThisRoom = 0
end

-- Initialize the item
function SlaughterToPrevail:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, SlaughterToPrevail.onKillEntity)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SlaughterToPrevail.OnNewRoom)

    if EID then
        EID:addCollectible(
            SlaughterToPrevail.COLLECTIBLE_ID,
            "On enemy kill, 50% chance to increase Isaac's damage by +0.01. (Max 10 kills per room)",
            "Slaughter to Prevail",
            "en_us"
        )
    end
end

return SlaughterToPrevail
