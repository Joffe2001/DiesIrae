local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local JYS = mod.Entities.BEGGAR_JYS.Var

local COST = 10
local PAY_SFX = SoundEffect.SOUND_SCAMPER
local PRIZE_SFX = SoundEffect.SOUND_SLOTSPAWN


local Quality0Items = {}
local itemConfig = Isaac.GetItemConfig()

for id = 1, itemConfig:GetCollectibles().Size - 1 do
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

    if not sprite:IsPlaying("Idle") then
        return
    end

    if player:GetNumCoins() < COST then
        return
    end

    player:AddCoins(-COST)
    data.LastPayer = player

    sfx:Play(PAY_SFX, 1.0)
    sprite:Play("PayPrize", true)
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, JYS_Collision, JYS)


local function JYS_Update(beggar)
    if beggar.Variant ~= JYS then return end

    local data = beggar:GetData()
    if not data.Initialized then
        data.Initialized = true
        data.HasPaid = false
        data.LastPayer = nil
    end

    local sprite = beggar:GetSprite()
    local rng = beggar:GetDropRNG()

    if sprite:IsFinished("Prize") then
        sfx:Play(PRIZE_SFX, 1.0)

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

        sprite:Play("Teleport", true)
        return
    end

    if sprite:IsFinished("Teleport") then
        beggar:Remove()
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
