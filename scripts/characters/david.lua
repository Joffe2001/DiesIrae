local David = {}
David.ID = Isaac.GetPlayerTypeByName("David", false) 

local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/david_hair.anm2")

local STARTING_RED = 1
local STARTING_GOLD = 1

local DAMAGE_MODIFIER = 0.5
local SPEED_MODIFIER = 0.2
local TEAR_DELAY_MODIFIER = 1
local LUCK_MODIFIER = 1

local STARTING_COLLECTIBLES = {
    Isaac.GetItemIdByName("Muse")
}

local STARTING_TRINKETS = {
    Isaac.GetTrinketIdByName("Gaga")
}

local MusicTears = nil
local success, mt = pcall(require, "scripts.core.music_tears") 
if success then
    MusicTears = mt
else
    print("[David.lua] MusicTears module not found. Tears will be normal.")
end


function David:OnPlayerInit(player)
    if player:GetPlayerType() ~= self.ID then return end

    player:AddNullCostume(hairCostume)


    player:AddMaxHearts(-player:GetMaxHearts(), false)
    player:AddHearts(-player:GetHearts())
    player:AddGoldenHearts(-player:GetGoldenHearts())

    player:AddMaxHearts(STARTING_RED * 2, false)
    player:AddHearts(STARTING_RED * 2)
    player:AddGoldenHearts(STARTING_GOLD)

    for _, item in ipairs(STARTING_COLLECTIBLES) do
        player:AddCollectible(item, 0, false)
    end
    for _, trinket in ipairs(STARTING_TRINKETS) do
        player:AddTrinket(trinket)
    end

    player:AddCacheFlags(
        CacheFlag.CACHE_DAMAGE
        | CacheFlag.CACHE_SPEED
        | CacheFlag.CACHE_FIREDELAY
        | CacheFlag.CACHE_LUCK
    )
    player:EvaluateItems()
end

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

function David:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
        David:OnPlayerInit(player)
    end)

    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
        David:OnEvaluateCache(player, flag)
    end)

    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
        return David:OnEntityTakeDamage(entity, amount, flags, source, countdown)
    end)

    if MusicTears then
        mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
            local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
            if player and player:GetPlayerType() == David.ID then
                MusicTears:Apply(tear)
            end
        end)
        print("[David.lua] Music tears enabled for David")
    end

    if EID then
        local icons = Sprite()
        icons:Load("gfx/ui/eid/david_eid.anm2", true)
        EID:addIcon("Player"..David.ID, "David", 0, 16, 16, 0, 0, icons)
        EID:addBirthright(David.ID, "David deals double damage to bosses.", "David")
    end
end

return David
