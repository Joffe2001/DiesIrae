---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local JYS = mod.Entities.BEGGAR_JYS.Var

local COST = 10
local MAX_PAYS = 4

local PAY_SFX   = SoundEffect.SOUND_SCAMPER
local PRIZE_SFX = SoundEffect.SOUND_SLOTSPAWN

--------------------------------------------------
-- QUALITY 0 ITEM POOL
--------------------------------------------------
local Quality0Items = {}
local itemConfig = Isaac.GetItemConfig()

for id = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
    local info = itemConfig:GetCollectible(id)
    if info and info.Quality == 0 then
        table.insert(Quality0Items, id)
    end
end

--------------------------------------------------
-- STATES
--------------------------------------------------
local State = {
    IDLE     = 0,
    PAY      = 1,
    PRIZE    = 2,
    TELEPORT = 3
}

--------------------------------------------------
-- COLLISION (PAYMENT)
--------------------------------------------------
local function JYS_Collision(_, beggar, collider)
    if beggar.Variant ~= JYS then return end

    local player = collider:ToPlayer()
    if not player then return end

    local data = beggar:GetData()
    local sprite = beggar:GetSprite()

    if not data.Initialized then return end
    if data.State ~= State.IDLE then return end
    if data.Pays >= MAX_PAYS then return end
    if player:GetNumCoins() < COST then return end

    -- TAKE COINS
    player:AddCoins(-COST)
    data.Pays = data.Pays + 1
    data.LastPayer = player

    -- PAY STATE
    data.State = State.PAY
    sfx:Play(PAY_SFX, 1.0)

    if data.Pays == 1 then sprite:Play("PayPrize", true) end
    if data.Pays == 2 then sprite:Play("PayPrize2", true) end
    if data.Pays == 3 then sprite:Play("PayPrize3", true) end
    if data.Pays == 4 then sprite:Play("PayPrize4", true) end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, JYS_Collision, JYS)

--------------------------------------------------
-- UPDATE (STATE MACHINE)
--------------------------------------------------
local function JYS_Update(_, beggar)
    if beggar.Variant ~= JYS then return end

    local data = beggar:GetData()
    local sprite = beggar:GetSprite()
    local rng = beggar:GetDropRNG()

    --------------------------------------------------
    -- INIT
    --------------------------------------------------
    if not data.Initialized then
        data.Initialized = true
        data.Pays = 0
        data.State = State.IDLE

        beggar.Velocity = Vector.Zero
        beggar:AddEntityFlags(
            EntityFlag.FLAG_NO_KNOCKBACK |
            EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK
        )
        beggar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

        sprite:Play("Idle", true)
        return
    end

    -- NEVER MOVE
    beggar.Velocity = Vector.Zero

    --------------------------------------------------
    -- PAY → PRIZE
    --------------------------------------------------
    if data.State == State.PAY then
        if sprite:IsFinished() then
            data.State = State.PRIZE

            if data.Pays == 1 then sprite:Play("Prize", true) end
            if data.Pays == 2 then sprite:Play("Prize2", true) end
            if data.Pays == 3 then sprite:Play("Prize3", true) end
            if data.Pays == 4 then sprite:Play("Prize4", true) end
        end
    end

    --------------------------------------------------
    -- PRIZE → IDLE / TELEPORT
    --------------------------------------------------
    if data.State == State.PRIZE then
        if sprite:IsFinished() then
            -- SPAWN ITEM
            if #Quality0Items > 0 then
                local item = Quality0Items[rng:RandomInt(#Quality0Items) + 1]
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE,
                    item,
                    Isaac.GetFreeNearPosition(beggar.Position, 40),
                    Vector.Zero,
                    beggar
                )
            end

            sfx:Play(PRIZE_SFX, 1.0)

            if data.Pays < MAX_PAYS then
                data.State = State.IDLE
                if data.Pays == 1 then sprite:Play("Idle2", true) end
                if data.Pays == 2 then sprite:Play("Idle3", true) end
                if data.Pays == 3 then sprite:Play("Idle4", true) end
            else
                data.State = State.TELEPORT
                sprite:Play("Teleport", true)
            end
        end
    end

    --------------------------------------------------
    -- TELEPORT CLEANUP
    --------------------------------------------------
    if data.State == State.TELEPORT and sprite:IsFinished("Teleport") then
        beggar:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, JYS_Update, JYS)

--------------------------------------------------
-- EXPLOSION HANDLER
--------------------------------------------------
local function JYS_Exploded(_, beggar)
    if beggar.Variant ~= JYS then return end

    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(
        beggar.Position,
        EffectVariant.BLOOD_EXPLOSION,
        1,
        3,
        Color.Default
    )

    for i = 1, 2 do
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COIN,
            0,
            beggar.Position + RandomVector() * 10,
            RandomVector() * 2,
            beggar
        )
    end

    beggar:Remove()
end

mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, JYS_Exploded, JYS)
