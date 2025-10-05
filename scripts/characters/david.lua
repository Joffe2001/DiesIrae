local mod = DiesIraeMod

local David = {}

-- =========================
-- CONFIG: Starting stats
-- =========================

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

function David:TearGFXApply(tear)
    if not (tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() 
        and tear.SpawnerEntity:ToPlayer():GetPlayerType() == mod.Players.David) then return end
    tear:GetSprite():ReplaceSpritesheet(0, "gfx/proj/music_tears.png", true)
    --tear:GetData().isMusicTear = true
end

-- =========================
-- On player init
-- =========================
function David:OnPlayerInit(player)
    if player:GetPlayerType() ~= mod.Players.David then return end

    -- Add hair costume
    player:AddNullCostume(mod.Costumes.David_Hair)

    -- Give starting collectibles
    player:AddCollectible(mod.Items.Muse)

    -- Give starting trinkets
    player:AddTrinket(mod.Trinkets.Gaga)
end

-- =========================
-- On cache evaluation
-- =========================
function David:OnEvaluateCache(player, flag)
    if player:GetPlayerType() ~= mod.Players.David then return end

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

    if player:GetPlayerType() == mod.Players.David
       and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        local npc = entity:ToNPC()
        if npc and npc:IsBoss() then
            return amount * 2
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, David.OnPlayerInit)

-- Cache updates
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, David.OnEvaluateCache)

-- Birthright boss double damage
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, David.OnEntityTakeDamage)

-- ✅ Music tears auto-apply for David
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, David.TearGFXApply)

-- EID Birthright description
if EID then
    local icons = Sprite("gfx/ui/eid/david_eid.anm2", true)
    EID:addIcon("Player"..mod.Players.David, "David", 0, 16, 16, 0, 0, icons)
    EID:addBirthright(mod.Players.David, "David deals double damage to bosses.", "David")
end
