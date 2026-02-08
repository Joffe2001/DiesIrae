local mod = DiesIraeMod
local David = {}

include("scripts/characters/david_challenges/david_challenges_utils")
include("scripts/characters/david_challenges/david_challenges")
include("scripts/characters/david_challenges/david_challenges_utils_greed")
include("scripts/characters/david_challenges/david_challenges_greed")

function David:TearGFXApply(tear)
    if not (tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
        and tear.SpawnerEntity:ToPlayer():GetPlayerType() == mod.Players.David) then 
        return 
    end
    
    local variant = tear.Variant
    
    local safeVariants = {
        [TearVariant.BLUE] = true,
        [TearVariant.BLOOD] = true,
        [TearVariant.CUPID_BLUE] = true,
        [TearVariant.CUPID_BLOOD] = true,
        [TearVariant.DARK_MATTER] = true,
    }
    
    if safeVariants[variant] then
        tear:GetSprite():ReplaceSpritesheet(0, "gfx/proj/music_tears.png", true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, David.TearGFXApply)


function David:OnPlayerInit(player)
    if player:GetPlayerType() ~= mod.Players.David then return end
    player:AddCollectible(mod.Items.SlingShot)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, David.OnPlayerInit)

--STRONG boiiii
local DAMAGE_MODIFIER = 3
local SPEED_MODIFIER = 0.2
local TEAR_DELAY_MODIFIER = 1.3
local LUCK_MODIFIER = 3

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

-- David is immune to the Labyrinth curse
function David:OnCurseEval(curses)
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    
    if curses & LevelCurse.CURSE_OF_LABYRINTH > 0 then
        return curses ~ LevelCurse.CURSE_OF_LABYRINTH
    end
end
mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, David.OnCurseEval)

-- Birthright chords boost
function David:OnCardSpawn(pickup)
    if not PlayerManager.AnyoneIsPlayerType(mod.Players.David) then return end
    if pickup.Variant ~= PickupVariant.PICKUP_TAROTCARD then return end
    
    local player = Isaac.GetPlayer(0)
    local hasBirthright = player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    
    local replaceChance = hasBirthright and 0.35 or 0.12
    
    if math.random() < replaceChance then
        pickup:Morph(
            EntityType.ENTITY_PICKUP, 
            PickupVariant.PICKUP_TAROTCARD, 
            mod.Cards.DavidChord, 
            true, 
            true
        )
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, David.OnCardSpawn)

------------------------------------------------------------
-- EID 
------------------------------------------------------------
if EID then
    local icons = Sprite("gfx/ui/eid/icon_eid.anm2", true)
    EID:addIcon("Player"..mod.Players.David, "David", 0, 16, 16, 0, 0, icons)
    
    EID:addBirthright(
        mod.Players.David, 
        "David deals double damage to bosses.#David's Chord spawn rate greatly increased.", 
        "David"
    )
end

return David