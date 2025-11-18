local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

local PersonalBeggar = {}

local SV = {}
if type(SlotVariant) == "table" then
    SV.BEGGAR         = SlotVariant.BEGGAR
    SV.KEY_MASTER     = SlotVariant.KEY_MASTER
    SV.BOMB_BUM    = SlotVariant.BOMB_BUM
    SV.BATTERY_BUM = SlotVariant.BATTERY_BUM
    SV.ROTTEN_BEGGAR  = SlotVariant.ROTTEN_BEGGAR
    SV.DEVIL_BEGGAR   = SlotVariant.DEVIL_BEGGAR
else
    SV.BEGGAR         = 0
    SV.KEY_MASTER     = 8
    SV.BOMB_BUM    = 9
    SV.DEVIL_BEGGAR   = 10
    SV.BATTERY_BUM = 14
    SV.ROTTEN_BEGGAR  = 18
end

local beggarTypes = {
    {Type = EntityType.ENTITY_SLOT, Variant = SV.BEGGAR},
    {Type = EntityType.ENTITY_SLOT, Variant = SV.KEY_MASTER},
    {Type = EntityType.ENTITY_SLOT, Variant = SV.BOMB_BUM},
    {Type = EntityType.ENTITY_SLOT, Variant = SV.BATTERY_BUM},
    {Type = EntityType.ENTITY_SLOT, Variant = SV.ROTTEN_BEGGAR},
    {Type = EntityType.ENTITY_SLOT, Variant = SV.DEVIL_BEGGAR},
    {Type = EntityType.ENTITY_SLOT, Variant = mod.Entities.BEGGAR_Tech.Var} 
}

function PersonalBeggar:UseItem(_, rng, player)
    if not rng then
        rng = RNG()
        rng:SetSeed(Random(), 1)
    end

    local room = game:GetRoom()
    local spawnPos = room:FindFreePickupSpawnPosition(player.Position, 0, true)

    local index = rng:RandomInt(#beggarTypes) + 1
    local beggar = beggarTypes[index]

    local variant = beggar.Variant or 0

    Isaac.Spawn(beggar.Type, variant, 0, spawnPos, Vector.Zero, player)
    sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 1.0, 0, false, 1.0)
    Game():SpawnParticles(spawnPos, EffectVariant.POOF01, 1, 0, Color(1,1,1,1), 0)

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, PersonalBeggar.UseItem, mod.Items.PersonalBeggar)
