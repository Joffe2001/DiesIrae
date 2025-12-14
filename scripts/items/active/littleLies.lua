local mod = DiesIraeMod

local LittleLies = {}


---@param player EntityPlayer
function LittleLies:UseItem(_, _, player)
    local data = player:GetData()
    if not data.LittleLiesActive then
        data.LittleLiesActive = true
        ---@diagnostic disable-next-line: param-type-mismatch
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
            ---@diagnostic disable-next-line: param-type-mismatch
            player:AddCacheFlags(CacheFlag.CACHE_SIZE | CacheFlag.CACHE_FIREDELAY)
            player:EvaluateItems()
        end
    end)
end

LittleLies.Mod = mod
mod:AddCallback(ModCallbacks.MC_USE_ITEM, LittleLies.UseItem, mod.Items.LittleLies)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LittleLies.OnEvaluateCache)

-- EID description
if EID then
    EID:assignTransformation("collectible", mod.Items.LittleLies, "Dad's Playlist")
end
