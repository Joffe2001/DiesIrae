local WhiteRoom = {}
WhiteRoom.COLLECTIBLE_ID = Isaac.GetItemIdByName("White Room")
local game = Game()
local sfx = game:GetSFX()

-- Passive: convert champions on spawn
function WhiteRoom:onNPCInit(npc)
    if not npc:IsChampion() then return end

    local hasWhiteRoom = false
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(WhiteRoom.COLLECTIBLE_ID) then
            hasWhiteRoom = true
            break
        end
    end
    if not hasWhiteRoom then return end

    npc:MakeChampion(0, -1, false)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, Vector(0,0), nil)
    sfx:Play(237, 1.0, 0, false, 1.0)
    game:ShakeScreen(5)
end

-- Active: convert all champions currently in the room
function WhiteRoom:onUseItem(item, rng, player, useFlags, slot, varData)
    if item ~= WhiteRoom.COLLECTIBLE_ID then return end

    local foundChampion = false

    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy() then
            local npc = entity:ToNPC()
            if npc then
                -- Check for Champion flag
                if npc:IsChampion() then
                    npc:MakeChampion(0, -1, false)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, Vector(0,0), nil)
                    sfx:Play(237, 1.0, 0, false, 1.0)
                    game:ShakeScreen(5)
                    foundChampion = true
                end
            end
        end
    end

    -- Play alternate sound if no champions were found
    if not foundChampion then
        sfx:Play(187, 1.0, 0, false, 1.0)
    end

    return true
end

-- Initialize callbacks and EID description
function WhiteRoom:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, WhiteRoom.onNPCInit)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, WhiteRoom.onUseItem)

    if EID then
        EID:addCollectible(
            WhiteRoom.COLLECTIBLE_ID,
            "Always convert champions to normal enemies.#Active: Convert all champions in the room with VFX/SFX.#If no champions are present, plays a different sound.",
            "White Room",
            "en_us"
        )
    end
end

return WhiteRoom
