local SkullCrasher = {}
SkullCrasher.COLLECTIBLE_ID = Isaac.GetItemIdByName("Skull Crasher")

local game = Game()

-- Skull-type enemies to be affected when invulnerable
local SKULL_ENEMIES = {
    [EntityType.ENTITY_HOST] = true,         -- 27
    [EntityType.ENTITY_HARD_HOST] = true,    -- 27.3
    [EntityType.ENTITY_MOBILE_HOST] = true,  -- 204
    [EntityType.ENTITY_FLOAST] = true        -- 859
}

-- Returns true if the enemy is currently in its invulnerable state
local function IsClosedSkullEnemy(npc)
    if npc.Type == EntityType.ENTITY_HOST or npc.Type == EntityType.ENTITY_MOBILE_HOST then
        return npc.State == 8 -- Head-down closed state
    elseif npc.Type == EntityType.ENTITY_HARD_HOST then
        return npc.State == 10 -- Invulnerable state
    elseif npc.Type == EntityType.ENTITY_FLOAST then
        return npc.State == 8 -- Floast hides similarly
    end
    return false
end

function SkullCrasher:OnNPCUpdate(npc)
    if not npc or not npc:Exists() then return end

    -- Only check skull enemies
    if not SKULL_ENEMIES[npc.Type] then return end

    if IsClosedSkullEnemy(npc) then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(SkullCrasher.COLLECTIBLE_ID) then
                -- Only apply damage every 15 frames
                if npc.FrameCount % 15 == 0 then
                    npc:TakeDamage(1, DamageFlag.DAMAGE_IGNORE_ARMOR | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(player), 0)
                    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, Vector.Zero, npc)
                    poof.Color = Color(1, 0.1, 0.1, 1, 0, 0, 0)
                end
            end
        end
    end
end

-- Initialization
function SkullCrasher:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, SkullCrasher.OnNPCUpdate)

    if EID then
        EID:addCollectible(
            SkullCrasher.COLLECTIBLE_ID,
            "Allows you to damage skull-based enemies (Hosts, Hard Hosts, Mobile Hosts, and Floasts) even when invulnerable.",
            "Skull Crasher",
            "en_us"
        )
    end
end

return SkullCrasher
