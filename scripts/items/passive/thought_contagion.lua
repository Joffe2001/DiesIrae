local ThoughtContagion = {}
ThoughtContagion.COLLECTIBLE_ID = Isaac.GetItemIdByName("Thought Contagion")
local game = Game()

-- Tuning
local DAMAGE_SHARE_RADIUS  = 80    -- pixels
local DAMAGE_SHARE_PERCENT = 0.75    

-- Helper: does any player have the item?
local function AnyPlayerHasItem()
    local num = game:GetNumPlayers()
    for i = 0, num - 1 do
        local p = Isaac.GetPlayer(i)
        if p:HasCollectible(ThoughtContagion.COLLECTIBLE_ID) then
            return true, p
        end
    end
    return false, nil
end

-- Damage spread (one hop, no status effects)
function ThoughtContagion:OnEntityDamage(entity, amount, flags, source, countdown)
    -- Only proceed if some player holds the item
    local hasItem, owner = AnyPlayerHasItem()
    if not hasItem then return end

    local npc = entity:ToNPC()
    if not npc then return end
    if not npc:IsVulnerableEnemy() then return end
    if npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
    if amount <= 0 then return end

    -- IMPORTANT: ignore our own mirrored damage to avoid infinite chaining
    if (flags & DamageFlag.DAMAGE_CLONES) ~= 0 then
        return
    end

    -- Find nearby enemies (excluding the one that was just hit)
    local victims = Isaac.FindInRadius(npc.Position, DAMAGE_SHARE_RADIUS, EntityPartition.ENEMY)
    if victims == nil or #victims == 0 then return end

    local shared = amount * DAMAGE_SHARE_PERCENT
    if shared <= 0 then return end

    -- Credit kills to the item owner if possible; otherwise, preserve original source
    local srcRef = owner and EntityRef(owner) or source

    for _, e in ipairs(victims) do
        if e.InitSeed ~= npc.InitSeed then
            local v = e:ToNPC()
            if v and v:IsVulnerableEnemy() and not v:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                -- Apply pure damage; mark as CLONES so our callback ignores it (no re-spread, no extra effects)
                v:TakeDamage(shared, flags | DamageFlag.DAMAGE_CLONES, srcRef, 0)
            end
        end
    end
end

function ThoughtContagion:Init(mod)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ThoughtContagion.OnEntityDamage)

    if EID then
        EID:addCollectible(
            ThoughtContagion.COLLECTIBLE_ID,
            "Enemies mirror damage they take to other nearby enemies.#Only pure damage is shared.",
            "Thought Contagion",
            "en_us"
        )
    end
end

return ThoughtContagion
