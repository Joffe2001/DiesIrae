---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

local JYS = mod.Entities.BEGGAR_JYS_Elijah.Var

local MAX_PAYS = 4
local WILL_DRAIN_AMOUNT = 5

local PAY_SFX   = SoundEffect.SOUND_SCAMPER
local PRIZE_SFX = SoundEffect.SOUND_SLOTSPAWN

local Quality0Items = {}
local itemConfig = Isaac.GetItemConfig()

local function GetFilteredItemPool()
    local pool = {}
    local collectibles = itemConfig:GetCollectibles()

    for id = 1, collectibles.Size - 1 do
        local item = itemConfig:GetCollectible(id)
        if item
            and item.Quality == 0
            and item:IsAvailable()
            and not item.Hidden
            and not item:HasTags(ItemConfig.TAG_QUEST)
        then
            table.insert(pool, id)
        end
    end

    return pool
end

Quality0Items = GetFilteredItemPool()

local State = {
    IDLE     = 0,
    PAY      = 1,
    PRIZE    = 2,
    TELEPORT = 3
}

local function JYS_Collision(_, beggar, collider)
    if beggar.Variant ~= JYS then return end

    local player = collider:ToPlayer()
    if not player then return end

    local data = beggar:GetData()
    local sprite = beggar:GetSprite()

    if not data.Initialized then return end
    if data.State ~= State.IDLE then return end
    if data.Pays >= MAX_PAYS then return end

    local paid = false
    if player:GetPlayerType() == mod.Players.Elijah then
        local drainCount = 0
        for i = 1, WILL_DRAIN_AMOUNT do
            if beggarUtils.DrainElijahsWill(player, beggar:GetDropRNG()) then
                drainCount = drainCount + 1
            else
                break
            end
        end
        
        paid = drainCount > 0
        if paid then
            player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
        end
    else
        return
    end

    if not paid then return end

    data.Pays = data.Pays + 1
    data.LastPayer = player

    data.State = State.PAY
    sfx:Play(PAY_SFX, 1.0)

    if data.Pays == 1 then sprite:Play("PayPrize", true) end
    if data.Pays == 2 then sprite:Play("PayPrize2", true) end
    if data.Pays == 3 then sprite:Play("PayPrize3", true) end
    if data.Pays == 4 then sprite:Play("PayPrize4", true) end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, JYS_Collision, JYS)

local function JYS_Update(_, beggar)
    if beggar.Variant ~= JYS then return end

    local data = beggar:GetData()
    local sprite = beggar:GetSprite()
    local rng = beggar:GetDropRNG()

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
    beggar.Velocity = Vector.Zero

    if data.State == State.PAY then
        if sprite:IsFinished() then
            data.State = State.PRIZE

            if data.Pays == 1 then sprite:Play("Prize1", true) end
            if data.Pays == 2 then sprite:Play("Prize2", true) end
            if data.Pays == 3 then sprite:Play("Prize3", true) end
            if data.Pays == 4 then sprite:Play("Prize4", true) end
        end
    end

    if data.State == State.PRIZE then
        if sprite:IsFinished() then
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

    if data.State == State.TELEPORT and sprite:IsFinished("Teleport") then
        beggar:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, JYS_Update, JYS)

local function JYS_Exploded(_, beggar)
    if beggar.Variant ~= JYS then return end

    beggarUtils.DoBeggarExplosion(beggar)

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