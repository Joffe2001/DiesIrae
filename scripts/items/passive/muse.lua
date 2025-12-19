local mod = DiesIraeMod
local game = Game()
local rng = RNG()
local sfx = SFXManager()

local muse = {}

muse.DOUBLE_CHANCE = 0.50
muse.COLLECTIBLE_DUPLICATE_CHANCE = 0.1


muse.ProcessedPickups = {}
muse.SpawnedCollectibles = {}

local function playMuseEffect(pos)
    Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.POOF01,
        0,
        pos,
        Vector.Zero,
        nil
    )

    sfx:Play(SoundEffect.SOUND_THUMBSUP, 1.0, 0, false, 1.0)
end

local function spawnSamePickup(pickup)
    local newPickup = Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        pickup.Variant,
        pickup.SubType,
        pickup.Position,
        Vector.Zero,
        nil
    )

    newPickup:GetData().FromMuse = true
    playMuseEffect(pickup.Position)
end

local function spawnSameCollectible(player, collectibleType)
    local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position)

    local pickup = Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        collectibleType,
        pos,
        Vector.Zero,
        nil
    )

    pickup:GetData().FromMuse = true
    playMuseEffect(pos)
end

---@param pickup EntityPickup
function muse:onPickupUpdate(pickup)
    if not pickup:IsDead() then return end
    if muse.ProcessedPickups[pickup.InitSeed] then return end
    muse.ProcessedPickups[pickup.InitSeed] = true

    if pickup:GetData().FromMuse then return end

    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.Items.Muse) then return end

    rng:SetSeed(pickup.InitSeed, 35)
    local roll = rng:RandomFloat()

    local canDouble =
        pickup.Variant == PickupVariant.PICKUP_COIN or
        pickup.Variant == PickupVariant.PICKUP_BOMB or
        pickup.Variant == PickupVariant.PICKUP_KEY or
        pickup.Variant == PickupVariant.PICKUP_HEART

    if canDouble and roll < muse.DOUBLE_CHANCE then
        spawnSamePickup(pickup)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, muse.onPickupUpdate)

---@param player EntityPlayer
function muse:onAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    if not player:HasCollectible(mod.Items.Muse) then return end
    if not firstTime then return end

    if collectibleType == mod.Items.Muse then return end

    if muse.SpawnedCollectibles[collectibleType] then return end

    rng:SetSeed(player:GetCollectibleRNG(mod.Items.Muse):Next(), 35)

    if rng:RandomFloat() <= muse.COLLECTIBLE_DUPLICATE_CHANCE then
        muse.SpawnedCollectibles[collectibleType] = true
        spawnSameCollectible(player, collectibleType)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, muse.onAddCollectible)

function muse:onNewRoom()
    muse.ProcessedPickups = {}
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, muse.onNewRoom)