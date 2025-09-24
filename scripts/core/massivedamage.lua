local MassiveDamage = {}
local json = require("json")
local rng = RNG()

-- These are the supported massive damage types
MassiveDamage.Types = {
    BOSSES = "Bosses",
    MINI_BOSSES = "MiniBosses",
    CHAMPIONS = "Champions",
    REGULARS = "Regulars",
    MONEY_TAKERS = "MoneyTakers",
    ENDGAME = "EndgameBosses",
    SPIDERS = "Spiders",
    GHOSTS = "Ghosts",
    FLIES = "Flies",
    WORMS = "Worms",
    HUMANOIDS = "Humanoids"
}

-- MAPPING: EntityType/Variant to Massive Damage Type
-- This is where you define which entities belong to which category.
-- This is the "manual labor" you mentioned, but it's done once here for clarity.
local ENTITY_MAPPING = {
    -- Mini Bosses
    [EntityType.ENTITY_MINIBOSS] = MassiveDamage.Types.MINI_BOSSES,
    [EntityType.ENTITY_MINISTRO] = MassiveDamage.Types.MINI_BOSSES,
    -- Spiders
    [EntityType.ENTITY_SPIDER] = MassiveDamage.Types.SPIDERS,
    [EntityType.ENTITY_DIP] = MassiveDamage.Types.SPIDERS,
    [EntityType.ENTITY_GAPER] = MassiveDamage.Types.SPIDERS, 
    -- Flies
    [EntityType.ENTITY_ATTACKFLY] = MassiveDamage.Types.FLIES,
    [EntityType.ENTITY_FLY] = MassiveDamage.Types.FLIES,
    -- Ghosts
    [EntityType.ENTITY_ATTACKFLY .. "_10"] = MassiveDamage.Types.GHOSTS, 
    [EntityType.ENTITY_HAUNT] = MassiveDamage.Types.GHOSTS,
    -- Worms
    [EntityType.ENTITY_TWISTED] = MassiveDamage.Types.WORMS,
    [EntityType.ENTITY_WORM] = MassiveDamage.Types.WORMS,
    [EntityType.ENTITY_FISTULA] = MassiveDamage.Types.WORMS,
    -- Humanoids
    [EntityType.ENTITY_KEEPER] = MassiveDamage.Types.HUMANOIDS,
    [EntityType.ENTITY_KNIGHT] = MassiveDamage.Types.HUMANOIDS,
    [EntityType.ENTITY_POOP] = MassiveDamage.Types.HUMANOIDS, -- For entities that behave like humanoids
    -- Money Takers (Greed, etc.)
    [EntityType.ENTITY_GREED] = MassiveDamage.Types.MONEY_TAKERS,
    [EntityType.ENTITY_SUPER_GREED] = MassiveDamage.Types.MONEY_TAKERS,
    -- Endgame Bosses (Gurdy, Mega Satan, etc.)
    [EntityType.ENTITY_GURDY] = MassiveDamage.Types.ENDGAME,
    [EntityType.ENTITY_MEGA_SATAN] = MassiveDamage.Types.ENDGAME,
}

-- Track unlocked types (by player.InitSeed)
local unlockedMassiveTypes = {}

-- ==== SAVE / LOAD SYSTEM ====
-- These functions are called by the main.lua callback
function MassiveDamage.Save(mod)
    -- This function now returns the data to be saved.
    return json.encode({ massiveDamage = unlockedMassiveTypes })
end

function MassiveDamage.Load(mod, savedData)
    -- This function now receives the data to be loaded.
    if savedData then
        local data = json.decode(savedData)
        unlockedMassiveTypes = data.massiveDamage or {}
    end
end

-- This function resets the state for a new run
function MassiveDamage.OnNewRun()
    unlockedMassiveTypes = {}
end

-- ==== API Functions ====

-- Unlock a massive damage type for a player
function MassiveDamage.Unlock(player, typeKey)
    local seed = player.InitSeed
    unlockedMassiveTypes[seed] = unlockedMassiveTypes[seed] or {}
    unlockedMassiveTypes[seed][typeKey] = true
end

-- Check if player has a massive damage type
function MassiveDamage.Has(player, typeKey)
    local seed = player.InitSeed
    return unlockedMassiveTypes[seed] and unlockedMassiveTypes[seed][typeKey]
end

-- Grant a random massive damage type (weighted chance)
function MassiveDamage.GrantRandom(player)
    rng:SetSeed(Random() + player.InitSeed, 35)

    local pool = {
    {MassiveDamage.Types.ENDGAME, 1},
    {MassiveDamage.Types.BOSSES, 3},
    {MassiveDamage.Types.MINI_BOSSES, 4},
    {MassiveDamage.Types.CHAMPIONS, 4},
    {MassiveDamage.Types.REGULARS, 5},
    {MassiveDamage.Types.MONEY_TAKERS, 6},
    {MassiveDamage.Types.SPIDERS, 7},
    {MassiveDamage.Types.GHOSTS, 7},
    {MassiveDamage.Types.FLIES, 7},
    {MassiveDamage.Types.WORMS, 7},
    {MassiveDamage.Types.HUMANOIDS, 7}
    }

    local totalWeight = 0
    for _, entry in ipairs(pool) do totalWeight = totalWeight + entry[2] end

    local choice = rng:RandomInt(totalWeight)
    local running = 0

    for _, entry in ipairs(pool) do
    running = running + entry[2]
        if choice < running then
        MassiveDamage.Unlock(player, entry[1])
        return entry[1]
        end
    end
end

-- ==== Massive Damage Execution ====

function MassiveDamage.OnEntityDamage(entity, amount, flags, source, countdown)
    local player = nil
    -- Find the player who caused the damage
    if source and source.Type == EntityType.ENTITY_TEAR and source.Entity then
        player = source.Entity:ToTear().SpawnerEntity and source.Entity:ToTear().SpawnerEntity:ToPlayer()
    elseif source and source.Type == EntityType.ENTITY_PLAYER then
        player = source.Entity:ToPlayer()
    elseif source and source.Type == EntityType.ENTITY_FAMILIAR and source.Entity then
        player = source.Entity:ToFamiliar().Player
    end

    if not player or not entity:IsVulnerableEnemy() then return end

    -- Determine the massive damage type based on the entity
    local massiveDamageType = nil
    if entity:IsBoss() and not entity:IsUltraBoss() then
        massiveDamageType = MassiveDamage.Types.BOSSES
    elseif entity:IsChampion() then
        massiveDamageType = MassiveDamage.Types.CHAMPIONS
    elseif ENTITY_MAPPING[entity.Type] then
        -- Check the mapping table for entity types
        massiveDamageType = ENTITY_MAPPING[entity.Type]
    elseif ENTITY_MAPPING[entity.Type .. "_" .. entity.Variant] then
        -- Check the mapping table for specific variants (like ghosts)
        massiveDamageType = ENTITY_MAPPING[entity.Type .. "_" .. entity.Variant]
    elseif entity:IsBoss() and entity:IsUltraBoss() then
        massiveDamageType = MassiveDamage.Types.ENDGAME
    elseif not entity:IsBoss() and not entity:IsChampion() then
        -- If it's not a boss or champion, it's likely a regular enemy
        massiveDamageType = MassiveDamage.Types.REGULARS
    end

    -- If a massive damage type is found, check if the player has it unlocked
    if massiveDamageType and MassiveDamage.Has(player, massiveDamageType) then
        -- Apply the massive damage effect (e.g., double damage)
        local damageMultiplier = 2 -- Or any other value you want
        entity:TakeDamage(amount * damageMultiplier, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(player), 0)
    end
end

return MassiveDamage