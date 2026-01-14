local mod = DiesIraeMod
local game = Game()

local CHORD_DROP_CHANCE = 0.5
local CHORD_LIFETIME = 12
local REQUIRED_CHORDS = 10
local CollectedChords = 0

local CHALLENGE_COLLECT_CHORDS = 8

local function IsChallengeActive()
    local floor = game:GetLevel():GetStage()
    return mod:IsDavidChallengeActive(floor) and mod:GetDavidChallengeVariant(floor) == CHALLENGE_COLLECT_CHORDS
end

-- Reset CollectedChords when the game starts or continues
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        CollectedChords = 0
    end
end)

-- Reset CollectedChords for each new level
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if IsChallengeActive() then
        CollectedChords = 0
    end
end)

-- Chord drops on enemy death
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsActiveEnemy(false) or npc:IsBoss() then return end
    if not IsChallengeActive() then return end

    local rng = RNG()
    rng:SetSeed(npc.InitSeed, 1)
    if rng:RandomFloat() >= CHORD_DROP_CHANCE then return end

    -- Spawn the David Chord pickup
    local pickup = Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        mod.Entities.PICKUP_DavidChord.Var,
        0,
        npc.Position,
        Vector.Zero,
        nil
    )

    -- Set a timeout to make the chord disappear after a set time
    local data = pickup:GetData()
    data.ChordTimer = CHORD_LIFETIME
    data.ChordActive = true

    -- Get the sprite for the chord and play the "Appear" animation first
    local sprite = pickup:GetSprite()
    sprite:Play("Appear", true)

    -- Play the soul pickup sound effect
    sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1.0, 0, false, 1.0)
end)

-- Handle the chord's timer and removal
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if pickup.Variant ~= mod.Entities.PICKUP_DavidChord.Var then return end

    local data = pickup:GetData()
    if not data.ChordActive then return end

    -- Decrease the timer and check if the chord should be removed
    data.ChordTimer = data.ChordTimer - 1
    if data.ChordTimer <= 0 then
        pickup:Remove()
    end

    -- Monitor the "Appear" animation and transition to "Disappear" after it ends
    local sprite = pickup:GetSprite()
    if sprite:IsFinished("Appear") then
        -- Once "Appear" finishes, play the "Disappear" animation
        sprite:Play("Disappear", true)

        -- Once "Disappear" finishes, remove the pickup
        if sprite:IsFinished("Disappear") then
            pickup:Remove()
        end
    end
end)

-- Handle collision with the chord for collection (only for David)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.Variant ~= mod.Entities.PICKUP_DavidChord.Var then return end

    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= mod.Players.David then
        return true
    end

    -- Remove the chord and update the collected count
    pickup:Remove()
    CollectedChords = CollectedChords + 1

    -- Complete challenge when enough chords are collected
    if CollectedChords >= REQUIRED_CHORDS then
        mod:CompleteDavidChallenge()
    end

    return true
end)