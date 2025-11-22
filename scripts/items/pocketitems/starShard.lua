local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local itemConfig = Isaac.GetItemConfig()


local function GetStarTagItems()
    local list = {}
    local maxID = itemConfig:GetCollectibles().Size - 1

    for id = 1, maxID do
        local cfg = itemConfig:GetCollectible(id)
        if cfg
        and cfg:IsAvailable()
        and cfg:HasTags(ItemConfig.TAG_STARS) then
            table.insert(list, id)
        end
    end
    return list
end

function mod:useStarShard(card, player, flags)
    if card ~= mod.Cards.StarShard then
        return
    end

    local pickups = Isaac.FindByType(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        -1,
        false,
        false
    )

    local hasPedestal = #pickups > 0

    if not hasPedestal then
        player:AddSoulHearts(2)
        sfx:Play(SoundEffect.SOUND_HOLY, 1.0)
        return true
    end
    local combinedPool = {}

    local starItems = GetStarTagItems()
    for _, id in ipairs(starItems) do
        table.insert(combinedPool, id)
    end
    local pool = game:GetItemPool()
    local pItem = pool:GetCollectible(ItemPoolType.POOL_PLANETARIUM, false, player:GetCollectibleRNG(mod.Cards.StarShard):Next())

    if pItem and pItem > 0 then
        table.insert(combinedPool, pItem)
    end

    if #combinedPool == 0 then
        table.insert(combinedPool, CollectibleType.COLLECTIBLE_GEMINI)
    end
    local rng = player:GetCardRNG(mod.Cards.StarShard)

    for _, entity in ipairs(pickups) do
        local pickup = entity:ToPickup()
        if pickup and pickup.SubType > 0 then

            local newItem = combinedPool[rng:RandomInt(#combinedPool) + 1]
            Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                EffectVariant.POOF01,
                0,
                pickup.Position,
                Vector.Zero,
                player
            )

            sfx:Play(SoundEffect.SOUND_EDEN_GLITCH, 1.0)

            pickup:Morph(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                newItem,
                true
            )
        end
    end

    return true
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useStarShard)
