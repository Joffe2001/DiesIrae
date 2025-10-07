local mod = DiesIraeMod

local CustomPills = {}
local game = Game()
local sfx = SFXManager()

local seraphimWingsCostume = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_HOLY_GRAIL).Costume

function CustomPills:OnUsePill(pillEffect, player, flags)
    local level = game:GetLevel()
    local slot = ActiveSlot.SLOT_PRIMARY

    if pillEffect == mod.Pills.CURSED then
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

    elseif pillEffect == mod.Pills.BLESSED then
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

    elseif pillEffect == mod.Pills.HEARTBREAK then
        player:AnimateSad()
        sfx:Play(267)
        player:AddBrokenHearts(1)

    elseif pillEffect == mod.Pills.LOVE then
        player:AnimateHappy()
        sfx:Play(560)
        if player:GetBrokenHearts() > 0 and math.random() < 0.5 then
            player:AddBrokenHearts(-1)
        end

    elseif pillEffect == mod.Pills.POWER_DRAIN then
        player:AnimateSad()
        sfx:Play(493)
        if player:GetActiveItem(slot) ~= 0 then
            player:SetActiveCharge(0, slot)
        end

    elseif pillEffect == mod.Pills.GULPING then
        player:AnimateHappy()
        sfx:Play(614)
    
        -- Check if the player has a trinket
        local trinketID = player:GetTrinket(0)
        if trinketID > 0 then
            -- If player has a trinket, use the active item (COLLECTIBLE_SMELTER) to gulp it
            player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, false, player)
        else
            -- If no trinket, you could either show an error message or do nothing
            -- For now, let's just play a sad animation to indicate no trinket was found
            player:AnimateSad()
        end

    elseif pillEffect == mod.Pills.EQUAL then
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


mod:AddCallback(ModCallbacks.MC_USE_PILL, CustomPills.OnUsePill)

if EID then
    EID:addPill(mod.Pills.BLESSED, "Removes current curses", "Blessed Pill")
    EID:addPill(mod.Pills.HEARTBREAK, "Adds a broken heart", "Heartbreak Pill")
    EID:addPill(mod.Pills.LOVE, "50% chance to remove a broken heart", "Love Pill")
    EID:addPill(mod.Pills.POWER_DRAIN, "Empties active item charge", "Power Drain Pill")
    EID:addPill(mod.Pills.GULPING, "Gulps your current trinket", "Gulping Pill")
    EID:addPill(mod.Pills.EQUAL, "Equalizes your coins, bombs, and keys", "Equal Pill")
end
