local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

---@class BeggarUtils
local beggarUtils = include("scripts.npcs.elijah.elijah_utils_beggar")

local CHAOS_ELIJAH = mod.Entities.BEGGAR_Chaos_Elijah.Var
local elijah = mod.Players.Elijah

local BASE_FINAL_CHANCE = 0.02
local BASE_SECONDARY_CHANCE = 0.10
local FINAL_MULT = 0.05
local SECONDARY_MULT = 0.15

------------------------------------------------------------
-- INIT
------------------------------------------------------------
function mod:ChaosElijahInit(beggar)
    local data = beggar:GetData()
    data.Payments = 0
    data.CanPay = true
    data.FinalChance = BASE_FINAL_CHANCE
    data.SecondaryChance = BASE_SECONDARY_CHANCE
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, mod.ChaosElijahInit, CHAOS_ELIJAH)

------------------------------------------------------------
-- HELPER FUNCTIONS
------------------------------------------------------------
local function GetRandomStat()
    local stats = {"Damage", "Speed", "Range", "ShotSpeed", "TearHeight", "Luck"}
    return stats[math.random(#stats)]
end

local function ApplyStatBoost(player)
    local stat = GetRandomStat()
    local data = mod.SaveManager.GetRunSave(player)
    
    local statKey = "Will" .. stat
    data[statKey] = (data[statKey] or 0) + (0.5 + math.random() * 0.5)
    
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
    
    game:GetHUD():ShowItemText("+" .. stat .. "!", "", false)
    sfx:Play(SoundEffect.SOUND_THUMBSUP)
end

local function ApplyStatNerf(player)
    local stat = GetRandomStat()
    local data = mod.SaveManager.GetRunSave(player)
    
    local statKey = "Will" .. stat
    data[statKey] = (data[statKey] or 0) - (0.3 + math.random() * 0.4)
    
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
    
    game:GetHUD():ShowItemText("-" .. stat .. "!", "", false)
    sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
end

local function SpawnPickupBurst(position, count)
    count = count or 5
    local pickupTypes = {
        {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY},
        {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL},
        {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL},
        {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF},
        {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL},
        {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL},
        {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BATTERY, 0},
    }
    for i = 1, count do
        local pickup = pickupTypes[math.random(#pickupTypes)]
        local offset = RandomVector() * (20 + math.random() * 40)
        local subtype = pickup[3] or 0
        Isaac.Spawn(pickup[1], pickup[2], subtype, position + offset, RandomVector() * (2 + math.random() * 3), nil)
    end
end

local function SpawnEnemies(position, count)
    count = count or (2 + math.random(2))
    local enemies = {
        {EntityType.ENTITY_ATTACKFLY, 0}, 
        {EntityType.ENTITY_POOTER, 0}, 
        {EntityType.ENTITY_FLY, 0}, 
        {EntityType.ENTITY_SPIDER, 0}, 
        {EntityType.ENTITY_SPIDER_L2, 0}
    }
    
    local room = game:GetRoom()
    local player = Isaac.GetPlayer(0)
    
    for i = 1, count do
        local enemy = enemies[math.random(#enemies)]
        local offset = RandomVector() * (100 + math.random() * 50)
        local spawnPos = position + offset
        if spawnPos:Distance(player.Position) < 80 then
            spawnPos = position + (offset * 1.5)
        end
        Isaac.Spawn(enemy[1], enemy[2], 0, spawnPos, Vector.Zero, nil)
    end
    
    -- Close all doors
    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = room:GetDoor(i)
        if door then
            door:Close(true)
        end
    end
end

local function DoGoodOutcome(beggar, player)
    local roll = math.random(100)
    local pos = beggar.Position
    
    if roll <= 5 then
        -- Trinket
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, 
            Isaac.GetFreeNearPosition(pos, 40), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_THUMBSUP)
    elseif roll <= 18 then
        -- Random pickup
        local variants = {
            PickupVariant.PICKUP_COIN, PickupVariant.PICKUP_HEART, 
            PickupVariant.PICKUP_KEY, PickupVariant.PICKUP_BOMB, 
            PickupVariant.PICKUP_BATTERY, PickupVariant.PICKUP_PILL, 
            PickupVariant.PICKUP_TAROTCARD
        }
        Isaac.Spawn(EntityType.ENTITY_PICKUP, variants[math.random(#variants)], 0, 
            Isaac.GetFreeNearPosition(pos, 40), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
    elseif roll <= 32 then
        -- Pickup burst
        SpawnPickupBurst(pos, 8 + math.random(5))
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
    elseif roll <= 48 then
        -- Boost stat
        ApplyStatBoost(player)
    elseif roll <= 64 then
        -- Blue spider/fly
        if math.random() < 0.5 then 
            player:AddBlueSpider(pos) 
        else 
            player:AddBlueFlies(1, pos, nil) 
        end
        sfx:Play(SoundEffect.SOUND_CUTE_GRUNT)
    elseif roll <= 85 then
        -- Chest
        local chestVariants = {
            PickupVariant.PICKUP_CHEST, PickupVariant.PICKUP_BOMBCHEST, 
            PickupVariant.PICKUP_SPIKEDCHEST, PickupVariant.PICKUP_ETERNALCHEST, 
            PickupVariant.PICKUP_LOCKEDCHEST, PickupVariant.PICKUP_MIMICCHEST
        }
        Isaac.Spawn(EntityType.ENTITY_PICKUP, chestVariants[math.random(#chestVariants)], 0, 
            Isaac.GetFreeNearPosition(pos, 60), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_CHEST_DROP)
    elseif roll <= 95 then
        -- Item
        local itemPool = game:GetItemPool()
        local itemID = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, game:GetSeeds():GetStartSeed())
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, 
            Isaac.GetFreeNearPosition(pos, 60), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK)
    else
        -- Jackpot
        SpawnPickupBurst(pos, 15 + math.random(10))
        sfx:Play(SoundEffect.SOUND_HOLY)
    end
end

local function DoBadOutcome(beggar, player)
    local roll = math.random(100)
    local pos = beggar.Position
    
    if roll <= 20 then
        -- Lose stat
        ApplyStatNerf(player)
    elseif roll <= 40 then
        -- Take damage
        player:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(nil), 0)
        sfx:Play(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
    elseif roll <= 60 then
        -- Spawn enemies
        SpawnEnemies(pos, 3 + math.random(2))
        sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
    elseif roll <= 75 then
        -- Curse
        local curses = {
            LevelCurse.CURSE_OF_THE_LOST, LevelCurse.CURSE_OF_THE_UNKNOWN, 
            LevelCurse.CURSE_OF_MAZE, LevelCurse.CURSE_OF_BLIND
        }
        game:GetLevel():AddCurse(curses[math.random(#curses)], false)
        sfx:Play(SoundEffect.SOUND_CASTLEPORTCULLIS)

    else
        -- Teleport
        local level = game:GetLevel()
        local rooms = level:GetRooms()
        local validRooms = {}
        
        for i = 0, rooms.Size - 1 do
            local desc = rooms:Get(i)
            if desc and desc.Data and desc.Data.Type ~= RoomType.ROOM_BOSS and desc.SafeGridIndex >= 0 then
                table.insert(validRooms, desc.SafeGridIndex)
            end
        end
        
        if #validRooms > 0 then
            local targetRoom = validRooms[math.random(#validRooms)]
            game:StartRoomTransition(targetRoom, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)
        end
        sfx:Play(SoundEffect.SOUND_HELL_PORTAL1)
    end
end

local function DoNeutralOutcome(beggar, player)
    local roll = math.random(100)
    local pos = beggar.Position
    
    if roll <= 50 then
        -- Small pickup burst
        SpawnPickupBurst(pos, 3 + math.random(3))
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
    else
        -- Troll bomb
        Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_TROLL, 0, 
            Isaac.GetFreeNearPosition(pos, 50), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_BEEP)
    end
end

local function DoFinalReward(beggar, player)
    local pos = beggar.Position
    local roll = math.random(6)
    
    if roll == 1 then
        -- Multiple items
        local itemPool = game:GetItemPool()
        for i = 1, 3 + math.random(2) do
            local itemID = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, game:GetSeeds():GetStartSeed() + i)
            local offset = RandomVector() * (60 + math.random() * 40)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, 
                pos + offset, Vector.Zero, nil)
        end
        sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK)
    elseif roll == 2 then
        -- Massive pickup burst
        SpawnPickupBurst(pos, 30 + math.random(20))
        sfx:Play(SoundEffect.SOUND_HOLY)
    elseif roll == 3 then
        -- Mini boss
        local minibosses = {
            {EntityType.ENTITY_LUST, 0}, 
            {EntityType.ENTITY_WRATH, 0}, 
            {EntityType.ENTITY_GLUTTONY, 0},
            {EntityType.ENTITY_GREED, 0}, 
            {EntityType.ENTITY_ENVY, 0}, 
            {EntityType.ENTITY_PRIDE, 0},
            {EntityType.ENTITY_SLOTH, 0},
        }
        local boss = minibosses[math.random(#minibosses)]
        Isaac.Spawn(boss[1], boss[2], 0, 
            Isaac.GetFreeNearPosition(pos, 80), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
    elseif roll == 4 then
        -- Trap item (teleports to ERROR)
        local trapItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 
            CollectibleType.COLLECTIBLE_BRIMSTONE, 
            Isaac.GetFreeNearPosition(pos, 60), Vector.Zero, nil)
        trapItem:GetData().IsTrapItem = true
    elseif roll == 5 then
        -- Troll bomb burst
        for i = 1, 5 + math.random(5) do
            local offset = RandomVector() * (40 + math.random() * 80)
            Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_TROLL, 0, 
                pos + offset, Vector.Zero, nil)
        end
        sfx:Play(SoundEffect.SOUND_BEEP)
    elseif roll == 6 then
        -- Spawn another chaos beggar
        Isaac.Spawn(EntityType.ENTITY_SLOT, CHAOS_ELIJAH, 0, 
            Isaac.GetFreeNearPosition(pos, 80), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
    end
    sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
end

------------------------------------------------------------
-- COLLISION
------------------------------------------------------------
function mod:ChaosElijahCollision(beggar, collider)
    if beggar.Variant ~= CHAOS_ELIJAH then return end
    
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= elijah then return end

    local sprite = beggar:GetSprite()
    local data = beggar:GetData()
    local rng = beggar:GetDropRNG()

    if not data.CanPay then return end
    if not sprite:IsPlaying("Idle") then return end

    if not beggarUtils.DrainElijahsWill(player, rng) then
        return
    end

    data.CanPay = false
    data.Payments = (data.Payments or 0) + 1
    data.FinalChance = BASE_FINAL_CHANCE + (FINAL_MULT * (data.Payments - 1))
    data.SecondaryChance = BASE_SECONDARY_CHANCE + (SECONDARY_MULT * (data.Payments - 1))

    sfx:Play(SoundEffect.SOUND_SCAMPER)
    sprite:Play("PayNothing", true)
    data.LastPayer = player
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.ChaosElijahCollision, CHAOS_ELIJAH)

------------------------------------------------------------
-- UPDATE
------------------------------------------------------------
function mod:ChaosElijahUpdate(beggar)
    if beggar.Variant ~= CHAOS_ELIJAH then return end
    
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()
    local rng = beggar:GetDropRNG()

    if sprite:IsFinished("PayNothing") then
        local roll = rng:RandomFloat()
        
        if roll < data.FinalChance then
            sprite:Play("PayPrize", true)
            data.Payments = 0
            return
        end
        
        if roll < data.FinalChance + data.SecondaryChance then
            sprite:Play("Prize", true)
            data.Payments = 0
            return
        end
        data.CanPay = true
        sprite:Play("Idle", true)
    end
    if sprite:IsFinished("Prize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
        local player = data.LastPayer or Isaac.GetPlayer(0)
        local outcomeRoll = rng:RandomFloat()
        
        if outcomeRoll < 0.4 then 
            DoGoodOutcome(beggar, player)
        elseif outcomeRoll < 0.8 then 
            DoBadOutcome(beggar, player)
        else 
            DoNeutralOutcome(beggar, player) 
        end
        
        data.CanPay = true
        sprite:Play("Idle", true)
    end

    if sprite:IsFinished("PayPrize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
        local player = data.LastPayer or Isaac.GetPlayer(0)
        DoFinalReward(beggar, player)
        sprite:Play("Teleport", true)
    end

    if sprite:IsFinished("Teleport") then
        beggar:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.ChaosElijahUpdate, CHAOS_ELIJAH)

------------------------------------------------------------
-- EXPLOSION
------------------------------------------------------------
function mod:ChaosElijahExploded(beggar)
    if beggar.Variant ~= CHAOS_ELIJAH then return end
    
    for i = 1, 2 + math.random(3) do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, 
            beggar.Position + RandomVector() * 20, RandomVector() * 3, beggar)
    end
    if math.random() < 0.3 then 
        SpawnEnemies(beggar.Position, 2 + math.random(2)) 
    end
    beggarUtils.DoBeggarExplosion(beggar)
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.ChaosElijahExploded, CHAOS_ELIJAH)

------------------------------------------------------------
-- TRAP ITEM HANDLER
------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local player = Isaac.GetPlayer(0)
    for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local pickup = entity:ToPickup()
        if pickup and pickup:GetData().IsTrapItem then
            local distance = pickup.Position:Distance(player.Position)
            if distance < 40 then
                game:StartRoomTransition(GridRooms.ROOM_ERROR_IDX, Direction.NO_DIRECTION)
                pickup:GetData().IsTrapItem = false
            end
        end
    end
end)