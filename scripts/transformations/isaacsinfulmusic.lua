local mod = DiesIraeMod
local SinfulMusic = {}
local sfx = SFXManager()
local Resonance = include("scripts/effects/resonance")

local SinfulMusicItemList = {
    mod.Items.HereToStay,
    mod.Items.Hysteria,
    mod.Items.Mutter,
    mod.Items.LastResort,
    mod.Items.HypaHypa,
    mod.Items.HolyWood,
    mod.Items.DiaryOfAMadman,
    mod.Items.ComaWhite,
    mod.Items.KoRn,
    mod.Items.Psychosocial,
    CollectibleType.COLLECTIBLE_DUALITY,
    CollectibleType.COLLECTIBLE_SULFUR
}

local function HasSinfulMusic(p)
    local count = 0
    for i = 1, #SinfulMusicItemList do
        if p:HasCollectible(SinfulMusicItemList[i], true) then
            count = count + p:GetCollectibleNum(SinfulMusicItemList[i], true)
        end
    end
    return count >= 3
end

function SinfulMusic:sinfulMusicUpdate(p)
    local d = p:GetData()
    local hasTrans = HasSinfulMusic(p)

    if hasTrans and not d.hasSinfulMusic then
        d.hasSinfulMusic = true
        Game():GetHUD():ShowItemText("Isaac's Sinful Music", "This music came from the Devil")
        p:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/isaac_playlist.anm2"))
        sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)

    elseif not hasTrans and d.hasSinfulMusic then
        d.hasSinfulMusic = false
        p:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/isaac_playlist.anm2"))
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, SinfulMusic.sinfulMusicUpdate)

function SinfulMusic.EvaluateCache(_, p, cacheFlag)
    local d = p:GetData()
    if d.hasSinfulMusic and cacheFlag == CacheFlag.CACHE_DAMAGE then
        p.Damage = p.Damage + 0.5
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SinfulMusic.EvaluateCache)

function SinfulMusic.OnTearFire(_, tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end

    local d = player:GetData()
    if d.hasSinfulMusic then
        if math.random() <= 0.10 then
            Resonance.ApplyResonance(tear)
            tear:GetData().isResonanceTear = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, SinfulMusic.OnTearFire)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider)
    local data = tear:GetData()
    if not data.isResonanceTear then return end
    if not collider or not collider.Position then return end

    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end

    local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, collider.Position, Vector.Zero, player)
    local effect = cloud:ToEffect()
    if effect then
        effect.Color = tear.Color 
        effect.SpriteScale = Vector(1.5, 1.5)
        effect:Update()
        effect:SetTimeout(90)
        effect:GetData().Player = player
        effect:GetData().ResonanceColor = tear.Color
    end
end)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant ~= EffectVariant.DUST_CLOUD then return end
    local data = effect:GetData()
    if not data.Player or not data.ResonanceColor then return end

    for _, ent in ipairs(Isaac.FindInRadius(effect.Position, 60, EntityPartition.ENEMY)) do
        local npc = ent:ToNPC()
        if npc and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
            local npcData = npc:GetData()
            npcData.ResonanceActive = true
            npcData.ResonanceTimer = 90
            npc:SetColor(data.ResonanceColor, 90, 1, false, false)
        end
    end
end)

return SinfulMusic
