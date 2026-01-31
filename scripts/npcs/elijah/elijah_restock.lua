local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

local BASE_CHANCE = 0.05
local MULT_PER_USE = 0.03
local GUARANTEED_REROLLS = 2
local BREAK_CHANCE = 0.50 

--- Definitions
---

local restockMachine = mod.Entities.BEGGAR_Restock_Elijah.Var
local elijahWill = mod.Entities.PICKUP_ElijahsWill.Var
local elijah = mod.Players.Elijah

local restockFuncs = {}

--- Helper Functions
---

local function RerollRoom()
    -- D6 effect (reroll items)
    for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local pickup = entity:ToPickup()
        if pickup and not pickup:IsShopItem() then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, true)
        end
    end
    
    -- D20 effect (reroll pickups)
    for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        local pickup = entity:ToPickup()
        if pickup 
            and pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE 
            and pickup.Variant ~= elijahWill
            and not pickup:IsShopItem() then
            pickup:Morph(EntityType.ENTITY_PICKUP, pickup.Variant, 0, true)
        end
    end
end

local function SpawnWillDrops(position, amount)
    for i = 1, amount do
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            elijahWill,
            0,
            position + RandomVector() * 15,
            RandomVector() * 3,
            nil
        )
    end
end

--- Callbacks
---

---@param machine EntityNPC
---@param collider Entity
---@param _ any
function restockFuncs:PostSlotCollision(machine, collider, _)
    local player = collider:ToPlayer()
    if not player then return end
    if player:GetPlayerType() ~= elijah then return end

    local sprite = machine:GetSprite()
    local data = machine:GetData()

    -- Don't accept if already processing or broken
    if data.Using then return end
    if data.Broken then return end
    if not sprite:IsPlaying("Idle") then return end

    local rng = machine:GetDropRNG()

    if not beggarUtils.DrainElijahsWill(player, rng) then
        return
    end

    sprite:PlayOverlay("CoinInsert", true)
    sfx:Play(SoundEffect.SOUND_COIN_SLOT)

    -- Initialize counters if needed
    data.RerollCount = data.RerollCount or 0
    data.FailedAttempts = data.FailedAttempts or 0
    
    local success = false
    
    -- First 2 rerolls are guaranteed (like vanilla)
    if data.RerollCount < GUARANTEED_REROLLS then
        success = true
    else
        -- After 2 successful rerolls, use chance-based system
        local chance = BASE_CHANCE + (MULT_PER_USE * data.FailedAttempts) + (player.Luck / 100)
        chance = math.max(0, math.min(1, chance))
        success = rng:RandomFloat() < chance
    end
    
    if success then
        -- Success: Will reroll
        data.Using = true
        data.ShouldReroll = true
        data.FailedAttempts = 0  -- Reset failed attempts on success
    else
        -- Failed: CoinInsert plays but nothing else happens
        data.Using = true
        data.ShouldReroll = false
        data.FailedAttempts = data.FailedAttempts + 1
    end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, restockFuncs.PostSlotCollision, restockMachine)

---@param machine EntityNPC
function restockFuncs:PostSlotUpdate(machine)
    local sprite = machine:GetSprite()
    local data = machine:GetData()
    local rng = machine:GetDropRNG()

    -- Initialize
    if not data.Initialized then
        data.Initialized = true
        data.RerollCount = 0
        data.FailedAttempts = 0
        sprite:Play("Idle", true)
        return
    end

    -- If broken, stay in Broken state
    if data.Broken then
        if not sprite:IsPlaying("Broken") and not sprite:IsPlaying("Death") then
            sprite:Play("Broken", true)
        end
        return
    end

    -- Handle CoinInsert overlay finish
    if sprite:IsOverlayFinished("CoinInsert") then
        if data.ShouldReroll then
            -- Success: Do reroll
            data.ShouldReroll = false
            data.RerollCount = (data.RerollCount or 0) + 1
            
            -- Mark positions of items BEFORE reroll for poof effects
            local itemPositions = {}
            for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                local pickup = entity:ToPickup()
                if pickup and not pickup:IsShopItem() then
                    table.insert(itemPositions, pickup.Position)
                end
            end
            
            -- Reroll the room
            RerollRoom()
            
            -- Spawn poof effects at old item positions (NO SFX, like vanilla)
            for _, pos in ipairs(itemPositions) do
                Isaac.Spawn(
                    EntityType.ENTITY_EFFECT,
                    EffectVariant.POOF01,
                    0,
                    pos,
                    Vector.Zero,
                    nil
                )
            end
            
            -- Check if should break (after 2nd successful reroll)
            if data.RerollCount > GUARANTEED_REROLLS then
                if rng:RandomFloat() < BREAK_CHANCE then
                    -- Break the machine (like vanilla)
                    sprite:Play("Death", true)
                    sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL)
                    data.Broken = true
                    data.Using = false
                    return
                end
            end
            
            data.Using = false
        else
            -- Failed: CoinInsert finished but no reroll (like vanilla)
            data.Using = false
        end
    end

    -- Handle Death animation -> Add explosion effect halfway through
    if sprite:IsPlaying("Death") then
        -- Trigger explosion effect at frame 10 (roughly halfway through death animation)
        if sprite:GetFrame() == 10 and not data.ExplosionTriggered then
            -- Explosion visual and sound
            game:BombExplosionEffects(machine.Position, 1, TearFlags.TEAR_NORMAL, Color.Default, machine, 1, false, false, DamageFlag.DAMAGE_EXPLOSION)
            sfx:Play(SoundEffect.SOUND_BOSS_LITE_EXPLOSIONS)
            data.ExplosionTriggered = true
        end
    end

    -- Handle Death animation -> Broken state
    if sprite:IsFinished("Death") then
        sprite:Play("Broken", true)
        
        -- ONLY NOW: Spawn 2-3 Will (after turning Broken)
        local willDrops = rng:RandomInt(2) + 2  -- 2 or 3
        SpawnWillDrops(machine.Position, willDrops)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, restockFuncs.PostSlotUpdate, restockMachine)

---@param machine EntityNPC
function restockFuncs:PreSlotExplosion(machine)
    local rng = machine:GetDropRNG()
    
    -- Mark positions for poof
    local itemPositions = {}
    for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local pickup = entity:ToPickup()
        if pickup and not pickup:IsShopItem() then
            table.insert(itemPositions, pickup.Position)
        end
    end
    
    -- Reroll the room
    RerollRoom()
    
    -- Spawn poof effects (NO SFX)
    for _, pos in ipairs(itemPositions) do
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pos, Vector.Zero, nil)
    end
    
    -- Spawn 2-3 Will (when bombed)
    local willDrops = rng:RandomInt(2) + 2
    SpawnWillDrops(machine.Position, willDrops)
    
    -- Explosion effects
    beggarUtils.DoBeggarExplosion(machine)
    
    return false  -- Don't spawn default drops
end

mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, restockFuncs.PreSlotExplosion, restockMachine)