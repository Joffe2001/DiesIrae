local mod = DiesIraeMod

local DadPlaylist = {}
DadPlaylist.TRANSFORMATION_NAME = "Dad's Old Playlist"

DadPlaylist.ITEMS = {
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
}

local game = Game()
local sfx = SFXManager()

local function GetItemCount(player)
    local count = 0
    for _, id in ipairs(DadPlaylist.ITEMS) do
        if id > 0 then -- valid ID check
            count = count + player:GetCollectibleNum(id, true)
        end
    end
    return count
end

function DadPlaylist:onPlayerInit(player)
    player:GetData().hasDadPlaylist = false
end

function DadPlaylist:onPlayerUpdate(player)
    local p = player:ToPlayer()
    if not p then return end
    local data = p:GetData()

    -- initialize if missing
    if data.hasDadPlaylist == nil then
        data.hasDadPlaylist = false
    end

    local count = GetItemCount(p)

    if not data.hasDadPlaylist and count >= 3 then
        data.hasDadPlaylist = true
        game:GetHUD():ShowItemText(DadPlaylist.TRANSFORMATION_NAME)
        sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)

        -- optional costume
        -- p:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/5_transformation_DadPlaylist.anm2"))

        p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        p:EvaluateItems()
    elseif data.hasDadPlaylist and count < 3 then
        data.hasDadPlaylist = false
        -- p:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/5_transformation_DadPlaylist.anm2"))
        p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        p:EvaluateItems()
    end
end

function DadPlaylist:onEvaluateCache(player, cacheFlag)
    local p = player:ToPlayer()
    if not p then return end
    if p:GetData().hasDadPlaylist and cacheFlag == CacheFlag.CACHE_FIREDELAY then
        p.MaxFireDelay = math.max(1, p.MaxFireDelay - 2)
    end
end

function DadPlaylist:onFireTear(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if player and player:GetData().hasDadPlaylist then
        local shockwave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, player.Position, Vector.Zero, player)
        shockwave.Parent = player
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, DadPlaylist.onPlayerInit)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, DadPlaylist.onPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DadPlaylist.onEvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, DadPlaylist.onFireTear)
