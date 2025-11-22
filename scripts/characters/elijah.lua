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

local AMOUNT_SHOP_BEGGAR_PER_SHOP = { 1, 3 }
local AMOUNT_PICKUP_BEGGAR_PER_SHOP = { 2, 3 }

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
}

local spawnElijahWill = {
    [PickupVariant.PICKUP_KEY] = elijahWill,
    [PickupVariant.PICKUP_BOMB] = elijahWill,
    [PickupVariant.PICKUP_COIN] = elijahWill,
}

local ItemRoomBeggar = {
    [RoomType.ROOM_TREASURE]    = mod.Entities.BEGGAR_TreasureElijah.Var,
    [RoomType.ROOM_SHOP]        = mod.Entities.BEGGAR_ShopElijah.Var,
    [RoomType.ROOM_DEVIL]       = mod.Entities.BEGGAR_DevilElijah.Var,
    [RoomType.ROOM_ANGEL]       = mod.Entities.BEGGAR_AngelElijah.Var,
    [RoomType.ROOM_SECRET]      = mod.Entities.BEGGAR_SecretElijah.Var,
    [RoomType.ROOM_ULTRASECRET] = mod.Entities.BEGGAR_UltraSecretElijah.Var,
    [RoomType.ROOM_PLANETARIUM] = mod.Entities.BEGGAR_PlanetariumElijah.Var,
    [RoomType.ROOM_ERROR]       = mod.Entities.BEGGAR_ERROR_Elijah.Var
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
    for _, variant in ipairs(customBeggar) do
        if npcVariant ~= variant then
            return false
        end
    end

    return true
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
    -- print("_________________________________")
    -- print((runSave.WillSpeed or 0) * 10)
    -- print((runSave.WillFireDelay or 0) * 5)
    -- print((runSave.WillDamage or 0) * 5)
    -- print((runSave.WillRange or 0) * 4)
    -- print((runSave.WillShotSpeed or 0) * 10)
    -- print((runSave.WillLuck or 0) * 2)
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

---Add starting item to Elijah.
---@param player EntityPlayer
function elijahFuncs:PlayerInit(player)
    if player:GetPlayerType() ~= elijah then return end

    player:AddCollectible(elijahStartingItem, STARTING_ITEM_CHARGES)
    player:AddSmeltedTrinket(STARTING_GULPED_TRINKET)
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, elijahFuncs.PlayerInit)


---Spawn Elijah's Will when starting the game
---@param continue boolean
function elijahFuncs:PostGameStarted(continue)
    if continue then return end
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    SetupHUDPickup()

    for _ = 1, STARTING_WILL_AMOUNT do
        local vec = RandomUnitCircle() * math.random(STARTING_WILL_VELOCITY)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY,
            game:GetRoom():GetCenterPos() + vec, vec, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, elijahFuncs.PostGameStarted)


---Delete Elijah's Will if not playing Elijah.
---@param pickup EntityPickup
function elijahFuncs:OnPickupInit(pickup)
    if PlayerManager.AnyoneIsPlayerType(elijah) then return end
    pickup:Remove()
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, elijahFuncs.OnPickupInit, elijahWill)


---Picking up a Elijah's Will
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
    if utils.HasBirthright(player) then
        StatUp(data)
    end

    player:AddCacheFlags(CacheFlag.CACHE_ALL, true)

    player:PlayExtraAnimation("Happy")
    sfx:Play(SoundEffect.SOUND_POWERUP1)
    pickup:Remove()
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, elijahFuncs.OnPickupCollision, elijahWill)


---Stats up by comparing with the number of Elijah's Will acquired.
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function elijahFuncs:EvaluateCache(player, cacheFlag)
    if player:GetPlayerType() ~= elijah then return end

    local CacheFunc = cacheFuncs[cacheFlag]
    if (not CacheFunc) then return end
    CacheFunc(player)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, elijahFuncs.EvaluateCache)


---Replace base pickup with the Elijah's Will.
---@param type EntityType
---@param variant integer
---@param seed integer
---@param spawner Entity | nil
---@return table | nil
function elijahFuncs:PreEntitySpawnWill(type, variant, _, _, _, spawner, seed)
    if type ~= EntityType.ENTITY_PICKUP then return end
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    if spawner and spawner:ToSlot() then
        if IsWhitelist(spawner.Variant) then return end
    end
    local will = spawnElijahWill[variant]
    if will then
        return { type, will, 0, seed }
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, elijahFuncs.PreEntitySpawnWill)


---Replace beggars with the custom beggars.
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


---Replace pedestals by the correct beggar
function elijahFuncs:PostNewRoom()
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    local roomType = game:GetRoom():GetType()
    local beggar = ItemRoomBeggar[roomType]
    if beggar == nil then return end

    for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local ped = entity:ToPickup()
        if not ped then return end

        local pos = ped.Position
        ped:Remove()
        Isaac.Spawn(EntityType.ENTITY_SLOT, beggar, 0, pos, Vector.Zero, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, elijahFuncs.PostNewRoom)


---Replace shop with beggars
function elijahFuncs:PostNewRoomShop()
    if not PlayerManager.AnyoneIsPlayerType(elijah) then return end

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_SHOP then return end

    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if ent.Type == EntityType.ENTITY_PICKUP
            or ent.Type == EntityType.ENTITY_SHOPKEEPER
            or ent.Type == EntityType.ENTITY_SLOT then
            ent:Remove()
        end
    end

    local numShopBeggars = math.random(AMOUNT_SHOP_BEGGAR_PER_SHOP[1], AMOUNT_PICKUP_BEGGAR_PER_SHOP[2])
    local extraBeggars   = math.random(AMOUNT_PICKUP_BEGGAR_PER_SHOP[1], AMOUNT_PICKUP_BEGGAR_PER_SHOP[2])

    local randomPool     = {
        mod.Entities.BEGGAR_BatteryElijah.Var,
        mod.Entities.BEGGAR_KeyElijah.Var,
        mod.Entities.BEGGAR_BombElijah.Var
    }

    local function spawnBeggar(variant, pos)
        Isaac.Spawn(EntityType.ENTITY_SLOT, variant, 0, pos, Vector.Zero, nil)
    end

    local center = room:GetCenterPos()
    local radius = 90
    local angleStep = 360 / (numShopBeggars + extraBeggars)
    local index = 0


    for _ = 1, numShopBeggars do
        local pos = center + Vector.FromAngle(index * angleStep) * radius
        spawnBeggar(mod.Entities.BEGGAR_ShopElijah.Var, pos)
        index = index + 1
    end

    for _ = 1, extraBeggars do
        local variant = randomPool[math.random(#randomPool)]
        local pos = center + Vector.FromAngle(index * angleStep) * radius
        spawnBeggar(variant, pos)
        index = index + 1
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, elijahFuncs.PostNewRoomShop)


---Sync Will amount with the coins of Elijah
---@param player EntityPlayer
function elijahFuncs:PostPlayerUpdate(player)
    if player:GetPlayerType() ~= elijah then return end
    local amount = math.floor(GetTotalWillStats(player))
    player:AddCoins(amount - player:GetNumCoins())
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, elijahFuncs.PostPlayerUpdate)