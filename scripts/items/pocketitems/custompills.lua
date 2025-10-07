local CustomPills = {}
local game = Game()
local sfx = SFXManager()

-- Pill effect IDs
CustomPills.PILL_CURSED        = Isaac.GetPillEffectByName("Cursed Pill") or -1
CustomPills.PILL_BLESSED       = Isaac.GetPillEffectByName("Blessed Pill") or -1
CustomPills.PILL_HEARTBREAK    = Isaac.GetPillEffectByName("Heartbreak Pill") or -1
CustomPills.PILL_LOVE          = Isaac.GetPillEffectByName("Love Pill") or -1
CustomPills.PILL_POWER_DRAIN   = Isaac.GetPillEffectByName("Power Drain Pill") or -1
CustomPills.PILL_ANGELIC       = Isaac.GetPillEffectByName("Angelic Pill") or -1
CustomPills.PILL_GULPING       = Isaac.GetPillEffectByName("Gulping Pill") or -1
CustomPills.PILL_EQUAL         = Isaac.GetPillEffectByName("Equal Pill") or -1
CustomPills.PILL_USER          = Isaac.GetPillEffectByName("User Pill") or -1

local seraphimWingsCostume = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_HOLY_GRAIL).Costume

function CustomPills:OnUsePill(pillEffect, player, flags)
    local level = game:GetLevel()
    local slot = ActiveSlot.SLOT_PRIMARY

    if pillEffect == CustomPills.PILL_CURSED then
        player:AnimateSad()
        sfx:Play(267)
        local curseList = {
            LevelCurse.CURSE_OF_DARKNESS,
            LevelCurse.CURSE_OF_LABYRINTH,
            LevelCurse.CURSE_OF_THE_LOST,
            LevelCurse.CURSE_OF_THE_UNKNOWN,
            LevelCurse.CURSE_OF_BLIND,
            LevelCurse.CURSE_OF_MAZE
        }
        local selectedCurse = curseList[math.random(#curseList)]
        level:AddCurse(selectedCurse, true)

    elseif pillEffect == CustomPills.PILL_BLESSED then
        player:AnimateHappy()
        sfx:Play(268)
        level:RemoveCurses(
            LevelCurse.CURSE_OF_DARKNESS |
            LevelCurse.CURSE_OF_LABYRINTH |
            LevelCurse.CURSE_OF_THE_LOST |
            LevelCurse.CURSE_OF_THE_UNKNOWN |
            LevelCurse.CURSE_OF_BLIND |
            LevelCurse.CURSE_OF_MAZE 
        )

    elseif pillEffect == CustomPills.PILL_HEARTBREAK then
        player:AnimateSad()
        sfx:Play(267)
        player:AddBrokenHearts(1)

    elseif pillEffect == CustomPills.PILL_LOVE then
        player:AnimateHappy()
        sfx:Play(560)
        if player:GetBrokenHearts() > 0 and math.random() < 0.5 then
            player:AddBrokenHearts(-1)
        end

    elseif pillEffect == CustomPills.PILL_POWER_DRAIN then
        player:AnimateSad()
        sfx:Play(493)
        if player:GetActiveItem(slot) ~= 0 then
            player:SetActiveCharge(0, slot)
        end

    elseif pillEffect == CustomPills.PILL_GULPING then
        player:AnimateHappy()
        sfx:Play(614)
    
        local trinketID = player:GetTrinket(0)
        if trinketID > 0 then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, false, player)
        else
            player:AnimateSad()
        end

    elseif pillEffect == CustomPills.PILL_EQUAL then
        sfx:Play(197)
        local coins, bombs, keys = player:GetNumCoins(), player:GetNumBombs(), player:GetNumKeys()
        local values = {coins, bombs, keys}
        table.sort(values)
        local target = math.random() < 0.5 and values[1] or values[3]
        player:AddCoins(target - coins)
        player:AddBombs(target - bombs)
        player:AddKeys(target - keys)
    end
end    


function CustomPills:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, pillEffect, player, flags)
        CustomPills:OnUsePill(pillEffect, player, flags)
    end)

    --mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CustomPills.PostNewRoom)

    -- Refresh pill IDs on reload
    CustomPills.PILL_CURSED        = Isaac.GetPillEffectByName("Cursed Pill") or -1
    CustomPills.PILL_BLESSED       = Isaac.GetPillEffectByName("Blessed Pill") or -1
    CustomPills.PILL_HEARTBREAK    = Isaac.GetPillEffectByName("Heartbreak Pill") or -1
    CustomPills.PILL_LOVE          = Isaac.GetPillEffectByName("Love Pill") or -1
    CustomPills.PILL_POWER_DRAIN   = Isaac.GetPillEffectByName("Power Drain Pill") or -1
    CustomPills.PILL_ANGELIC       = Isaac.GetPillEffectByName("Angelic Pill") or -1
    CustomPills.PILL_GULPING       = Isaac.GetPillEffectByName("Gulping Pill") or -1
    CustomPills.PILL_EQUAL         = Isaac.GetPillEffectByName("Equal Pill") or -1

    if EID then
        EID:addPill(CustomPills.PILL_CURSED, "Applies a random curse", "Cursed Pill")
        EID:addPill(CustomPills.PILL_BLESSED, "Removes current curses", "Blessed Pill")
        EID:addPill(CustomPills.PILL_HEARTBREAK, "Adds a broken heart", "Heartbreak Pill")
        EID:addPill(CustomPills.PILL_LOVE, "50% chance to remove a broken heart", "Love Pill")
        EID:addPill(CustomPills.PILL_POWER_DRAIN, "Empties active item charge", "Power Drain Pill")
        EID:addPill(CustomPills.PILL_GULPING, "Gulps your current trinket", "Gulping Pill")
        EID:addPill(CustomPills.PILL_EQUAL, "Equalizes your coins, bombs, and keys", "Equal Pill")
    end
end

return CustomPills
