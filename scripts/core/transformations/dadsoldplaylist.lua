local mod = DiesIraeMod

local DadPlaylist = {}
local game = Game()
local sfx = SFXManager()

DadPlaylist.TRANSFORMATION_NAME = "Dad's Old Playlist"

DadPlaylist.ITEMS = {
<<<<<<< HEAD
    mod.Items.TheBadTouch,
    mod.Items.ArmyOfLovers,
    mod.Items.LittleLies,
    mod.Items.ShBoom,
    mod.Items.Universal,
    mod.Items.EverybodysChanging,
    mod.Items.U2,
    mod.Items.KillerQueen,
    mod.Items.RingOfFire,
    mod.Items.HelterSkelter,
    mod.Items.Muse
=======
    Enums.Items.TheBadTouch,
    Enums.Items.ArmyOfLovers,
    Enums.Items.LittleLies,
    Enums.Items.ShBoom,
    Enums.Items.Universal,
    Enums.Items.EverybodysChanging,
    Enums.Items.U2,
    Enums.Items.KillerQueen,
    Enums.Items.RingOfFire,
    Enums.Items.HelterSkelter,
    Enums.Items.Muse,
>>>>>>> updates
}

local MusicTears = nil
local success, mt = pcall(require, "scripts.core.music_tears")
if success then
    MusicTears = mt
else
    print("[DadPlaylist.lua] MusicTears module not found. Tears will be normal.")
end

local function GetItemCount(player)
    local count = 0
    for _, id in ipairs(DadPlaylist.ITEMS) do
        if id and id > 0 then
            count = count + player:GetCollectibleNum(id, true)
        end
    end
    return count
end

function DadPlaylist:onPlayerInit(player)
    player:GetData().hasDadPlaylist = false
end

function DadPlaylist:onPlayerUpdate(player)
    if not player or not player:ToPlayer() then return end
    local data = player:GetData()

    if data.hasDadPlaylist == nil then
        data.hasDadPlaylist = false
    end

    local count = GetItemCount(player)

    if not data.hasDadPlaylist and count >= 3 then
        data.hasDadPlaylist = true
        game:GetHUD():ShowItemText(DadPlaylist.TRANSFORMATION_NAME)
        sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)

        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    end
end

function DadPlaylist:onEvaluateCache(player, cacheFlag)
    if player:GetData().hasDadPlaylist and cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = math.max(1, player.MaxFireDelay * 0.8)
    end
end

function DadPlaylist:onFireTear(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end
    if not player:GetData().hasDadPlaylist then return end

    if MusicTears then
        MusicTears:Apply(tear)
    end

    if math.random() < 0.15 then 
        for _, entity in ipairs(Isaac.FindInRadius(player.Position, 120, EntityPartition.ENEMY)) do
            if entity:CanShutDoors() and entity:IsVulnerableEnemy() then
                local dir = (entity.Position - player.Position):Normalized()
                entity:AddVelocity(dir * 6)

                if math.random() < 0.20 then
                    entity:AddCharmed(EntityRef(player), 90)
                end
            end
        end
        local wave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, player.Position, Vector.Zero, player)
        wave.Parent = player
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, DadPlaylist.onPlayerInit)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, DadPlaylist.onPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DadPlaylist.onEvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, DadPlaylist.onFireTear)

<<<<<<< HEAD
if EID then
    EID:createTransformation("DadPlaylist","Dad's Old Playlist")
=======
    if EID then
        EID:createTransformation("DadPlaylist", DadPlaylist.TRANSFORMATION_NAME)
    end
>>>>>>> updates
end
