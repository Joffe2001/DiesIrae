local RedCompass = {}
RedCompass.COLLECTIBLE_ID = Isaac.GetItemIdByName("Red Compass")

local game = Game()
local RED_ROOM_OPEN_CHANCE = 0.25 -- 25% chance per cleared room

-- Called after a room is cleared
function RedCompass:OnRoomClear()
    local level = game:GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    if not roomDesc then return end

    local roomIndex = roomDesc.SafeGridIndex
    local roomShape = roomDesc.Data.Shape
    local rng = RNG()
    rng:SetSeed(roomIndex + RedCompass.COLLECTIBLE_ID, 35)

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(RedCompass.COLLECTIBLE_ID) then

            -- Roll chance
            if rng:RandomFloat() < RED_ROOM_OPEN_CHANCE then
                -- Try to open a red room in one of the 4 directions
                local triedDirs = {}

                for attempt = 1, 4 do
                    local dir = rng:RandomInt(4)
                    while triedDirs[dir] do
                        dir = (dir + 1) % 4
                    end
                    triedDirs[dir] = true

                    local success = level:TryUnlockRedRoomDoor(roomIndex, dir, true)
                    if success then
                        -- Optional: visual feedback
                        local doorPos = game:GetRoom():GetDoorSlotPosition(dir)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, doorPos, Vector.Zero, nil)
                        SFXManager():Play(SoundEffect.SOUND_RED_KEY_SLOT, 1.0)
                        break
                    end
                end
            end
        end
    end
end

function RedCompass:Init(mod)
    mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, function(_, sfx)
        -- Prevent red key charge sound spam (optional)
        if sfx == SoundEffect.SOUND_REDLIGHTNING_ZAP then
            return true
        end
    end)

    mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, function(_, type, variant, subtype, pos, vel, spawner, seed)
        -- Prevent red key pickups from spawning naturally (optional safeguard)
        if type == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_TAROTCARD and subtype == Card.CARD_CRACKED_KEY then
            return { type, variant, 0, pos, vel, spawner, seed }
        end
    end)

    mod:AddCallback(ModCallbacks.MC_PRE_ROOM_CLEAR, function()
        RedCompass:OnRoomClear()
    end)

    -- EID Support
    if EID then
        EID:addCollectible(
            RedCompass.COLLECTIBLE_ID,
            "Upon clearing a room, has a chance to open a nearby red room.",
            "Red Compass",
            "en_us"
        )
    end
end

return RedCompass
