local mod = DiesIraeMod

local GooglyEyes = {}

-- List of tear variants to randomly pick from (excluding charge/recharge types)
local tearVariants = {
    TearVariant.TEAR_NORMAL,
    TearVariant.TEAR_BLOOD,
    TearVariant.TEAR_POISON,
    TearVariant.TEAR_FIRE,
    TearVariant.TEAR_GHOST,
    TearVariant.TEAR_LASER,
    TearVariant.TEAR_HOMING,
    TearVariant.TEAR_TECHNOLOGY,
    TearVariant.TEAR_MISER,
    TearVariant.TEAR_MEGATEAR,
    TearVariant.TEAR_STICKY,
    TearVariant.TEAR_KNIFE,
    TearVariant.TEAR_BONE,
}

-- Corresponding tear flags to add for certain variants
local variantFlags = {
    [TearVariant.TEAR_BLOOD] = TearFlags.TEAR_BLOOD,
    [TearVariant.TEAR_POISON] = TearFlags.TEAR_POISON,
    [TearVariant.TEAR_FIRE] = TearFlags.TEAR_BURN | TearFlags.TEAR_SPAWNFIRE,
    [TearVariant.TEAR_GHOST] = TearFlags.TEAR_GHOST,
    [TearVariant.TEAR_HOMING] = TearFlags.TEAR_HOMING,
    [TearVariant.TEAR_TECHNOLOGY] = TearFlags.TEAR_LASER,
    [TearVariant.TEAR_STICKY] = TearFlags.TEAR_SLOW,
    [TearVariant.TEAR_KNIFE] = TearFlags.TEAR_PIERCING,
    [TearVariant.TEAR_BONE] = TearFlags.TEAR_PIERCING,
    -- Others don't need special flags here
}

-- Helper function to pick random variants (1 to 3 variants per tear)
local function getRandomVariants()
    local numVariants = math.random(1, 3)
    local chosen = {}
    local copyVariants = {}
    for i,v in ipairs(tearVariants) do
        table.insert(copyVariants, v)
    end
    
    for i = 1, numVariants do
        if #copyVariants == 0 then break end
        local idx = math.random(1, #copyVariants)
        table.insert(chosen, copyVariants[idx])
        table.remove(copyVariants, idx)
    end
    return chosen
end

-- MC_POST_FIRE_TEAR callback: modify tears when fired
function GooglyEyes:PostFireTear(_, tear)
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.Items.GooglyEyes) then return end

    local variants = getRandomVariants()

    -- For visual & effect purposes, set the tear variant to the first chosen one
    tear:ChangeVariant(variants[1])

    -- Add all corresponding flags from chosen variants
    for _, v in ipairs(variants) do
        local flags = variantFlags[v]
        if flags then
            tear:AddTearFlags(flags)
        end
    end

    -- Debug print (optional, comment out in release)
    print("Googly Eyes: Tear changed to variant(s): " .. table.concat(variants, ", "))
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, GooglyEyes.PostFireTear)

if EID then
    EID:addCollectible(
        mod.Items.GooglyEyes,
        "Isaac's tears randomly gain 1-3 chaotic tear variants simultaneously, mixing elemental and special effects.",
        "Googly Eyes",
        "en_us"
    )
end
