---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()
local SacrificeTable = mod.Entities.BEGGAR_SacrificeTable.Var


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

local function GetCollectibleForFamiliar(player, familiar)
    local itemConfig = Isaac.GetItemConfig()

    local familiarName = nil
    for name, value in pairs(FamiliarVariant) do
        if value == familiar.Variant then
            familiarName = name
            break
        end
    end
    
    if not familiarName then
        print("DEBUG: Could not find FamiliarVariant name for variant " .. familiar.Variant)
        return nil
    end
    
    print("DEBUG: Looking for familiar named: " .. familiarName)
    
    -- Search for a collectible with matching name pattern
    local searchName = "COLLECTIBLE_" .. familiarName
    
    for name, collectibleID in pairs(CollectibleType) do
        if name == searchName and player:HasCollectible(collectibleID) then
            print("DEBUG: Found matching collectible: " .. name .. " (ID: " .. collectibleID .. ")")
            return collectibleID
        end
    end

    print("DEBUG: No collectible found with name pattern: " .. searchName)
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
        print("Could not find collectible for chosen familiar variant " .. chosen.Variant)
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        return
    end

    local data = beggar:GetData()
    data.LastPayer = player
    data.ChosenCollectibleID = collectibleID

	-- Replace Spritesheet	
	local familiarSpritesheet = familiar:GetSprite():GetLayer(0):GetSpritesheetPath()
	beggar:Sprite:ReplaceSpritesheet(1, chosen_Spritesheet, true)




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

            player:AddMaxHearts(-2, true)

            print("DEBUG: Removing collectible ID " .. data.ChosenCollectibleID)
            player:RemoveCollectible(data.ChosenCollectibleID, false, nil, true)

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
