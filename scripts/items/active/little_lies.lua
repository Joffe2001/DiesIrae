local LittleLies = {}
LittleLies.COLLECTIBLE_ID = Enums.Items.LittleLies


---@param player EntityPlayer
function LittleLies:UseItem(_, _, player)
    local data = player:GetData()
    if not data.LittleLiesActive then
        data.LittleLiesActive = true
        player:AddCacheFlags(CacheFlag.CACHE_SIZE | CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
        
        -- Reset on new room
        LittleLies:AddRoomReset(player)
    end
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

---@param player EntityPlayer
---@param cacheFlag CacheFlag
function LittleLies:OnEvaluateCache(player, cacheFlag)
    local data = player:GetData()
    if not data.LittleLiesActive then return end

    if cacheFlag == CacheFlag.CACHE_SIZE then
        -- Stronger size reduction
        player.SpriteScale = player.SpriteScale * 0.4
        player.SizeMulti = player.SizeMulti * 0.4
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        -- Tears up: -2 to MaxFireDelay (≈ +2 tears)
        player.MaxFireDelay = math.max(1, player.MaxFireDelay - 2)
    end
end

---@param player EntityPlayer
function LittleLies:AddRoomReset(player)
    local mod = LittleLies.Mod
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        if player:GetData().LittleLiesActive then
            player:GetData().LittleLiesActive = false
            player:AddCacheFlags(CacheFlag.CACHE_SIZE | CacheFlag.CACHE_FIREDELAY)
            player:EvaluateItems()
        end
    end)
end

function LittleLies:Init(mod)
    LittleLies.Mod = mod
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ...)
        return LittleLies:UseItem(...)
    end, LittleLies.COLLECTIBLE_ID)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
        LittleLies:OnEvaluateCache(player, cacheFlag)
    end)
end

-- EID description
if EID then
    EID:addCollectible(
        LittleLies.COLLECTIBLE_ID,
        "Shrinks Isaac and grants +2 Tears for the current room",
        "Little Lies",
        "en_us"
    )
    EID:assignTransformation("collectible", LittleLies.COLLECTIBLE_ID, "Dad's Playlist")
end

return LittleLies
