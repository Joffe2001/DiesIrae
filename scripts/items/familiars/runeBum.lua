local mod      = DiesIraeMod
local bumUtils = include("scripts.items.familiars.bumUtils")

local RUNE_BUM     = mod.Entities.FAMILIAR_RuneBum.Var
local DROP_CHANCE  = 0.5

local sfx = SFXManager()

---@class RuneBum
local runeBum = {}

runeBum.Item = mod.Items.RuneBum

local validRuneOrSoul = {
    [Card.RUNE_HAGALAZ]  = true,
    [Card.RUNE_JERA]     = true,
    [Card.RUNE_EHWAZ]    = true,
    [Card.RUNE_DAGAZ]    = true,
    [Card.RUNE_ANSUZ]    = true,
    [Card.RUNE_PERTHRO]  = true,
    [Card.RUNE_BERKANO]  = true,
    [Card.RUNE_ALGIZ]    = true,
    [Card.RUNE_BLACK]    = true,
    [Card.CARD_SOUL_ISAAC]       = true,
    [Card.CARD_SOUL_MAGDALENE]   = true,
    [Card.CARD_SOUL_CAIN]        = true,
    [Card.CARD_SOUL_JUDAS]       = true,
    [Card.CARD_SOUL_BLUEBABY]    = true,
    [Card.CARD_SOUL_EVE]         = true,
    [Card.CARD_SOUL_SAMSON]      = true,
    [Card.CARD_SOUL_AZAZEL]      = true,
    [Card.CARD_SOUL_LAZARUS]     = true,
    [Card.CARD_SOUL_EDEN]        = true,
    [Card.CARD_SOUL_LOST]        = true,
    [Card.CARD_SOUL_LILITH]      = true,
    [Card.CARD_SOUL_KEEPER]      = true,
    [Card.CARD_SOUL_APOLLYON]    = true,
    [Card.CARD_SOUL_FORGOTTEN]   = true,
    [Card.CARD_SOUL_BETHANY]     = true,
    [Card.CARD_SOUL_JACOB]       = true,
}

runeBum.Accepts = {
    [PickupVariant.PICKUP_TAROTCARD] = true,
}

runeBum.FollowDistance = 40
runeBum.ReachDistance  = 20

function runeBum.OnInit(fam)
    local data = fam:GetData()
    data.RunesEaten = 0
end

function runeBum.OnUpdate(fam)
	fam:followParent()
end

function runeBum.Reward(fam)
    local data   = fam:GetData()
    local rng    = fam:GetDropRNG()
    local pickup = data.TargetPickup
    if not pickup then
        return false
    end

    if not validRuneOrSoul[pickup.SubType] then
        return false
    end
    sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1.0, 0, false, 1.0)

    data.RunesEaten = (data.RunesEaten or 0) + 1

    return rng:RandomFloat() < DROP_CHANCE
end

function runeBum.DoReward(fam)
    local data = fam:GetData()
    local rng  = fam:GetDropRNG()
    local pool = Game():GetItemPool()

    local pos = Isaac.GetFreeNearPosition(fam.Position, 20)

    sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1.0, 0, false, 1.0)

    local roll = rng:RandomFloat()
    local targetQuality = 0

    if roll < 0.60 then
        targetQuality = 0
    elseif roll < 0.90 then
        targetQuality = 1
    else
        targetQuality = 2
    end

    local selectedItem = 0
    local config = Isaac.GetItemConfig()

    for _ = 1, 50 do
        local item = pool:GetCollectible(ItemPoolType.POOL_TREASURE, false)
        local entry = config:GetCollectible(item)

        if entry and entry.Quality == targetQuality then
            selectedItem = item
            break
        end
    end

    if selectedItem == 0 then
        selectedItem = pool:GetCollectible(ItemPoolType.POOL_TREASURE, false)
    end

    Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        selectedItem,
        pos,
        Vector.Zero,
        fam
    )
    data.RunesEaten = 0
end

bumUtils.RegisterBum(RUNE_BUM, runeBum)

return runeBum
