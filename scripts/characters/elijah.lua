---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class Utils
local utils = include("scripts.core.utils")

local save = mod.SaveManager

local HUD_PICKUP_PATH = "gfx/ui/HUD/hudpickups.png"

local STARTING_ITEM_CHARGES = 3
local STARTING_WILL_AMOUNT = 6
local STARTING_WILL_VELOCITY = 4

local STARTING_GULPED_TRINKET = TrinketType.TRINKET_STORE_KEY

WILL_SPEED_UP = 0.05
WILL_TEARS_UP = 0.2
WILL_DAMAGE_UP = 0.2
WILL_RANGE_UP = 0.2
WILL_SHOT_SPEED_UP = 0.1
WILL_LUCK_UP = 0.1

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
    [SlotVariant.BEGGAR]                      = mod.Entities.BEGGAR_Elijah.Var,
    [mod.Entities.BEGGAR_Tech.Var]            = mod.Entities.BEGGAR_TechElijah.Var,
    [SlotVariant.BOMB_BUM]                    = mod.Entities.BEGGAR_BombElijah.Var,
    [SlotVariant.KEY_MASTER]                  = mod.Entities.BEGGAR_KeyElijah.Var,
    [SlotVariant.ROTTEN_BEGGAR]               = mod.Entities.BEGGAR_RottenElijah.Var,
    [SlotVariant.BATTERY_BUM]                 = mod.Entities.BEGGAR_BatteryElijah.Var,
    [SlotVariant.DONATION_MACHINE]            = mod.Entities.BEGGAR_Elijah.Var,
    [SlotVariant.GREED_DONATION_MACHINE]      = mod.Entities.BEGGAR_Elijah.Var,
    [SlotVariant.SHELL_GAME]                  = mod.Entities.BEGGAR_Elijah.Var,
    [SlotVariant.SHOP_RESTOCK_MACHINE]        = mod.Entities.BEGGAR_Restock_Elijah.Var,
    [mod.Entities.BEGGAR_JYS.Var]             = mod.Entities.BEGGAR_JYS_Elijah.Var,
    [mod.Entities.BEGGAR_Goldsmith.Var]       = mod.Entities.BEGGAR_Goldsmith_Elijah.Var,
    [mod.Entities.BEGGAR_Familiars.Var]       = mod.Entities.BEGGAR_Familiars_Elijah.Var,
    [mod.Entities.BEGGAR_ShopElijah.Var]      = mod.Entities.BEGGAR_ShopElijah.Var,
    [mod.Entities.BEGGAR_Lost_Adventurer.Var] = mod.Entities.BEGGAR_Lost_Adventurer_E.Var,
}

local spawnElijahWill = {
    [PickupVariant.PICKUP_KEY] = elijahWill,
    [PickupVariant.PICKUP_BOMB] = elijahWill,
    [PickupVariant.PICKUP_COIN] = elijahWill,
}

local ItemRoomBeggar = {
    [RoomType.ROOM_TREASURE]     = mod.Entities.BEGGAR_TreasureElijah.Var,
    [RoomType.ROOM_SHOP]         = mod.Entities.BEGGAR_ShopElijah.Var,
    [RoomType.ROOM_DEVIL]        = mod.Entities.BEGGAR_DemonElijah.Var,
    [RoomType.ROOM_ANGEL]        = mod.Entities.BEGGAR_AngelElijah.Var,
    [RoomType.ROOM_SECRET]       = mod.Entities.BEGGAR_SecretElijah.Var,
    [RoomType.ROOM_SUPERSECRET]  = mod.Entities.BEGGAR_SecretElijah.Var,
    [RoomType.ROOM_ULTRASECRET]  = mod.Entities.BEGGAR_UltraSecretElijah.Var,
    [RoomType.ROOM_PLANETARIUM]  = mod.Entities.BEGGAR_PlanetariumElijah.Var,
    [RoomType.ROOM_LIBRARY]      = mod.Entities.BEGGAR_LibraryElijah.Var,
    [RoomType.ROOM_ERROR]        = mod.Entities.BEGGAR_ERROR_Elijah.Var,
    [RoomType.ROOM_BLACK_MARKET] = mod.Entities.BEGGAR_ShopElijah.Var,
    [RoomType.ROOM_DUNGEON]      = mod.Entities.BEGGAR_SecretElijah.Var,
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

---@return integer|nil
function GetChaosBeggarVariant(room, rng)
    if not mod.Pools.CHAOS_ELIJAH_BEGGARS then 
        return nil 
    end
    
    local pool = mod.Pools.CHAOS_ELIJAH_BEGGARS
    if #pool == 0 then 
        return nil 
    end

    local randomIndex = rng:RandomInt(#pool) + 1
    return pool[randomIndex]
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
    return runSave.WillCount or 0
end

--- Callbacks
---
----------------------------------------------
---Add starting items to Elijah.
----------------------------------------------
---@param player EntityPlayer
function elijahFuncs:PlayerInit(player)
    if player:GetPlayerType() ~= elijah then return end

    player:AddCollectible(elijahStartingItem, STARTING_ITEM_CHARGES)
    player:AddCollectible(CollectibleType.COLLECTIBLE_DEEP_POCKETS)
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

----------------------------------------------
---Render HUD wills.
----------------------------------------------
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
    data.WillCount = (data.WillCount or 0) + 1
    
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
    
    sfx:Play(SoundEffect.SOUND_PENNYPICKUP)
    
    -- Force HUD update
    player:AddCoins((data.WillCount or 0) - player:GetNumCoins())
    pickup:Remove()
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, elijahFuncs.OnPickupCollision, elijahWill)

function elijahFuncs:OnPickupCollisionWillB(pickup, collider)
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= elijah then return false end

    local data = save.GetRunSave(player)

    local stat = math.random(#statsUpFuncs)
    local StatUp = statsUpFuncs[stat]

    StatUp(data)
    StatUp(data)
    data.WillCount = (data.WillCount or 0) + 1

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
    
    sfx:Play(SoundEffect.SOUND_PENNYPICKUP)
    player:AddCoins((data.WillCount or 0) - player:GetNumCoins())
    pickup:Remove()
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, elijahFuncs.OnPickupCollisionWillB, elijahWillB)

------------------------------------------------
---Stats up
-------------------------------------------------
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function elijahFuncs:EvaluateCache(player, cacheFlag)
    if player:GetPlayerType() ~= elijah then return end

    local runSave = save.GetRunSave(player)
    local CacheFunc = cacheFuncs[cacheFlag]
    if (not CacheFunc) then return end
    CacheFunc(player)
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
    local roomData = save.GetRoomSave(nil)
    
    -- Prevent running multiple times
    if roomData.beggarSwap then return end
    roomData.beggarSwap = true

    local player = PlayerManager.FirstPlayerByType(elijah)
    if not player then return end

    -- Handle shop items separately
    if room:GetType() == RoomType.ROOM_SHOP then
        -- Replace ALL purchasable items with shop beggars
        for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
            local pickup = entity:ToPickup()
            if pickup and pickup.Price > 0 then
                local pos = pickup.Position
                local vel = pickup.Velocity
                pickup:Remove()
                
                Isaac.Spawn(
                    EntityType.ENTITY_SLOT,
                    mod.Entities.BEGGAR_ShopElijah.Var,
                    0,
                    pos,
                    vel,
                    nil
                )
            end
        end
        return
    end
    --Chaos synergy
    local hasChaos = player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS)
    
    for _, entity in ipairs(
        Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    ) do
        local ped = entity:ToPickup()
        if ped then
            local rng = ped:GetDropRNG()
            local beggarVariant

            if hasChaos then
                beggarVariant = GetChaosBeggarVariant(room, rng)
            else
                beggarVariant = ItemRoomBeggar[room:GetType()]
            end

            if beggarVariant then
                local pos = ped.Position
                local vel = ped.Velocity
                ped:Remove()

                Isaac.Spawn(
                    EntityType.ENTITY_SLOT,
                    beggarVariant,
                    0,
                    pos,
                    vel,
                    nil
                )
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
    
    local targetAmount = math.floor(GetTotalWillStats(player))
    local currentCoins = player:GetNumCoins()
    
    if targetAmount ~= currentCoins then
        player:AddCoins(targetAmount - currentCoins)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, elijahFuncs.PostPlayerUpdate)

----------------------------------------------
---Blacklists
----------------------------------------------
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
    EID:addBirthright(mod.Players.Elijah, "Wills can become stronger and give permanent stat boosts.", "Elijah")
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
                "#{{Player" .. mod.Players.Elijah .. "}}{{ColorRainbow}} Shuffle all beggars as well{{CR}}"
            return descObj
        end
    )
end

--Restock
if EID then
    EID:addDescriptionModifier(
        "Restock_Elijah",

        function(descObj)
            if descObj.ObjType ~= EntityType.ENTITY_PICKUP then return false end
            if descObj.ObjVariant ~= PickupVariant.PICKUP_COLLECTIBLE then return false end
            if descObj.ObjSubType ~= CollectibleType.COLLECTIBLE_RESTOCK then return false end

            local player = EID:ClosestPlayerTo(descObj.Entity)
            return player and player:GetPlayerType() == mod.Players.Elijah
        end,

        function(descObj)
            descObj.Description =
                descObj.Description ..
                "#{{Player" .. mod.Players.Elijah .. "}}{{ColorRainbow}} Shops beggars won't teleport.{{CR}}"
            return descObj
        end
    )
end

--BFFs and Lucky Foot
if EID then
    EID:addDescriptionModifier(
        "BoostItems_Elijah",

        function(descObj)
            if descObj.ObjType ~= EntityType.ENTITY_PICKUP then return false end
            if descObj.ObjVariant ~= PickupVariant.PICKUP_COLLECTIBLE then return false end
            if descObj.ObjSubType ~= CollectibleType.COLLECTIBLE_BFFS then return false end
            if descObj.ObjSubType ~= CollectibleType.COLLECTIBLE_LUCKY_FOOT then return false end

            local player = EID:ClosestPlayerTo(descObj.Entity)
            return player and player:GetPlayerType() == mod.Players.Elijah
        end,

        function(descObj)
            descObj.Description =
                descObj.Description ..
                "#{{Player" .. mod.Players.Elijah .. "}}{{ColorRainbow}} Beggars have a higher chnce to give rewards{{CR}}"
            return descObj
        end
    )
end