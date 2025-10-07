local mod = DiesIraeMod

local Muse = {}
local game = Game()

local tarotCards = {
    Card.CARD_FOOL, Card.CARD_MAGICIAN, Card.CARD_HIGH_PRIESTESS, Card.CARD_EMPRESS,
    Card.CARD_HIEROPHANT, Card.CARD_CHARIOT, Card.CARD_JUSTICE, Card.CARD_HANGED_MAN,
    Card.CARD_DEATH, Card.CARD_TEMPERANCE, Card.CARD_DEVIL, Card.CARD_TOWER,
    Card.CARD_STAR, Card.CARD_MOON, Card.CARD_SUN, Card.CARD_JUDGEMENT, Card.CARD_WORLD,
    Card.CARD_REVERSE_FOOL, Card.CARD_REVERSE_MAGICIAN, Card.CARD_REVERSE_HIGH_PRIESTESS,
    Card.CARD_REVERSE_EMPRESS, Card.CARD_REVERSE_HIEROPHANT, Card.CARD_REVERSE_CHARIOT,
    Card.CARD_REVERSE_JUSTICE, Card.CARD_REVERSE_HANGED_MAN, Card.CARD_REVERSE_DEATH,
    Card.CARD_REVERSE_TEMPERANCE, Card.CARD_REVERSE_DEVIL, Card.CARD_REVERSE_TOWER,
    Card.CARD_REVERSE_STAR, Card.CARD_REVERSE_MOON, Card.CARD_REVERSE_SUN,
    Card.CARD_REVERSE_JUDGEMENT, Card.CARD_REVERSE_WORLD
}

local runes = {
    Card.RUNE_HAGALAZ, Card.RUNE_EHWAZ, Card.RUNE_JERA, Card.RUNE_ANSUZ,
    Card.RUNE_PERTHRO, Card.RUNE_DAGAZ, Card.RUNE_BERKANO, Card.RUNE_ALGIZ
}

local function GetUnlockedCards(list)
    local unlocked = {}
    for _, c in ipairs(list) do
        local cfg = Isaac.GetItemConfig():GetCard(c)
        if cfg and cfg:IsAvailable() then
            table.insert(unlocked, c)
        end
    end
    return unlocked
end

local nonHeartChoices = {
    {PickupVariant.PICKUP_COIN,        0, 50}, -- penny
    {PickupVariant.PICKUP_BOMB,        0, 30}, -- bomb
    {PickupVariant.PICKUP_KEY,         0, 30}, -- key
    {PickupVariant.PICKUP_LIL_BATTERY, 0, 10}, -- battery
    {PickupVariant.PICKUP_CHEST,       0, 10}, -- wooden chest
}
local function SpawnNonHeartPickup(rng, pos, spawner)
    local total = 0
    for _, e in ipairs(nonHeartChoices) do total = total + e[3] end
    local pick = rng:RandomInt(total) + 1
    local acc = 0
    local chosen = nonHeartChoices[1]
    for _, e in ipairs(nonHeartChoices) do
        acc = acc + e[3]
        if pick <= acc then chosen = e; break end
    end
    Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        chosen[1],
        chosen[2],
        pos,
        RandomVector() * 3,
        spawner
    )
end

function Muse:OnPlayerDamaged(entity, amount, damageFlags, source, countdown)
    local player = entity:ToPlayer()
    if not player or not player:HasCollectible(mod.Items.Muse) then return end
    if amount <= 0 then return end 

    local rng = player:GetCollectibleRNG(mod.Items.Muse)
    local roll = rng:RandomFloat()
    if roll < 0.20 then
        local eligible = GetUnlockedCards(tarotCards)
        if #eligible > 0 then
            local card = eligible[rng:RandomInt(#eligible) + 1]
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card, player.Position, RandomVector()*3, player)
        else
            SpawnNonHeartPickup(rng, player.Position, player)
        end

    elseif roll < 0.30 then
        local eligible = GetUnlockedCards(runes)
        if #eligible > 0 then
            local rune = eligible[rng:RandomInt(#eligible) + 1]
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, player.Position, RandomVector()*3, player)
        else
            SpawnNonHeartPickup(rng, player.Position, player)
        end

    elseif roll < 0.50 then
        SpawnNonHeartPickup(rng, player.Position, player)

    elseif roll < 0.51 then
        local pool  = game:GetItemPool()
        local room  = game:GetRoom()
        local poolType = pool:GetPoolForRoom(room:GetType(), rng:Next())
        local itemID = pool:GetCollectible(poolType, false, rng:Next())
        if itemID and itemID ~= 0 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, player.Position, RandomVector()*3, player)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Muse.OnPlayerDamaged, EntityType.ENTITY_PLAYER)

if EID then
    EID:assignTransformation("collectible", mod.Items.Muse, "Dad's Playlist")
end
