local mod = DiesIraeMod
local David = {}

include("scripts/characters/david_challenges/david_challenges_utils")
include("scripts/characters/david_challenges/davidPlate")
include("scripts/characters/david_challenges/david_challenges")
include("scripts/characters/david_challenges/davidPlategreed")

function David:TearGFXApply(tear)
    if not (tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
        and tear.SpawnerEntity:ToPlayer():GetPlayerType() == mod.Players.David) then 
        return 
    end

    tear:GetSprite():ReplaceSpritesheet(0, "gfx/proj/music_tears.png", true)
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, David.TearGFXApply)


function David:OnPlayerInit(player)
    if player:GetPlayerType() ~= mod.Players.David then return end
    player:AddCollectible(mod.Items.SlingShot)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, David.OnPlayerInit)


local DAMAGE_MODIFIER = 1
local SPEED_MODIFIER = 0.2
local TEAR_DELAY_MODIFIER = 0.3
local LUCK_MODIFIER = 1

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
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, David.OnEvaluateCache)


function David:OnEntityTakeDamage(entity, amount, flags, source)
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
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, David.OnEntityTakeDamage)


if EID then
    local icons = Sprite("gfx/ui/eid/icon_eid.anm2", true)
    EID:addIcon("Player"..mod.Players.David, "David", 0, 16, 16, 0, 0, icons)
    EID:addBirthright(mod.Players.David, "David deals double damage to bosses.", "David")
end

return David