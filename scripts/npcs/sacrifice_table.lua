---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local SacrificeTable = mod.Entities.BEGGAR_SacrificeTable.Var

-----------------------------------------------------
--                       API
-----------------------------------------------------
mod.RegisteredModdedFamiliars = mod.RegisteredModdedFamiliars or {}
--Register a modded familiar by name

---@param familiarName string            - Name of the familiar entity (from entities2.xml)
---@param collectibleName string         - Name of the collectible (from items.xml)
---@param spritePath string              - Path to the familiar's sprite (optional, will auto-detect if nil)
function mod:RegisterModdedFamiliar(familiarName, collectibleName, spritePath)
    if not familiarName or not collectibleName then
        print("ERROR: RegisterModdedFamiliar requires familiarName and collectibleName")
        return
    end

    -- Store registerd familiar
    mod.RegisteredModdedFamiliars[familiarName] = {
        collectibleName = collectibleName,
        spritePath = spritePath
    }
end

local function IsPermanentFamiliar(familiar)
    if not familiar then return false end

    local variant = familiar.Variant

    -- Excluded variants
    if  variant == FamiliarVariant.BLUE_FLY or
        variant == FamiliarVariant.BLUE_SPIDER or
        variant == FamiliarVariant.WISP or
        variant == FamiliarVariant.ITEM_WISP or
        variant == FamiliarVariant.ABYSS_LOCUST or
        variant == FamiliarVariant.KNIFE_PIECE_1 or
        variant == FamiliarVariant.KNIFE_PIECE_2 or
        variant == FamiliarVariant.KEY_FULL or
        variant == FamiliarVariant.UMBILICAL_BABY or
        variant == FamiliarVariant.VANISHING_TWIN then
        return false
    end

    -- Lilith Incubus 
    if variant == FamiliarVariant.INCUBUS then
        if familiar.Player and familiar.Player:GetPlayerType() == PlayerType.PLAYER_LILITH then
            return false
        end
    end

    local data = familiar:GetData()
    if data.IsTemporary or data.IsClone then
        return false
    end

    return true
end

local function GetFamiliarName(familiar)
    local sprite = familiar:GetSprite()

    if sprite then
        local filename = sprite:GetFilename()
        local raw = filename:match("([^/]+)%.anm2$")

        if raw and mod.RegisteredModdedFamiliars then
            for famName, data in pairs(mod.RegisteredModdedFamiliars) do
                if raw:lower() == famName:gsub(" ", ""):lower() then
                    return famName
                end
            end
        end
    end
    for name, value in pairs(FamiliarVariant) do
        if value == familiar.Variant then
            local clean = name:gsub("_", " ")
            clean = clean:gsub("(%a)([%w_']*)", function(a, b)
                return a:upper() .. b:lower()
            end)
            return clean
        end
    end

    return nil
end

local function GetCollectibleForFamiliar(player, familiar)
    local itemConfig = Isaac.GetItemConfig()
    local familiarName = GetFamiliarName(familiar)
    
    if not familiarName then
        print("DEBUG: Could not determine familiar name for variant " .. familiar.Variant)
        return nil
    end
    
    print("DEBUG: Familiar name: " .. familiarName)
    
    -- Check if this is a registered modded familiar
    local registered = mod.RegisteredModdedFamiliars[familiarName]
    if registered then
        print("DEBUG: Found registered modded familiar: " .. familiarName)
        local collectibleName = registered.collectibleName
        
        -- Search for collectible by name
        for i = 1, itemConfig:GetCollectibles().Size - 1 do
            local collectible = itemConfig:GetCollectible(i)
            if collectible and collectible.Name == collectibleName then
                if player:HasCollectible(i) then
                    print("DEBUG: Found collectible '" .. collectibleName .. "' (ID: " .. i .. ")")
                    return i
                end
            end
        end
    end
    
    -- Try vanilla matching: search for collectible with same name as familiar
    for i = 1, itemConfig:GetCollectibles().Size - 1 do
        local collectible = itemConfig:GetCollectible(i)
        if collectible and collectible.Name == familiarName then
            if player:HasCollectible(i) then
                print("DEBUG: Found matching collectible by name: " .. familiarName .. " (ID: " .. i .. ")")
                return i
            end
        end
    end
    
    -- Fallback: try pattern matching for vanilla items
    local searchName = "COLLECTIBLE_" .. familiarName:upper():gsub(" ", "_")
    for name, collectibleID in pairs(CollectibleType) do
        if name == searchName and player:HasCollectible(collectibleID) then
            print("DEBUG: Found matching collectible by pattern: " .. name .. " (ID: " .. collectibleID .. ")")
            return collectibleID
        end
    end

    print("DEBUG: No collectible found for familiar: " .. familiarName)
    return nil
end

local function GetPermanentFamiliars(player)
    local list = {}

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_FAMILIAR then
            local fam = entity:ToFamiliar()

            if fam and fam.Player 
            and GetPtrHash(fam.Player) == GetPtrHash(player)
            and IsPermanentFamiliar(fam) then
                table.insert(list, fam)
            end
        end
    end

    return list
end

local function HasBrokenHearts(player)
    return player:GetBrokenHearts() > 0
end

function mod:SacrificeTableCollision(beggar, collider)
    local player = collider:ToPlayer()
    if not player then return end

    local beggarSprite = beggar:GetSprite()
    local currentAnim = beggarSprite:GetAnimation()
    local isUsed = (currentAnim == "Blood_Idle")

    if not(beggarSprite:IsPlaying("Idle") or beggarSprite:IsPlaying("Blood_Idle")) then
        return
    end

    if player:GetMaxHearts() < 2 then
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        return
    end

    local familiars = GetPermanentFamiliars(player)
    if #familiars == 0 then
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        return
    end

    local rng = beggar:GetDropRNG()
    local chosen = familiars[rng:RandomInt(#familiars) + 1]

    local collectibleID = GetCollectibleForFamiliar(player, chosen)
    if not collectibleID then
        print("Could not find collectible for chosen familiar")
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        return
    end

    local data = beggar:GetData()
    data.LastPayer = player
    data.ChosenCollectibleID = collectibleID

    -- Replace Spritesheet with the familiar's sprite
    local familiarSprite = chosen:GetSprite()
    if familiarSprite then
        local familiarSpritesheet = nil
        local familiarName = GetFamiliarName(chosen)
        
        -- Check if this is a registered modded familiar with custom sprite path
        local registered = familiarName and mod.RegisteredModdedFamiliars[familiarName]
        if registered and registered.spritePath then
            familiarSpritesheet = registered.spritePath
            print("DEBUG: Using registered sprite path: " .. familiarSpritesheet)
        else
            -- Auto-detect sprite path
            familiarSpritesheet = familiarSprite:GetLayer(0):GetSpritesheetPath()
            print("DEBUG: Auto-detected spritesheet path: " .. familiarSpritesheet)
        end
        
        local success = pcall(function()
            beggarSprite:ReplaceSpritesheet(3, familiarSpritesheet)
            beggarSprite:LoadGraphics()
        end)
        
        if success then
            print("DEBUG: Successfully replaced spritesheet 3 with familiar sprite")
        else
            print("ERROR: Failed to replace spritesheet with familiar sprite")
        end
    else
        print("ERROR: Could not get familiar sprite")
    end

    -- Remove the familiar entity
    chosen:Remove()

    -- Play animation
    if isUsed then
        beggarSprite:Play("place_Familiar2")
    else
        beggarSprite:Play("place_Familiar")
    end

    sfx:Play(SoundEffect.SOUND_SCAMPER)
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.SacrificeTableCollision, SacrificeTable)


function mod:SacrificeTableUpdate(beggar)
    local sprite = beggar:GetSprite()
    local data = beggar:GetData()

    if sprite:IsFinished("place_Familiar") then
        sprite:Play("Idle_With_Familiar")
        data.WaitingForSacrifice = true
        return
    end

    if sprite:IsFinished("place_Familiar2") then
        sprite:Play("Idle_With_Familiar2")
        data.WaitingForSacrifice = true
        return
    end

    if data.WaitingForSacrifice
    and (sprite:IsFinished("Idle_With_Familiar") or sprite:IsFinished("Idle_With_Familiar2")) then

        data.WaitingForSacrifice = false

        if data.LastPayer and data.ChosenCollectibleID then
            local player = data.LastPayer
            local collectibleID = data.ChosenCollectibleID

            player:AddMaxHearts(-2, true)

            print("DEBUG: Removing collectible ID " .. collectibleID)
            
            -- Remove the collectible
            player:RemoveCollectible(collectibleID)
            
            -- Force immediate cache update
            player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
            player:EvaluateItems()

            local broken = HasBrokenHearts(player)

            if broken then
                player:AddBrokenHearts(-1)
            end

            if data.HasBeenUsed then
                sprite:Play("Killing_Familiar2")
            else
                sprite:Play("Killing_Familiar")
                data.HasBeenUsed = true
            end
            sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)

            if not broken then
                data.ShouldGivePrize = true
            end
            data.ChosenCollectibleID = nil
        end

        return
    end

    if sprite:IsFinished("Killing_Familiar") or sprite:IsFinished("Killing_Familiar2") then
        if data.ShouldGivePrize then
            sprite:Play("Prize")
            data.ShouldGivePrize = false
        else
            sprite:Play("Blood_Idle")
        end
        return
    end

    if sprite:IsFinished("Prize") then
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)

        local itemPool = game:GetItemPool()
        local item = itemPool:GetCollectible(ItemPoolType.POOL_ULTRA_SECRET, true)

        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            item,
            Isaac.GetFreeNearPosition(beggar.Position, 40),
            Vector.Zero,
            beggar
        )

        sprite:Play("Blood_Idle")
        data.HasBeenUsed = true
        return
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.SacrificeTableUpdate, SacrificeTable)


function mod:SacrificeTableExploded(beggar)
    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
    game:SpawnParticles(beggar.Position, EffectVariant.BLOOD_EXPLOSION, 3, 5, Color.Default)

    for i = 1, 3 do
        Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.BLOOD_SPLAT,
            0,
            beggar.Position + RandomVector() * 20,
            Vector.Zero,
            beggar
        )
    end

    beggar:Remove()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.SacrificeTableExploded, SacrificeTable)

--------------------------------------------------
---          Dies Irae's modded familiars
--------------------------------------------------
mod:RegisterModdedFamiliar("Killer Queen", "Killer Queen", "gfx/familiar/killerqueen.png")
mod:RegisterModdedFamiliar("Paranoid Android", "Paranoid Android", "gfx/familiar/paranoidandroid.png")
mod:RegisterModdedFamiliar("Red Bum", "Red Bum", "gfx/familiar/redbum.png")
mod:RegisterModdedFamiliar("Scammer Bum", "Scammer Bum", "gfx/familiar/scammerbum.png")
mod:RegisterModdedFamiliar("Rune Bum", "Rune Bum", "gfx/familiar/runebum.png")
mod:RegisterModdedFamiliar("Fair Bum", "Fair Bum", "gfx/familiar/fairbum.png")
mod:RegisterModdedFamiliar("Tarot Bum", "Tarot Bum", "gfx/familiar/tarotbum.png")
mod:RegisterModdedFamiliar("Pill Bum", "Pill Bum", "gfx/familiar/pillbum.png")
mod:RegisterModdedFamiliar("Pastor Bum", "Pastor Bum", "gfx/familiar/pastorbum.png")

---------------------------------------------------------------------------
-- Dies Irae: Modded Familiar Sacrifice API Guide (For Other Mods)
--
-- If you are creating a mod and want your custom familiar to work with Dies Irae's Sacrifice Table, follow this guide.

-- The Sacrifice Table will:
--   - Identify your modded familiar correctly
--   - Find the correct collectible associated with it
--   - Display the familiar's icon on the table
--   - Remove the collectible from the player when sacrificed
-- -----------------------------
-- How to access the Dies Irae API
-- -----------------------------
-- In your mod's main.lua, you must access the global DiesIraeMod object.
--
-- Use this exact pattern:
--
--     local diesIrae = _G["DiesIraeMod"]
--
--     if diesIrae and diesIrae.RegisterModdedFamiliar then
--         diesIrae:RegisterModdedFamiliar(
--             "Familiar Name",        -- entity name from entities2.xml
--             "Collectible Name",     -- item name from items.xml
--             "path/to/familiar/path.png" -- Optional. But note that its not the collectible png but the familiar itself.
--         )
--     end
--

-- -----------------------------
-- Example full registration
-- -----------------------------
--
-- main.lua of a different mod:
--
--     local diesIrae = _G["DiesIraeMod"]
--
--     function MyMod:OnGameStart()
--         if diesIrae and diesIrae.RegisterModdedFamiliar then
--             diesIrae:RegisterModdedFamiliar(
--                 "Baby Blaster",
--                 "Baby Blaster",
--                 "gfx/familiar/babyblaster.png"
--             )
--         end
--     end
--     MyMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, MyMod.OnGameStart)

