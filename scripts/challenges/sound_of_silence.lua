local SoundOfSilence = {}
local Enums = include("scripts.core.enums")
local CustomPills = include("scripts.items.pocketitems.custompills")
SoundOfSilence.ID = Enums.Challenges.SOUND_OF_SILENCE
local isSoundOfSilence = false

local MusicTears = nil
local success, mt = pcall(require, "scripts.core.music_tears") 
if success then
    MusicTears = mt
else
    print("[SoundOfSilence] MusicTears module not found.")
end

-- On Game Start
function SoundOfSilence:OnGameStart(isContinued)
    if not isContinued then
        if Isaac.GetChallenge() == SoundOfSilence.ID then
            isSoundOfSilence = true
            local player = Isaac.GetPlayer(0)  -- Get the player instance
            player:ClearPills()  -- Clear all pills
            player:AddPill(CustomPills.PILL_GULPING)  -- Add only the Gulping Pill
        else
            isSoundOfSilence = false
        end
    end
end

function SoundOfSilence:OnTearFire(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if player and player:GetPlayerType() == PlayerType.PLAYER_ISAAC and isSoundOfSilence then
        if MusicTears then
            MusicTears:Apply(tear) 
        end
    end
end

-- Initialize the mod and set callbacks
function SoundOfSilence:Init(mod)
    if MusicTears then
        mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, SoundOfSilence.OnTearFire)
    end

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
        SoundOfSilence:OnGameStart(isContinued)
    end)
end

return SoundOfSilence
