---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local CHAOTIC_BEGGAR = mod.Entities.BEGGAR_Chaos.Var

local BASE_FINAL_CHANCE = 0.02 
local BASE_SECONDARY_CHANCE = 0.10
local FINAL_INCREMENT = 0.05 
local SECONDARY_INCREMENT = 0.15 

function mod:ChaoticBeggarInit(beggar)
    local data = beggar:GetData()
    data.Payments = 0
    data.CanPay = true
    data.FinalChance = BASE_FINAL_CHANCE
    data.SecondaryChance = BASE_SECONDARY_CHANCE
    data.StatChanges = data.StatChanges or {}
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, mod.ChaoticBeggarInit, CHAOTIC_BEGGAR)

mod.ChaosBeggarStats = mod.ChaosBeggarStats or {}

local function GetRandomStat()
    local stats = {"Damage", "Speed", "Range", "ShotSpeed", "TearHeight", "Luck", "Tears"}
    return stats[math.random(#stats)]
end

local function ApplyStatBoost(player, stat)
    mod.ChaosBeggarStats[stat] = (mod.ChaosBeggarStats[stat] or 0) + (0.5 + math.random() * 0.5)
    
    -- Trigger cache update
    if stat == "Damage" then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    elseif stat == "Speed" then
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    elseif stat == "Range" then
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
    elseif stat == "ShotSpeed" then
        player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
    elseif stat == "TearHeight" then
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
    elseif stat == "Luck" then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    elseif stat == "Tears" then
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    end
    player:EvaluateItems()
end

local function ApplyStatNerf(player, stat)
    mod.ChaosBeggarStats[stat] = (mod.ChaosBeggarStats[stat] or 0) - (0.3 + math.random() * 0.4)
    
    -- Trigger cache update
    if stat == "Damage" then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    elseif stat == "Speed" then
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    elseif stat == "Range" then
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
    elseif stat == "ShotSpeed" then
        player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
    elseif stat == "TearHeight" then
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
    elseif stat == "Luck" then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    elseif stat == "Tears" then
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    end
    player:EvaluateItems()
end

-- Apply stats in cache callback
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE and mod.ChaosBeggarStats.Damage then
        player.Damage = player.Damage + mod.ChaosBeggarStats.Damage
    elseif cacheFlag == CacheFlag.CACHE_SPEED and mod.ChaosBeggarStats.Speed then
        player.MoveSpeed = player.MoveSpeed + mod.ChaosBeggarStats.Speed
    elseif cacheFlag == CacheFlag.CACHE_RANGE and mod.ChaosBeggarStats.Range then
        player.TearRange = player.TearRange + mod.ChaosBeggarStats.Range
    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED and mod.ChaosBeggarStats.ShotSpeed then
        player.ShotSpeed = player.ShotSpeed + mod.ChaosBeggarStats.ShotSpeed
    elseif cacheFlag == CacheFlag.CACHE_TEARFLAG and mod.ChaosBeggarStats.TearHeight then
        player.TearHeight = player.TearHeight - mod.ChaosBeggarStats.TearHeight
    elseif cacheFlag == CacheFlag.CACHE_LUCK and mod.ChaosBeggarStats.Luck then
        player.Luck = player.Luck + mod.ChaosBeggarStats.Luck
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY and mod.ChaosBeggarStats.Tears then
        player.MaxFireDelay = player.MaxFireDelay - mod.ChaosBeggarStats.Tears
    end
end)

local function RevealSecretRooms()
    local level = game:GetLevel()
    local rooms = level:GetRooms()
    for i = 0, rooms.Size - 1 do
        local desc = rooms:Get(i)
        if desc.Data and (desc.Data.Type == RoomType.ROOM_SECRET or desc.Data.Type == RoomType.ROOM_SUPERSECRET) then
            desc.DisplayFlags = RoomDescriptor.DISPLAY_BOX
        end
    end
    level:UpdateVisibility()
    sfx:Play(SoundEffect.SOUND_SHELLGAME)
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
        {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0}
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
    local enemies = {{EntityType.ENTITY_ATTACKFLY, 0}, {EntityType.ENTITY_POOTER, 0}, {EntityType.ENTITY_FLY, 0}, {EntityType.ENTITY_SPIDER, 0}, {EntityType.ENTITY_SPIDER_L2, 0}}
    
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
        -- Spawn a trinket
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(pos, 40), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_THUMBSUP)
    elseif roll <= 18 then
        -- Spawn random pickup
        local variants = {PickupVariant.PICKUP_COIN, PickupVariant.PICKUP_HEART, PickupVariant.PICKUP_KEY, PickupVariant.PICKUP_BOMB, PickupVariant.PICKUP_BATTERY, PickupVariant.PICKUP_PILL, PickupVariant.PICKUP_TAROTCARD}
        Isaac.Spawn(EntityType.ENTITY_PICKUP, variants[math.random(#variants)], 0, Isaac.GetFreeNearPosition(pos, 40), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
    elseif roll <= 32 then
        -- Spawn pickup burst
        SpawnPickupBurst(pos, 8 + math.random(5))
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
    elseif roll <= 48 then
        -- Boost random stat
        local stat = GetRandomStat()
        ApplyStatBoost(player, stat)
        game:GetHUD():ShowItemText(stat .. " Up!", "", false)
        sfx:Play(SoundEffect.SOUND_THUMBSUP)
        
        
        if stat == "Damage" then
            -- Needs damage up voiceline 
        elseif stat == "Luck"  then
            sfx:Play(SoundEffect.SOUND_LUCK_UP)
        elseif stat == "Range" then
            sfx:Play(SoundEffect.SOUND_RANGE_UP)
        elseif stat == "ShotSpeed" then
            sfx:Play(SoundEffect.SOUND_SHOT_SPEED_UP)
        elseif stat == "Speed" then
            sfx:Play(SoundEffect.SOUND_SPEED_UP)
        elseif stat == "Tears" then
            sfx:Play(SoundEffect.SOUND_TEARS_UP)
            -- Possible TODO: make a tear height up voiceline???
        end
    elseif roll <= 64 then
        -- Spawn blue spider or fly
        if math.random() < 0.5 then player:AddBlueSpider(pos) else player:AddBlueFlies(1, pos, nil) end
        sfx:Play(SoundEffect.SOUND_CUTE_GRUNT)
    elseif roll <= 75 then
        -- Reveal secret rooms
        RevealSecretRooms()
    elseif roll <= 85 then
        -- Spawn random chest
        local chestVariants = {PickupVariant.PICKUP_CHEST, PickupVariant.PICKUP_BOMBCHEST, PickupVariant.PICKUP_SPIKEDCHEST, PickupVariant.PICKUP_ETERNALCHEST, PickupVariant.PICKUP_LOCKEDCHEST, PickupVariant.PICKUP_MIMICCHEST}
        Isaac.Spawn(EntityType.ENTITY_PICKUP, chestVariants[math.random(#chestVariants)], 0, Isaac.GetFreeNearPosition(pos, 60), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_CHEST_DROP)
    elseif roll <= 95 then
        -- Spawn random passive item
        local itemPool = game:GetItemPool()
        local itemID = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, game:GetSeeds():GetStartSeed())
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, Isaac.GetFreeNearPosition(pos, 60), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK)
    else
        -- Jackpot!
        SpawnPickupBurst(pos, 3 + math.random(10))
        sfx:Play(SoundEffect.SOUND_HOLY)
    end
end

local function DoBadOutcome(beggar, player)
    local roll = math.random(100)
    local pos = beggar.Position
    
    if roll <= 20 then
        -- Lose random stat
        local stat = GetRandomStat()
        ApplyStatNerf(player, stat)
        game:GetHUD():ShowItemText(stat .. " Down!", "", false)
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)

        if stat == "Damage" then
            -- Needs damage down voiceline 
        elseif stat == "Luck"  then
            sfx:Play(SoundEffect.SOUND_LUCK_DOWN)
        elseif stat == "Range" then
            sfx:Play(SoundEffect.SOUND_RANGE_DOWN)
        elseif stat == "ShotSpeed" then
            sfx:Play(SoundEffect.SOUND_SHOT_SPEED_DOWN)
        elseif stat == "Speed" then
            sfx:Play(SoundEffect.SOUND_SPEED_DOWN)
        elseif stat == "Tears" then
            sfx:Play(SoundEffect.SOUND_TEARS_DOWN)
            -- Possible TODO: make a tear height down voiceline???
        end

    elseif roll <= 40 then
        -- Take 1 heart of damage
        player:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(nil), 0)
        sfx:Play(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
    elseif roll <= 60 then
        -- Spawn enemies
        SpawnEnemies(pos, 3 + math.random(2))
        sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
    elseif roll <= 75 then
        -- Curse for this floor (random)
        local curses = {LevelCurse.CURSE_OF_DARKNESS, LevelCurse.CURSE_OF_THE_LOST, LevelCurse.CURSE_OF_THE_UNKNOWN, LevelCurse.CURSE_OF_MAZE, LevelCurse.CURSE_OF_BLIND}
        local curse = curses[math.random(#curses)]
        game:GetLevel():AddCurse(curse, false)
        sfx:Play(SoundEffect.SOUND_CASTLEPORTCULLIS)
    elseif roll <= 90 then
        local lostSomething = false
        if player:GetNumCoins() > 0 then
            player:AddCoins(-5)
            lostSomething = true
        elseif player:GetNumKeys() > 0 then
            player:AddKeys(-1)
            lostSomething = true
        elseif player:GetNumBombs() > 0 then
            player:AddBombs(-1)
            lostSomething = true
        end
        
        if lostSomething then
            sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        else
            player:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(nil), 0)
        end
    else
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
        -- Spawn small pickup burst
        SpawnPickupBurst(pos, 3 + math.random(3))
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
    else
        -- Spawn troll bomb
        Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, Isaac.GetFreeNearPosition(pos, 50), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_BEEP)
    end
end

local function DoFinalReward(beggar, player)
    local pos = beggar.Position
    local roll = math.random(6)
    
    if roll == 1 then
        -- Spawn a bunch of items (3-5 random items)
        local itemPool = game:GetItemPool()
        for i = 1, 3 + math.random(2) do
            local itemID = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, game:GetSeeds():GetStartSeed() + i)
            local offset = RandomVector() * (60 + math.random() * 40)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, pos + offset, Vector.Zero, nil)
        end
        sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK)
    elseif roll == 2 then
        -- Spawn  pickup burst
        SpawnPickupBurst(pos, 2 + math.random(7))
        sfx:Play(SoundEffect.SOUND_HOLY)
    elseif roll == 3 then
        -- Spawn mini boss
        local minibosses = {{EntityType.ENTITY_SLOTH, 0}, {EntityType.ENTITY_LUST, 0}, {EntityType.ENTITY_WRATH, 0}, {EntityType.ENTITY_GLUTTONY, 0}, {EntityType.ENTITY_GREED, 0}, {EntityType.ENTITY_ENVY, 0}, {EntityType.ENTITY_PRIDE, 0}}
        local boss = minibosses[math.random(#minibosses)]
        Isaac.Spawn(boss[1], boss[2], 0, Isaac.GetFreeNearPosition(pos, 80), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
    elseif roll == 4 then
        -- Spawn trap item (teleports to I AM ERROR room)
        local trapItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BRIMSTONE, Isaac.GetFreeNearPosition(pos, 60), Vector.Zero, nil)
        trapItem:GetData().IsTrapItem = true
    elseif roll == 5 then
        -- Spawn burst of troll bombs
        for i = 1, 5 + math.random(5) do
            local offset = RandomVector() * (40 + math.random() * 80)
            Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_TROLL, 0, pos + offset, Vector.Zero, nil)
        end
        sfx:Play(SoundEffect.SOUND_BEEP)
    elseif roll == 6 then
        -- Spawn another chaotic beggar
        Isaac.Spawn(EntityType.ENTITY_SLOT, CHAOTIC_BEGGAR, 0, Isaac.GetFreeNearPosition(pos, 80), Vector.Zero, nil)
        sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
    end
    sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
end

function mod:ChaoticBeggarCollision(beggar, collider)
    local player = collider:ToPlayer()
    if not player then return end
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()
    local rng = beggar:GetDropRNG()
    if not data.CanPay then return end
    if not sprite:IsPlaying("Idle") then return end
    
    -- Build list of available pickups
    local availablePickups = {}
    if player:GetNumCoins() > 0 then table.insert(availablePickups, {type = "coin", suffix = ""}) end
    if player:GetNumKeys() > 0 then table.insert(availablePickups, {type = "key", suffix = "2"}) end
    if player:GetNumBombs() > 0 then table.insert(availablePickups, {type = "bomb", suffix = "3"}) end
    if player:GetHearts() > 2 then table.insert(availablePickups, {type = "heart", suffix = "4"}) end
    if player:GetSoulHearts() > 0 then table.insert(availablePickups, {type = "soulheart", suffix = "5"}) end
    if player:GetBlackHearts() > 0 then table.insert(availablePickups, {type = "blackheart", suffix = "6"}) end
    if #availablePickups == 0 then return end
    
    -- Randomly pick what to take
    local chosen = availablePickups[math.random(#availablePickups)]
    
    -- Take the pickup
    if chosen.type == "coin" then player:AddCoins(-1)
    elseif chosen.type == "key" then player:AddKeys(-1)
    elseif chosen.type == "bomb" then player:AddBombs(-1)
    elseif chosen.type == "heart" then player:AddHearts(-1)
    elseif chosen.type == "soulheart" then player:AddSoulHearts(-1)
    elseif chosen.type == "blackheart" then player:AddBlackHearts(-1) end
    
    data.CanPay = false
    data.Payments = data.Payments + 1
    data.FinalChance = BASE_FINAL_CHANCE + (FINAL_INCREMENT * data.Payments)
    data.SecondaryChance = BASE_SECONDARY_CHANCE + (SECONDARY_INCREMENT * data.Payments)
    
    -- Decide outcome
    local roll = rng:RandomFloat()
    if roll < data.FinalChance then
        sprite:Play("PayPrize" .. chosen.suffix, true)
        data.IsFinalReward = true
        sfx:Play(SoundEffect.SOUND_SCAMPER)
        data.LastPlayer = player
        return
    end
    if roll < data.FinalChance + data.SecondaryChance then
        sprite:Play("PayPrize" .. chosen.suffix, true)
        data.IsSecondaryReward = true
        data.Payments = 0
        data.FinalChance = BASE_FINAL_CHANCE
        data.SecondaryChance = BASE_SECONDARY_CHANCE
        sfx:Play(SoundEffect.SOUND_SCAMPER)
        data.LastPlayer = player
        return
    end
    
    -- Nothing
    sprite:Play("PayNothing" .. chosen.suffix, true)
    data.IsPayNothing = true
    sfx:Play(SoundEffect.SOUND_SCAMPER)
    data.LastPlayer = player
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.ChaoticBeggarCollision, CHAOTIC_BEGGAR)

function mod:ChaoticBeggarUpdate(beggar)
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()
    local rng = beggar:GetDropRNG()
    
    if data.IsPayNothing then
        local payNothingAnims = {"PayNothing", "PayNothing2", "PayNothing3", "PayNothing4", "PayNothing5", "PayNothing6"}
        for _, anim in ipairs(payNothingAnims) do
            if sprite:IsFinished(anim) then
                data.CanPay = true
                data.IsPayNothing = false
                sprite:Play("Idle", true)
                break
            end
        end
    end
    
    if data.IsSecondaryReward or data.IsFinalReward then
        local payPrizeAnims = {"PayPrize", "PayPrize2", "PayPrize3", "PayPrize4", "PayPrize5", "PayPrize6"}
        for _, anim in ipairs(payPrizeAnims) do
            if sprite:IsFinished(anim) then
                if data.IsSecondaryReward then sprite:Play("Prize", true)
                elseif data.IsFinalReward then sprite:Play("Teleport", true) end
                break
            end
        end
    end

    if sprite:IsFinished("Prize") and data.IsSecondaryReward then
        local player = data.LastPlayer or Isaac.GetPlayer(0)
        local outcomeRoll = rng:RandomFloat()
        if outcomeRoll < 0.4 then DoGoodOutcome(beggar, player)
        elseif outcomeRoll < 0.8 then DoBadOutcome(beggar, player)
        else DoNeutralOutcome(beggar, player) end
        data.IsSecondaryReward = false
        data.CanPay = true
        sprite:Play("Idle", true)
    end
    
    if sprite:IsFinished("Teleport") and data.IsFinalReward then
        local player = data.LastPlayer or Isaac.GetPlayer(0)
        DoFinalReward(beggar, player)
        beggar:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.ChaoticBeggarUpdate, CHAOTIC_BEGGAR)

-- Trap item handler (teleports to I AM ERROR room)
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

function mod:ChaoticBeggarExploded(beggar)
    for i = 1, 2 + math.random(3) do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, beggar.Position + RandomVector() * 20, RandomVector() * 3, beggar)
    end
    if math.random() < 0.3 then SpawnEnemies(beggar.Position, 2 + math.random(2)) end
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 1, 3, Color.Default)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, beggar.Position, Vector.Zero, beggar)
    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.ChaoticBeggarExploded, CHAOTIC_BEGGAR)

-- 5% chance to replace other beggars
mod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, function(_, slot)
    if slot.Variant == CHAOTIC_BEGGAR then return end
    if math.random(100) <= 5 then
        local pos = slot.Position
        slot:Remove()
        Isaac.Spawn(EntityType.ENTITY_SLOT, CHAOTIC_BEGGAR, 0, pos, Vector.Zero, nil)
    end
end)