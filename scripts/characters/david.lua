local David = {}
David.ID = Isaac.GetPlayerTypeByName("David", false) -- must match players.xml name

-- Costume
local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/david_hair.anm2")

-- =========================
-- CONFIG: Starting stats
-- =========================
local STARTING_RED = 1
local STARTING_GOLD = 1

local DAMAGE_MODIFIER = 1
local SPEED_MODIFIER = 0.2
local TEAR_DELAY_MODIFIER = 1
local LUCK_MODIFIER = 1

local STARTING_COLLECTIBLES = {
    Isaac.GetItemIdByName("Muse")
}

local STARTING_TRINKETS = {
    Isaac.GetTrinketIdByName("Gaga")
}

-- =========================
-- Require MusicTears safely
-- =========================
local MusicTears = nil
local success, mt = pcall(require, "scripts.core.music_tears") 
if success then
    MusicTears = mt
else
    print("[David.lua] MusicTears module not found. Tears will be normal.")
end

-- =========================
-- On player init
-- =========================
function David:OnPlayerInit(player)
    if player:GetPlayerType() ~= self.ID then return end

    -- Add hair costume
    player:AddNullCostume(hairCostume)

    -- Reset hearts and apply David’s custom hearts
    player:AddMaxHearts(-player:GetMaxHearts(), false)
    player:AddHearts(-player:GetHearts())
    player:AddGoldenHearts(-player:GetGoldenHearts())

    player:AddMaxHearts(STARTING_RED * 2, false)
    player:AddHearts(STARTING_RED * 2)
    player:AddGoldenHearts(STARTING_GOLD)

    -- Give starting collectibles
    for _, item in ipairs(STARTING_COLLECTIBLES) do
        player:AddCollectible(item, 0, false)
    end

    -- Give starting trinkets
    for _, trinket in ipairs(STARTING_TRINKETS) do
        player:AddTrinket(trinket)
    end

    -- ✅ Music tears handled automatically in Init below

    -- Trigger cache updates
    player:AddCacheFlags(
        CacheFlag.CACHE_DAMAGE
        | CacheFlag.CACHE_SPEED
        | CacheFlag.CACHE_FIREDELAY
        | CacheFlag.CACHE_LUCK
    )
    player:EvaluateItems()
end

-- =========================
-- On cache evaluation
-- =========================
function David:OnEvaluateCache(player, flag)
    if player:GetPlayerType() ~= self.ID then return end

    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + DAMAGE_MODIFIER
    elseif flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + SPEED_MODIFIER
    elseif flag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = math.max(1, player.MaxFireDelay + TEAR_DELAY_MODIFIER)
    elseif flag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + LUCK_MODIFIER
    end
end

-- =========================
-- Birthright effect: double boss damage
-- =========================
function David:OnEntityTakeDamage(entity, amount, flags, source, countdown)
    local player = source.Entity and source.Entity:ToPlayer()
    if not player then return end

    if player:GetPlayerType() == self.ID 
       and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        local npc = entity:ToNPC()
        if npc and npc:IsBoss() then
            return amount * 2
        end
    end
end

-- =========================
-- Init callbacks
-- =========================
function David:Init(mod)
    -- Player init
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
        David:OnPlayerInit(player)
    end)

    -- Cache updates
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
        David:OnEvaluateCache(player, flag)
    end)

    -- Birthright boss double damage
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
        return David:OnEntityTakeDamage(entity, amount, flags, source, countdown)
    end)

    -- ✅ Music tears auto-apply for David
    if MusicTears then
        mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
            local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
            if player and player:GetPlayerType() == David.ID then
                MusicTears:Apply(tear)
            end
        end)
        print("[David.lua] Music tears enabled for David")
    end

    -- EID Birthright description
    if EID then
        local icons = Sprite()
        icons:Load("gfx/ui/eid/david_eid.anm2", true)
        EID:addIcon("Player"..David.ID, "David", 0, 16, 16, 0, 0, icons)
        EID:addBirthright(David.ID, "David deals double damage to bosses.", "David")
    end
end

return David
