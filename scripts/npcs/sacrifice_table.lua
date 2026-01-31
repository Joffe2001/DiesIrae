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

    local cfg = familiar:GetItemConfig()
    if cfg then
        local id = cfg.ID
        if player:HasCollectible(id) then
            return id
        end
    end

    local familiarName = GetFamiliarName(familiar)
    if not familiarName then
        print("Could not determine familiar name for this variant, if its modded familiar, its not on the API")
        return nil
    end

    -- Registered modded familiar
    local registered = mod.RegisteredModdedFamiliars[familiarName]
    if registered then
        local collectibleName = registered.collectibleName

        for i = 1, itemConfig:GetCollectibles().Size - 1 do
            local collectible = itemConfig:GetCollectible(i)
            if collectible and collectible.Name == collectibleName and player:HasCollectible(i) then
                return i
            end
        end
    end

    for i = 1, itemConfig:GetCollectibles().Size - 1 do
        local collectible = itemConfig:GetCollectible(i)
        if collectible and collectible.Name == familiarName and player:HasCollectible(i) then
            return i
        end
    end

    print("No collectible found for this familiar, if its modded familiar, its not on the API")
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

    -- Replace spritesheet with ITEM icon (never familiar sprite)
    local cfg = Isaac.GetItemConfig():GetCollectible(collectibleID)
    if not cfg or not cfg.GfxFileName then
        print("ERROR: Missing item icon for collectible ID " .. tostring(collectibleID))
    else
        print("DEBUG: Using item icon: " .. cfg.GfxFileName)

        pcall(function()
            beggarSprite:ReplaceSpritesheet(3, cfg.GfxFileName)
            beggarSprite:LoadGraphics()
        end)
    end
    -- Remove the familiar entity
    chosen:Remove()

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
mod:RegisterModdedFamiliar("Killer Queen", "Killer Queen", "gfx/collectibles/killerqueen.png")
mod:RegisterModdedFamiliar("Paranoid Android", "Paranoid Android", "gfx/collectibles/paranoidandroid.png")
mod:RegisterModdedFamiliar("Red Bum", "Red Bum", "gfx/collectibles/redbum.png")
mod:RegisterModdedFamiliar("Scammer Bum", "Scammer Bum", "gfx/collectibles/scammerbum.png")
mod:RegisterModdedFamiliar("Rune Bum", "Rune Bum", "gfx/collectibles/runebum.png")
mod:RegisterModdedFamiliar("Fair Bum", "Fair Bum", "gfx/collectibles/fairbum.png")
mod:RegisterModdedFamiliar("Tarot Bum", "Tarot Bum", "gfx/collectibles/tarotbum.png")
mod:RegisterModdedFamiliar("Pill Bum", "Pill Bum", "gfx/collectibles/pillbum.png")
mod:RegisterModdedFamiliar("Pastor Bum", "Pastor Bum", "gfx/collectibles/pastorbum.png")

---------------------------------------------------------------------------
-- Dies Irae – Sacrifice Table Familiar Compatibility Guide
--
-- If you are a modder and want your custom familiar to work with Dies Irae’s Sacrifice Table, follow ONE of the methods below.
---------------------------------------------------------------------------

-- =========================================================
-- METHOD 1 (RECOMMENDED – Repentogon)
-- =========================================================
-- If you are using Repentogon, make sure your familiar is spawned from a collectible and that the familiar has a valid ItemConfig.
--
-- Example:
--   familiar:GetItemConfig() returns a valid ItemConfig_Item
--
-- If this is set correctly, it will:
--   Automatically detect the collectible
--   Remove the correct item
--   Display the item icon
--
-- No registration needed!


-- =========================================================
-- METHOD 2 (LEGACY / FALLBACK – API REGISTRATION)
-- =========================================================
-- If your familiar does NOT have an ItemConfig (older mods, manually spawned familiars, etc.), you must register it manually.
--
-- In your mod’s main.lua:
--
--     local diesIrae = _G["DiesIraeMod"]
--
--     if diesIrae and diesIrae.RegisterModdedFamiliar then
--         diesIrae:RegisterModdedFamiliar(
--             "Familiar Name",        -- EXACT name from entities2.xml
--             "Collectible Name"      -- EXACT name from items.xml
--         )
--     end
--
-- Notes:
-- Names are case-sensitive
-- Familiar Name must match entities2.xml
-- Collectible Name must match items.xml
-- Sprite paths are NOT required (item icon is used automatically)
--
-- If your familiar is not registered and has no ItemConfig, it will NOT be accepted by the Sacrifice Table.
--
-- =========================================================
-- COMMON MISTAKES
-- =========================================================
-- Familiar name does not match entities2.xml
-- Collectible name does not match items.xml
-- Familiar spawned without a collectible
-- Expecting name-based detection for Repentogon familiars
--
-- If something fails, check the debug console for warnings.
--------------------------------------------------------------------------- 