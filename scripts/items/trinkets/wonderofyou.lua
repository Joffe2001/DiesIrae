local mod = DiesIraeMod

local WonderOfYou = {}
local game = Game()

function WonderOfYou:onPlayerDamage(player, amount, flags, source, countdown)
    local p = player:ToPlayer()
    if not p then return end
    if not p:HasTrinket(mod.Trinkets.WonderOfYou) then return end

    local chance = 0.05
    if p:HasGoldenTrinket(mod.Trinkets.WonderOfYou) then
        chance = 0.10
    end

    if math.random() < chance then
        WonderOfYou:smiteRoom(p)
    end
end
function WonderOfYou:smiteRoom(player)
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsEnemy() and entity:IsVulnerableEnemy() and not entity:IsBoss() then
            entity:Kill()
        end
    end

    game:ShakeScreen(15)
    SFXManager():Play(SoundEffect.SOUND_BLACK_POOF, 1.0, 0, false, 1.0)
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
    poof:GetSprite().Color = Color(0.8, 0.2, 1, 1, 0, 0, 0) 
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, WonderOfYou.onPlayerDamage, EntityType.ENTITY_PLAYER)

