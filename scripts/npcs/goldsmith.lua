local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local GOLD_COST = 10
local myBeggar = mod.Entities.BEGGAR_Goldsmith.Var

local function IsGolden(trinket)
    return trinket ~= 0 and (trinket & TrinketType.TRINKET_GOLDEN_FLAG) ~= 0
end

local function CanBeGolden(trinket)
    if trinket == 0 then return false end
    if IsGolden(trinket) then return false end

    local base = trinket & ~TrinketType.TRINKET_GOLDEN_FLAG
    return base > 0
end

local function GetHeldTrinkets(player)
    local t = {}

    for i = 0, 1 do
        local trinket = player:GetTrinket(i)
        if trinket ~= 0 then
            table.insert(t, trinket)
        end
    end
    return t
end

function mod:GoldsmithBeggarCollision(beggar, collider)
    local player = collider:ToPlayer()
    if not player then return end

    local sprite = beggar:GetSprite()
    if not sprite:IsPlaying("Idle") then return end

    local trinkets = GetHeldTrinkets(player)

    if #trinkets == 0 then
        game:GetHUD():ShowItemText("Where are your trinkets?")
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        return
    end

    for _, trinket in ipairs(trinkets) do
        if not CanBeGolden(trinket) then
            game:GetHUD():ShowItemText("Cannot work with this!")
            sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
            return
        end
    end

    if player:GetNumCoins() < GOLD_COST then
        game:GetHUD():ShowItemText("I never work for free")
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        return
    end

    player:AddCoins(-GOLD_COST)
    beggar:GetData().LastPayer = player
    sprite:Play("PayPrize")
    sfx:Play(SoundEffect.SOUND_SCAMPER)
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.GoldsmithBeggarCollision, myBeggar)

function mod:GoldsmithBeggarUpdate(beggar)
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()

    if sprite:IsFinished("PayPrize") then
        local player = data.LastPayer
        if not player then
            sprite:Play("Idle")
            return
        end

        local trinkets = GetHeldTrinkets(player)

        for _, trinket in ipairs(trinkets) do
            local base = trinket & ~TrinketType.TRINKET_GOLDEN_FLAG

            player:TryRemoveTrinket(base)

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_TRINKET,
                base | TrinketType.TRINKET_GOLDEN_FLAG,
                Isaac.GetFreeNearPosition(beggar.Position, 40),
                Vector.Zero,
                beggar
            )
        end

        sfx:Play(SoundEffect.SOUND_GOLD_HEART_DROP)
        sprite:Play("Teleport")
    end

    if sprite:IsFinished("Teleport") then
        beggar:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.GoldsmithBeggarUpdate, myBeggar)


function mod:GoldsmithBeggarExploded(beggar)
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.GoldsmithBeggarExploded, myBeggar)