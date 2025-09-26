local WonderOfYou = {}
WonderOfYou.TRINKET_ID = Enums.Trinkets.WonderOfYou
local game = Game()

function WonderOfYou:onPlayerDamage(player, amount, flags, source, countdown)
    local p = player:ToPlayer()
    if not p then return end
    if not p:HasTrinket(WonderOfYou.TRINKET_ID) then return end

    -- Base chance 5%, doubled to 10% if golden trinket
    local chance = 0.05
    if p:HasGoldenTrinket(WonderOfYou.TRINKET_ID) then
        chance = 0.10
    end

    if math.random() < chance then
        WonderOfYou:smiteRoom(p)
    end
end

-- Kill all non-boss enemies in the room
function WonderOfYou:smiteRoom(player)
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsEnemy() and entity:IsVulnerableEnemy() and not entity:IsBoss() then
            entity:Kill()
        end
    end

    -- Some flair
    game:ShakeScreen(15)
    SFXManager():Play(SoundEffect.SOUND_BLACK_POOF, 1.0, 0, false, 1.0)
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
    poof:GetSprite().Color = Color(0.8, 0.2, 1, 1, 0, 0, 0) -- purple burst
end

-- Init callbacks
function WonderOfYou:Init(mod)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, WonderOfYou.onPlayerDamage, EntityType.ENTITY_PLAYER)

    if EID then
        EID:addTrinket(
            WonderOfYou.TRINKET_ID,
            "Taking damage has a 5% chance to instantly kill all non-boss enemies in the room.#Golden: 10%",
            "Wonder of You",
            "en_us"
        )
    end
end

return WonderOfYou
