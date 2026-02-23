local mod = DiesIraeMod
local TDavid = {}

local DAMAGE_MODIFIER = -1.5
local RIGHT_EYE_DAMAGE_BOOST = 1
local SPEED_MODIFIER = 0.2
local TEAR_DELAY_MODIFIER = 0.5
local LUCK_MODIFIER = -1

function TDavid:TearGFXApply(tear)
    if not (tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() 
        and tear.SpawnerEntity:ToPlayer():GetPlayerType() == mod.Players.TDavid) then return end
    tear:GetSprite():ReplaceSpritesheet(0, "gfx/proj/music_tears.png", true)
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, TDavid.TearGFXApply)

function TDavid:OnEvaluateCache(player, flag)
    if player:GetPlayerType() ~= mod.Players.TDavid then return end

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
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, TDavid.OnEvaluateCache)

function TDavid:OnFireTear(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end
    if player:GetPlayerType() == mod.Players.TDavid then
        local displacement = player:GetTearDisplacement()
        if displacement == 1 then
            tear.CollisionDamage = tear.CollisionDamage + RIGHT_EYE_DAMAGE_BOOST
            tear.Color = Color(0, 0, 0, 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, TDavid.OnFireTear)

function TDavid:OnEntityTakeDamage(entity, amount, flags, source, countdown)
    local player = source.Entity and source.Entity:ToPlayer()
    if not player then return end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, TDavid.OnEntityTakeDamage)
