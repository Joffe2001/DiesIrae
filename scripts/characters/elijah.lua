---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class Utils
local utils = include("scripts.core.utils")

local save = mod.SaveManager


--- MAGIC NUMBERS
---

local HUD_PICKUP_PATH = "gfx/ui/HUD/hudpickups.png"

local STARTING_ITEM_CHARGES = 3
local STARTING_WILL_AMOUNT = 6
local STARTING_WILL_VELOCITY = 4

local STARTING_GULPED_TRINKET = TrinketType.TRINKET_STORE_KEY

WILL_SPEED_UP = 0.1
WILL_TEARS_UP = 0.2
WILL_DAMAGE_UP = 0.2
WILL_RANGE_UP = 0.25
WILL_SHOT_SPEED_UP = 0.1
WILL_LUCK_UP = 0.5

--- Definitions
---

---@type PlayerType
local elijah = mod.Players.Elijah

---@type PickupVariant
local elijahWill = mod.Entities.PICKUP_ElijahsWill.Var
local elijahWillB = mod.Entities.PICKUP_ElijahsWillB.Var

---@type CollectibleType
local elijahStartingItem = mod.Items.PersonalBeggar

local customBeggar = {
    [SlotVariant.BEGGAR] = mod.Entities.BEGGAR_Elijah.Var,
    [mod.Entities.BEGGAR_Tech.Var] = mod.Entities.BEGGAR_TechElijah.Var,
    [SlotVariant.BOMB_BUM] = mod.Entities.BEGGAR_BombElijah.Var,
    [SlotVariant.KEY_MASTER] = mod.Entities.BEGGAR_KeyElijah.Var,
    [SlotVariant.ROTTEN_BEGGAR] = mod.Entities.BEGGAR_RottenElijah.Var,
    [SlotVariant.BATTERY_BUM] = mod.Entities.BEGGAR_BatteryElijah.Var,
    [PickupVariant.PICKUP_MOMSCHEST] = mod.Entities.BEGGAR_MomBoxElijah.Var,
    [SlotVariant.DONATION_MACHINE] = mod.Entities.BEGGAR_Elijah.Var,
    [SlotVariant.GREED_DONATION_MACHINE] = mod.Entities.BEGGAR_Elijah.Var,
    [SlotVariant.SHELL_GAME] = mod.Entities.BEGGAR_Elijah.Var,
    [mod.Entities.BEGGAR_JYS.Var] = mod.Entities.BEGGAR_JYS_Elijah.Var,
    [mod.Entities.BEGGAR_Goldsmith.Var] = mod.Entities.BEGGAR_Goldsmith_Elijah.Var,
    [mod.Entities.BEGGAR_Familiars.Var] = mod.Entities.BEGGAR_Familiars_Elijah.Var,
}

local spawnElijahWill = {
    [PickupVariant.PICKUP_KEY] = elijahWill,
    [PickupVariant.PICKUP_BOMB] = elijahWill,
    [PickupVariant.PICKUP_COIN] = elijahWill,
}

local ItemRoomBeggar = {
    [RoomType.ROOM_TREASURE]    = mod.Entities.BEGGAR_TreasureElijah.Var,
    [RoomType.ROOM_SHOP]        = mod.Entities.BEGGAR_ShopElijah.Var,
    [RoomType.ROOM_DEVIL]       = mod.Entities.BEGGAR_DemonElijah.Var,
    [RoomType.ROOM_ANGEL]       = mod.Entities.BEGGAR_AngelElijah.Var,
    [RoomType.ROOM_SECRET]      = mod.Entities.BEGGAR_SecretElijah.Var,
    [RoomType.ROOM_ULTRASECRET] = mod.Entities.BEGGAR_UltraSecretElijah.Var,
    [RoomType.ROOM_PLANETARIUM] = mod.Entities.BEGGAR_PlanetariumElijah.Var,
    [RoomType.ROOM_LIBRARY]     = mod.Entities.BEGGAR_LibraryElijah.Var,
    [RoomType.ROOM_ERROR]       = mod.Entities.BEGGAR_ERROR_Elijah.Var
}

local CHAOS_ELIJAH_BEGGARS = {
    mod.Entities.BEGGAR_TreasureElijah.Var,
    mod.Entities.BEGGAR_ShopElijah.Var,
    mod.Entities.BEGGAR_DemonElijah.Var,
    mod.Entities.BEGGAR_AngelElijah.Var,
    mod.Entities.BEGGAR_SecretElijah.Var,
    mod.Entities.BEGGAR_UltraSecretElijah.Var,
    mod.Entities.BEGGAR_PlanetariumElijah.Var,
    mod.Entities.BEGGAR_LibraryElijah.Var,
    mod.Entities.BEGGAR_ERROR_Elijah.Var,
    mod.Entities.BEGGAR_Elijah.Var,
    mod.Entities.BEGGAR_BombElijah.Var,
    mod.Entities.BEGGAR_KeyElijah.Var,
    mod.Entities.BEGGAR_RottenElijah.Var,
    mod.Entities.BEGGAR_BatteryElijah.Var,
}

---@alias statUpFun fun(data: table)
---@type statUpFun[]
local statsUpFuncs = {
    function(data)
        data.WillSpeed = (data.WillSpeed or 0) + WILL_SPEED_UP
    end,
    function(data)
        data.WillFireDelay = (data.WillFireDelay or 0) + WILL_TEARS_UP
    end,
    function(data)
        data.WillDamage = (data.WillDamage or 0) + WILL_DAMAGE_UP
    end,
    function(data)
        data.WillRange = (data.WillRange or 0) + WILL_RANGE_UP
    end,
    function(data)
        data.WillShotSpeed = (data.WillShotSpeed or 0) + WILL_SHOT_SPEED_UP
    end,
    function(data)
        data.WillLuck = (data.WillLuck or 0) + WILL_LUCK_UP
    end,
}

---@alias cacheFun fun(player: EntityPlayer)
---@type table<CacheFlag, cacheFun>
local cacheFuncs = {
    [CacheFlag.CACHE_SPEED] = function(player)
        player.MoveSpeed = player.MoveSpeed + (save.GetRunSave(player).WillSpeed or 0)
    end,
    [CacheFlag.CACHE_FIREDELAY] = function(player)
        player.MaxFireDelay = utils.TearsUp(player.MaxFireDelay, save.GetRunSave(player).WillFireDelay or 0)
    end,
    [CacheFlag.CACHE_DAMAGE] = function(player)
        player.Damage = player.Damage + (save.GetRunSave(player).WillDamage or 0)
    end,
    [CacheFlag.CACHE_RANGE] = function(player)
        player.TearRange = player.TearRange + 40 * (save.GetRunSave(player).WillRange or 0)
    end,
    [CacheFlag.CACHE_SHOTSPEED] = function(player)
        player.ShotSpeed = player.ShotSpeed + (save.GetRunSave(player).WillShotSpeed or 0)
    end,
    [CacheFlag.CACHE_LUCK] = function(player)
        player.Luck = player.Luck + (save.GetRunSave(player).WillLuck or 0)
    end,
}

local elijahFuncs = {}

--- Functions
---

---return true if in the Beggar table
---@param npcVariant SlotVariant
local function IsWhitelist(npcVariant)
    for _, variant in pairs(customBeggar) do
        if npcVariant == variant then
            return true
        end
    end
    return false
end

local function IsBlacklisted(itemID)
    for _, id in ipairs(mod.Pools.Elijah_blacklist) do
        if id == itemID then
            return true
        end
    end
    return false
end

local function IsSlotBlacklisted(variant)
    for _, v in ipairs(mod.Pools.Slot_blacklist) do
        if v == variant then
            return true
        end
    end
    return false
end

--- math
---@return Vector
local function RandomUnitCircle()
    local angle = math.random() * math.pi * 2
    return Vector(math.cos(angle), math.sin(angle))
end

local function SetupHUDPickup()
    local sprite = game:GetHUD():GetPickupsHUDSprite()
    sprite:ReplaceSpritesheet(0, HUD_PICKUP_PATH)
    sprite:LoadGraphics()
end

local function GetTotalWillStats(player)
    local runSave = save.GetRunSave(player)
    return
        (runSave.WillSpeed or 0) * 10 +
        (runSave.WillFireDelay or 0) * 5 +
        (runSave.WillDamage or 0) * 5 +
        (runSave.WillRange or 0) * 4 +
        (runSave.WillShotSpeed or 0) * 10 +
        (runSave.WillLuck or 0) * 2
end

--- Callbacks
---
----------------------------------------------
---Add starting item to Elijah.
----------------------------------------------
---@param player EntityPlayer
function elijahFuncs:PlayerInit(player)
    if player:GetPlayerType() ~= elijah then return end

    player:AddCollectible(elijahStartingItem, STARTING_ITEM_CHARGES)
    player:AddSmeltedTrinket(STARTING_GULPED_TRINKET)
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, elijahFuncs.PlayerInit)

----------------------------------------------
---Spawn Elijah's Will when starting the game
-------------------------------------------------
---@param continue boolean
function elijahFuncs:PostGameStarted(continue)
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end
    SetupHUDPickup()
    if continue then return end

    for _ = 1, STARTING_WILL_AMOUNT do
        local vec = RandomUnitCircle() * math.random(STARTING_WILL_VELOCITY)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY,
            game:GetRoom():GetCenterPos() + vec, vec, nil)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, elijahFuncs.PostGameStarted)

local hudFixed = false

function elijahFuncs:PostRender()
    if hudFixed then return end
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    SetupHUDPickup()
    hudFixed = true
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, elijahFuncs.PostRender)
----------------------------------------------
---Delete Elijah's Will if not playing Elijah.
----------------------------------------------
---@param pickup EntityPickup
function elijahFuncs:OnPickupInit(pickup)
    if PlayerManager.AnyoneIsPlayerType(elijah) then return end
    pickup:Remove()
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, elijahFuncs.OnPickupInit, elijahWill)

----------------------------------------------
---Picking up a Elijah's Will
----------------------------------------------
---@param pickup EntityPickup
---@param collider Entity
---@return boolean | nil
function elijahFuncs:OnPickupCollision(pickup, collider)
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= elijah then return false end

    local data = save.GetRunSave(player)

    local stat = math.random(#statsUpFuncs)
    StatUp = statsUpFuncs[stat]
    StatUp(data)
    player:AddCacheFlags(CacheFlag.CACHE_ALL, true)

    player:PlayExtraAnimation("Happy")
    pickup:Remove()
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, elijahFuncs.OnPickupCollision, elijahWill)

function elijahFuncs:OnPickupCollisionWillB(pickup, collider)
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= elijah then return false end

    local data = save.GetRunSave(player)

    data.WillBStats = data.WillBStats or {
        WillSpeed = 0,
        WillFireDelay = 0,
        WillDamage = 0,
        WillRange = 0,
        WillShotSpeed = 0,
        WillLuck = 0,
    }

    local stat = math.random(#statsUpFuncs)
    local StatUp = statsUpFuncs[stat]

    StatUp(data)
    StatUp(data.WillBStats)

    player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    player:PlayExtraAnimation("Happy")
    pickup:Remove()
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, elijahFuncs.OnPickupCollisionWillB, elijahWillB)

----------------------------------------------
---Stats up by comparing with the number of Elijah's Will acquired.
-------------------------------------------------
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function elijahFuncs:EvaluateCache(player, cacheFlag)
    if player:GetPlayerType() ~= elijah then return end

    local runSave = save.GetRunSave(player)
    local CacheFunc = cacheFuncs[cacheFlag]
    if (not CacheFunc) then return end
    CacheFunc(player)

    if utils.HasBirthright(player) and runSave.WillBStats then
        local temp = runSave
        runSave = runSave.WillBStats
        CacheFunc(player)
        runSave = temp
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, elijahFuncs.EvaluateCache)

----------------------------------------------
---Replace base pickup with the Elijah's Will.
----------------------------------------------
---@param type EntityType
---@param variant integer
---@param seed integer
---@param spawner Entity | nil
---@return table | nil

local WILL_B_CHANCE = 0.15

function elijahFuncs:PreEntitySpawnWill(type, variant, _, _, _, spawner, seed)
    if type ~= EntityType.ENTITY_PICKUP then return end
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    if spawner and spawner:ToSlot() then
        if IsWhitelist(spawner.Variant) then return end
    end
    local will = spawnElijahWill[variant]
    if will then
        local player = PlayerManager.FirstPlayerByType(elijah)

        if player and utils.HasBirthright(player) then
            local rng = RNG()
            rng:SetSeed(seed, 35)

            if rng:RandomFloat() < WILL_B_CHANCE then
                return { type, elijahWillB, 0, seed }
            end
        end
        return { type, elijahWill, 0, seed }
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, elijahFuncs.PreEntitySpawnWill)

----------------------------------------------
---Replace beggars with the custom beggars.
----------------------------------------------
---@param type EntityType
---@param variant integer
---@param subtype integer
---@param seed integer
---@return table | nil
function elijahFuncs:PreEntitySpawn(type, variant, subtype, _, _, _, seed)
    if type ~= EntityType.ENTITY_SLOT then return end
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    local npc = customBeggar[variant]
    if npc then
        return { type, npc, subtype, seed }
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, elijahFuncs.PreEntitySpawn)

---Make sure every pickup is will
function elijahFuncs:PostPickupInitConvert(pickup)
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end
    
    local will = spawnElijahWill[pickup.Variant]
    if not will then return end
    
    if pickup.SpawnerEntity and pickup.SpawnerEntity:ToSlot() then
        if IsWhitelist(pickup.SpawnerEntity.Variant) then
            return
        end
    end
    
    local pos = pickup.Position
    local vel = pickup.Velocity
    pickup:Remove()
    
    local newPickup = Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        will,
        0,
        pos,
        vel,
        nil
    )
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, elijahFuncs.PostPickupInitConvert, PickupVariant.PICKUP_COIN)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, elijahFuncs.PostPickupInitConvert, PickupVariant.PICKUP_KEY)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, elijahFuncs.PostPickupInitConvert, PickupVariant.PICKUP_BOMB)

----------------------------------------------
---Replace pedestals by the correct beggar
----------------------------------------------
function elijahFuncs:PostNewRoom()
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    local room = game:GetRoom()
    if room:GetType() == RoomType.ROOM_SHOP then return end

    local roomData = save.GetRoomSave(nil)
    if roomData.beggarSwap then return end
    roomData.beggarSwap = true

    local player = PlayerManager.FirstPlayerByType(elijah)
    if not player then return end

----------------------------------------------
---Chaos synergy
----------------------------------------------
    local hasChaos = player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS)
    for _, entity in ipairs(
        Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    ) do
        local ped = entity:ToPickup()
        if ped then
            local beggar

            if hasChaos then
                local rng = ped:GetDropRNG()
                beggar = CHAOS_ELIJAH_BEGGARS[rng:RandomInt(#CHAOS_ELIJAH_BEGGARS) + 1]
            else
                beggar = ItemRoomBeggar[room:GetType()]
            end

            if beggar then
                local pos = ped.Position
                local vel = ped.Velocity
                ped:Remove()
                Isaac.Spawn(EntityType.ENTITY_SLOT, beggar, 0, pos, vel, nil)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, elijahFuncs.PostNewRoom)

----------------------------------------------
---Sync Will amount with the coins of Elijah
----------------------------------------------
---@param player EntityPlayer
function elijahFuncs:PostPlayerUpdate(player)
    if player:GetPlayerType() ~= elijah then return end
    local amount = math.floor(GetTotalWillStats(player))
    player:AddCoins(amount - player:GetNumCoins())
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, elijahFuncs.PostPlayerUpdate)

----------------------------------------------
-- Shop change
----------------------------------------------
local function SwapElijahShops()
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    local level = Game():GetLevel()
    local rooms = level:GetRooms()

    for i = 0, rooms.Size - 1 do
        local roomDesc = rooms:Get(i)
        local data = roomDesc.Data

        if data
        and data.Type == RoomType.ROOM_SHOP
        and (data.Shape == RoomShape.ROOMSHAPE_1x1
             or data.Shape == RoomShape.ROOMSHAPE_2x1) then

            local isGreed = data.Shape == RoomShape.ROOMSHAPE_2x1
            local dimension = isGreed and 1 or 0

            local newRoom = RoomConfigHolder.GetRandomRoom(
                roomDesc.SpawnSeed,
                false,
                StbType.SPECIAL_ROOMS,
                RoomType.ROOM_SHOP,
                data.Shape,
                1001, 1020,
                0, 10,
                dimension,
                6
            )

            if newRoom then
                roomDesc.Data = newRoom
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SwapElijahShops)

function elijahFuncs:PostPickupUpdateBlacklist(pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end
    
    if IsBlacklisted(pickup.SubType) then
        pickup:Remove()
        
        local rng = pickup:GetDropRNG()
        local item = game:GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, true, rng:Next())
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            item,
            pickup.Position,
            Vector.Zero,
            pickup
        )
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, elijahFuncs.PostPickupUpdateBlacklist, PickupVariant.PICKUP_COLLECTIBLE)

----------------------------------------------
-- Arcade change
----------------------------------------------
local function SwapElijahArcades()
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    local level = game:GetLevel()
    local rooms = level:GetRooms()

    for i = 0, rooms.Size - 1 do
        local roomDesc = rooms:Get(i)
        local data = roomDesc.Data

        if data and data.Type == RoomType.ROOM_ARCADE then
            local newRoom = RoomConfigHolder.GetRandomRoom(
                roomDesc.SpawnSeed,
                false,
                StbType.SPECIAL_ROOMS,
                RoomType.ROOM_ARCADE,
                RoomShape.ROOMSHAPE_1x1,
                1001, 1010,
                0, 10,
                0,
                6
            )

            if newRoom then
                roomDesc.Data = newRoom
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SwapElijahArcades)

----------------------------------------------
---Slot blacklist
----------------------------------------------
function elijahFuncs:PostSlotInitBlacklist(slot)
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end
    
    if IsSlotBlacklisted(slot.Variant) then
        slot:Remove()
        game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, slot.Position, Vector.Zero, nil, 0, 0)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, elijahFuncs.PostSlotInitBlacklist)


----------------------------------------------
---EID
----------------------------------------------

--Birthright
if EID then
    local icons = Sprite("gfx/ui/eid/icon_eid.anm2", true)
    EID:addIcon("Player"..mod.Players.Elijah, "Elijah", 0, 16, 16, 0, 0, icons)
    EID:addBirthright(mod.Players.Elijah, "Wills can become stronger.", "Elijah")
end

--Chaos
if EID then
    EID:addDescriptionModifier(
        "Chaos_Elijah",

        function(descObj)
            if descObj.ObjType ~= EntityType.ENTITY_PICKUP then return false end
            if descObj.ObjVariant ~= PickupVariant.PICKUP_COLLECTIBLE then return false end
            if descObj.ObjSubType ~= CollectibleType.COLLECTIBLE_CHAOS then return false end

            local player = EID:ClosestPlayerTo(descObj.Entity)
            return player and player:GetPlayerType() == mod.Players.Elijah
        end,

        function(descObj)
            descObj.Description =
                descObj.Description ..
                "#{{Player" .. mod.Players.Elijah .. "}}{{ColorRainbow}} Shuffle all beggars as well (Exept the beggars that are in the shop){{CR}}"

            return descObj
        end
    )
end