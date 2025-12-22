local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

local GOLD_COST = 10
local myBeggar = mod.Entities.BEGGAR_Goldsmith_Elijah.Var
local ELIJAH = mod.Players.Elijah

local function IsGolden(trinket)
    return trinket ~= 0 and (trinket & TrinketType.TRINKET_GOLDEN_FLAG) ~= 0
end

local function CanBeGolden(trinket)
    if trinket == 0 then return false end
    if IsGolden(trinket) then return false end
    return (trinket & ~TrinketType.TRINKET_GOLDEN_FLAG) > 0
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

local function GetDrainableWillCount(player)
    local data = mod.SaveManager.GetRunSave(player)
    return
        (data.WillSpeed or 0) * 10 +
        (data.WillFireDelay or 0) * 5 +
        (data.WillDamage or 0) * 5 +
        (data.WillRange or 0) * 4 +
        (data.WillShotSpeed or 0) * 10 +
        (data.WillLuck or 0) * 2
end

local function DrainWillNTimes(player, beggar, times)
    local rng = beggar:GetDropRNG()

    for i = 1, times do
        if not beggarUtils.DrainElijahsWill(player, rng) then
            return false
        end
    end

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
    return true
end


function mod:GoldsmithBeggarCollision(beggar, collider)
    local player = collider:ToPlayer()
    if not player then return end
    if player:GetPlayerType() ~= ELIJAH then return end

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

    if GetDrainableWillCount(player) < GOLD_COST then
        game:GetHUD():ShowItemText("Your will is too weak")
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        return
    end

    if not DrainWillNTimes(player, beggar, GOLD_COST) then
        return
    end

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
    game:SpawnParticles(
        beggar.Position,
        EffectVariant.BLOOD_EXPLOSION,
        1,
        3,
        Color.Default
    )
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.GoldsmithBeggarExploded, myBeggar)