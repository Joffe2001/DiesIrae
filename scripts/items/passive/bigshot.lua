local BigShot = {}
BigShot.COLLECTIBLE_ID = Isaac.GetItemIdByName("Big Shot")
local game = Game()
local sfx = SFXManager()

-- per-player charge state
local states = {}
local function getState(player)
    local id = player.InitSeed
    if not states[id] then
        states[id] = {charge=0, charging=false, lastDir=Vector(1,0), fullyCharged=false}
    end
    return states[id]
end

-- CONFIG
local CHARGE_TIME = 45 -- frames to full charge
local SPEED = 14
local DAMAGE_MULT = 2
local BASE_BONUS = 5
local SCALE_MULT = 2.5

-- convert fireDir to vector
local function fireDirToVector(dir)
    if dir == Direction.LEFT then return Vector(-1, 0)
    elseif dir == Direction.RIGHT then return Vector(1, 0)
    elseif dir == Direction.UP then return Vector(0, -1)
    elseif dir == Direction.DOWN then return Vector(0, 1)
    end
    return nil
end

-- stat modifiers (like brimstone items do)
function BigShot:onEvaluateCache(player, cacheFlag)
    if not player:HasCollectible(BigShot.COLLECTIBLE_ID) then return end

    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        -- make normal tears basically impossible
        player.MaxFireDelay = 1000
    elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 1.5
    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + 0.3
    end
end

-- charging + releasing
function BigShot:onUpdate(player)
    if not player:HasCollectible(BigShot.COLLECTIBLE_ID) then return end
    local s = getState(player)

    local aimDir = player:GetAimDirection()
    local fireDir = player:GetFireDirection()

    -- track direction
    if fireDir ~= Direction.NO_DIRECTION then
        s.lastDir = fireDirToVector(fireDir) or s.lastDir
    elseif aimDir:Length() > 0 then
        s.lastDir = aimDir:Normalized()
    end

    local isFiring = (fireDir ~= Direction.NO_DIRECTION) or (aimDir:Length() > 0)

    if isFiring then
        -- begin or continue charging
        s.charging = true
        if s.charge < CHARGE_TIME then
            s.charge = s.charge + 1
            if s.charge >= CHARGE_TIME then
                s.fullyCharged = true
                sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
            end
        end
    else
        -- release
        if s.charging and s.fullyCharged then
            local dir = (s.lastDir:Length() > 0) and s.lastDir or Vector(1,0)
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0,
                player.Position, dir:Resized(SPEED), player):ToTear()
            if tear then
                tear:GetData().IsBigShot = true
                tear.CollisionDamage = (player.Damage * DAMAGE_MULT) + BASE_BONUS
                tear.Scale = SCALE_MULT
                tear.Color = Color(1.8, 0.1, 0.1, 1, 0, 0, 0) -- bright red
                tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
            end
            sfx:Play(SoundEffect.SOUND_MEGA_BLAST_START, 1.0, 0, false, 1.0)
        end
        -- reset
        s.charge = 0
        s.charging = false
        s.fullyCharged = false
    end
end

-- remove normal tears so only BigShot comes out
function BigShot:onPostFireTear(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if player and player:HasCollectible(BigShot.COLLECTIBLE_ID) and not tear:GetData().IsBigShot then
        tear.Visible = false
        tear:Remove() -- kill instantly before it's drawn
    end
end

-- init
function BigShot:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BigShot.onUpdate)
    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, BigShot.onPostFireTear)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BigShot.onEvaluateCache)

    if EID then
        EID:addCollectible(
            BigShot.COLLECTIBLE_ID,
            "Replaces tears with a Brimstone-style charge shot.#Hold fire to charge, release to fire a giant piercing spectral red tear.#Damage x2 +5 bonus.#Tears down, +Damage, +Shot Speed.",
            "Big Shot",
            "en_us"
        )
    end
end

return BigShot
