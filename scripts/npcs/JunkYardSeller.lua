local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local JYS = mod.Entities.BEGGAR_JYS.Var

local COST = 10
local MAX_PAYS = 4
local PAY_SFX = SoundEffect.SOUND_SCAMPER
local PRIZE_SFX = SoundEffect.SOUND_SLOTSPAWN

local Quality0Items = {}
local itemConfig = Isaac.GetItemConfig()

for id = 1, itemConfig:GetCollectibles().Size - 1 do -- ItemConfigItem does not have a Size field I think ?
    local info = itemConfig:GetCollectible(id)
    if info and info.Quality == 0 then
        table.insert(Quality0Items, id)
    end
end

local function JYS_Collision(beggar, collider)
    local player = collider:ToPlayer()
    if not player then return end

    local sprite = beggar:GetSprite()
    local data = beggar:GetData()

    if not data.Initialized then return end

    if not sprite:IsPlaying("Idle" .. (data.Pays > 0 and data.Pays or "")) then
        return
    end

    if player:GetNumCoins() < COST then
        return
    end

    player:AddCoins(-COST)
    data.LastPayer = player
    data.Pays = math.min(data.Pays + 1, MAX_PAYS)

    sfx:Play(PAY_SFX, 1.0)

    local anim = "PayPrize" .. (data.Pays > 1 and data.Pays or "")
    sprite:Play(anim, true)
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, JYS_Collision, JYS)

local function JYS_Update(beggar)
    if beggar.Variant ~= JYS then return end

    local data = beggar:GetData()
    local sprite = beggar:GetSprite()
    local rng = beggar:GetDropRNG()

    if not data.Initialized then
        data.Initialized = true
        data.Pays = 0 -- 0 to 4
        sprite:Play("Idle", true)
        return
    end

    if sprite:IsFinished("Prize" .. (data.Pays > 1 and data.Pays or "")) then
        
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

        if data.Pays >= MAX_PAYS then
            sprite:Play("Teleport", true)
        else
            local anim = "Idle" .. (data.Pays > 0 and data.Pays or "")
            sprite:Play(anim, true)
        end

        return
    end

    if sprite:IsFinished("PayPrize" .. (data.Pays > 1 and data.Pays or "")) then
        local anim = "Prize" .. (data.Pays > 1 and data.Pays or "")
        sprite:Play(anim, true)
        return
    end

    if sprite:IsFinished("Teleport") then
        beggar:Remove()
        return
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, JYS_Update, JYS)


local function JYS_Exploded(beggar)
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)

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
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, JYS_Exploded, JYS)
