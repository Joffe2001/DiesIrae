local mod = DiesIraeMod
local DadPlaylist = {}
local sfx = SFXManager()

local function GetDadPlaylistItemCount(p)
    local count = 0
    for i = 1, #mod.Pools.DadPlaylistItem do
        if p:HasCollectible(mod.Pools.DadPlaylistItem[i], true) then
            count = count + p:GetCollectibleNum(mod.Pools.DadPlaylistItem[i], true)
        end
    end
    return count
end

local function HasDadPlaylist(p)
    return GetDadPlaylistItemCount(p) >= 3
end

function DadPlaylist:dadPlaylistUpdate(p)
    local d = p:GetData()
    local hasTrans = HasDadPlaylist(p)

    if hasTrans and not d.hasDadPlaylist then
        d.hasDadPlaylist = true
        Game():GetHUD():ShowItemText("Dad's Old Playlist", "Mom sometimes listens to it...")
        p:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/dads_playlist.anm2"))
        sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)

    elseif not hasTrans and d.hasDadPlaylist then
        d.hasDadPlaylist = false
        p:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/dads_playlist.anm2"))
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, DadPlaylist.dadPlaylistUpdate)

function DadPlaylist:EvaluateCache(p, cacheFlag)
    if HasDadPlaylist(p) then
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            p.MaxFireDelay = math.max(1, p.MaxFireDelay - 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DadPlaylist.EvaluateCache)

local MusicTears = {}

function MusicTears:Apply(tear)
    if not tear or tear.Type ~= EntityType.ENTITY_TEAR then return end
    local variant = tear.Variant
    
    local safeVariants = {
        [TearVariant.BLUE] = true,
        [TearVariant.BLOOD] = true,
        [TearVariant.CUPID_BLUE] = true,
        [TearVariant.CUPID_BLOOD] = true,
        [TearVariant.DARK_MATTER] = true,
    }
    
    if safeVariants[variant] then
        local sprite = tear:GetSprite()
        sprite:ReplaceSpritesheet(0, "gfx/proj/music_tears.png", true)
        sprite:LoadGraphics()
        tear:GetData().isMusicTear = true
    end 
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if player and HasDadPlaylist(player) then
        MusicTears:Apply(tear)
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider)
    if not tear:GetData().isMusicTear then return end
    if not collider or not collider.Position then return end

    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end

    if not HasDadPlaylist(player) then return end  

    local itemCount = GetDadPlaylistItemCount(player)

    local chance = 0.3 + 0.05 * (itemCount - 3)
    local lifetime = 30 + 15 * (itemCount - 3)

    if math.random() <= chance then
        local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, collider.Position, Vector.Zero, player)
        local effect = cloud:ToEffect()
        if effect then
            effect.Color = Color(1, 0.4, 1, 1, 0, 0, 0)
            effect.SpriteScale = Vector(1.5, 1.5)
            effect:Update()
            effect:SetTimeout(lifetime)
            effect:GetData().Player = player
            effect:GetData().IsDadPlaylistCloud = true 
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    local data = effect:GetData()
    if effect.Variant == EffectVariant.DUST_CLOUD and data.Player and data.IsDadPlaylistCloud then
        local player = data.Player

        for _, ent in ipairs(Isaac.FindInRadius(effect.Position, 60, EntityPartition.ENEMY)) do
            if ent:ToNPC() and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                ent:AddCharmed(EntityRef(player), 90)
            end
        end
    end
end)

if EID then
    EID:createTransformation("Dad's Old Playlist", "Dad's Old Playlist")
    EID.TransformationData["Dad's Old Playlist"] = { NumNeeded = 3 }

    local transIcon = Sprite()
    transIcon:Load("gfx/ui/eid/eid_transform_icons.anm2", true)
    EID:addIcon("Dad's Old Playlist", "Dad's Old Playlist", 0, 6, 6, -5, -4, transIcon)

    for i = 1, #mod.Pools.DadPlaylistItem do
        EID:assignTransformation("collectible", mod.Pools.DadPlaylistItem[i], "Dad's Old Playlist")
    end
end