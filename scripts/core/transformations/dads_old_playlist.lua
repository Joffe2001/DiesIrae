local DadPlaylist = {}
DadPlaylist.TRANSFORMATION_NAME = "Dad's Old Playlist"

DadPlaylist.ITEMS = {
    Isaac.GetItemIdByName("The Bad Touch"),
    Isaac.GetItemIdByName("Army of Lovers"),
    Isaac.GetItemIdByName("Little Lies"),
    Isaac.GetItemIdByName("Sh-boom!!"),
    Isaac.GetItemIdByName("Universal"),
    Isaac.GetItemIdByName("Everybody's Changing"),
    Isaac.GetItemIdByName("U2"),
    Isaac.GetItemIdByName("Killer Queen"),
    Isaac.GetItemIdByName("Ring of Fire"),
    Isaac.GetItemIdByName("Helter Skelter"),
    Isaac.GetItemIdByName("Muse")
}

---@param player EntityPlayer
---@return integer
local function GetItemCount(player)
    local count = 0
    for _, id in ipairs(DadPlaylist.ITEMS) do
        if id > 0 then -- valid ID check
            count = count + player:GetCollectibleNum(id, true)
        end
    end
    return count
end

---@param player EntityPlayer
function DadPlaylist:onPlayerInit(player)
    player:GetData().hasDadPlaylist = false
end

---@param player EntityPlayer
function DadPlaylist:onPlayerUpdate(player)
    local data = player:GetData()

    if data.hasDadPlaylist == nil then
        data.hasDadPlaylist = false
    end

    local count = GetItemCount(player)

    if not data.hasDadPlaylist and count >= 3 then
        data.hasDadPlaylist = true
        GameRef:GetHUD():ShowItemText(DadPlaylist.TRANSFORMATION_NAME)
        SfxManager:Play(SoundEffect.SOUND_POWERUP_SPEWER)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)

        -- optional costume
        -- p:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/5_transformation_DadPlaylist.anm2"))

        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    elseif data.hasDadPlaylist and count < 3 then
        data.hasDadPlaylist = false
        -- p:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/5_transformation_DadPlaylist.anm2"))
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    end
end

---@param player EntityPlayer
---@param cacheFlag CacheFlag
function DadPlaylist:onEvaluateCache(player, cacheFlag)
    local p = player:ToPlayer()
    if not p then return end
    if p:GetData().hasDadPlaylist and cacheFlag == CacheFlag.CACHE_FIREDELAY then
        p.MaxFireDelay = math.max(1, p.MaxFireDelay - 2)
    end
end

---@param tear EntityTear
function DadPlaylist:onFireTear(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if player and player:GetData().hasDadPlaylist then
        local shockwave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, player.Position, Vector.Zero, player)
        shockwave.Parent = player
    end
end

function DadPlaylist:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, DadPlaylist.onPlayerInit)
    mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, DadPlaylist.onPlayerUpdate)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DadPlaylist.onEvaluateCache)
    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, DadPlaylist.onFireTear)

    if EID then
        EID:createTransformation("DadPlaylist","Dad's Old Playlist")
    end
end

return DadPlaylist
