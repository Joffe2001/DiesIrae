local mod = DiesIraeMod

local CustomPills = {}
local game = Game()
local sfx = SFXManager()
local utils = require("scripts.core.utils")

function CustomPills:OnUsePill(pillEffect, player, flags)
    local level = game:GetLevel()
    local slot = ActiveSlot.SLOT_PRIMARY

    -------------------------------------------------
    -- CURSED PILL
    -------------------------------------------------
    if pillEffect == mod.Pills.CURSED then
        player:AnimateSad()
        utils.PlayVoiceline(mod.Sounds.CURSED, flags, player)

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

    -------------------------------------------------
    -- BLESSED PILL
    -------------------------------------------------
    elseif pillEffect == mod.Pills.BLESSED then
        player:AnimateHappy()
        utils.PlayVoiceline(mod.Sounds.BLESSED, flags, player)

        level:RemoveCurses(
            LevelCurse.CURSE_OF_DARKNESS |
            LevelCurse.CURSE_OF_LABYRINTH |
            LevelCurse.CURSE_OF_THE_LOST |
            LevelCurse.CURSE_OF_THE_UNKNOWN |
            LevelCurse.CURSE_OF_BLIND |
            LevelCurse.CURSE_OF_MAZE 
        )

    -------------------------------------------------
    -- HEARTBREAK PILL
    -------------------------------------------------
    elseif pillEffect == mod.Pills.HEARTBREAK then
        player:AnimateSad()
        utils.PlayVoiceline(mod.Sounds.HEARTBREAK, flags, player)
        player:AddBrokenHearts(1)

    -------------------------------------------------
    -- POWER DRAIN PILL
    -------------------------------------------------
    elseif pillEffect == mod.Pills.POWER_DRAIN then
        player:AnimateSad()
        utils.PlayVoiceline(mod.Sounds.POWER_DRAIN, flags, player)

        if player:GetActiveItem(slot) ~= 0 then
            player:SetActiveCharge(0, slot)
        end

    -------------------------------------------------
    -- EQUAL PILL
    -------------------------------------------------
    elseif pillEffect == mod.Pills.EQUAL then
        utils.PlayVoiceline(mod.Sounds.EQUAL, flags, player)

        local coins, bombs, keys = player:GetNumCoins(), player:GetNumBombs(), player:GetNumKeys()
        local values = {coins, bombs, keys}
        table.sort(values)

        local target = math.random() < 0.5 and values[1] or values[3]

        player:AddCoins(target - coins)
        player:AddBombs(target - bombs)
        player:AddKeys(target - keys)

    -------------------------------------------------
    -- VOMIT PILL
    -------------------------------------------------
    elseif pillEffect == mod.Pills.VOMIT then
        utils.PlayVoiceline(mod.Sounds.VOMIT, flags, player)

        local rng = player:GetCollectibleRNG(mod.Pills.VOMIT)
        local trinketID = rng:RandomInt(TrinketType.NUM_TRINKETS - 1) + 1

        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TRINKET,
            trinketID,
            game:GetRoom():FindFreePickupSpawnPosition(player.Position),
            Vector.Zero,
            player
        )
    -------------------------------------------------
    -- SOMETHING CHANGED PILL
    -------------------------------------------------
    elseif pillEffect == mod.Pills.SOMETHING_CHANGED then
        utils.PlayVoiceline(mod.Sounds.SOMETHING_CHANGED, flags, player)

        for trinketSlot = 0, 1 do
            local oldTrinket = player:GetTrinket(trinketSlot)

            if oldTrinket > 0 then
                player:TryRemoveTrinket(oldTrinket)

                local rng = player:GetCollectibleRNG(mod.Pills.SOMETHING_CHANGED)
                local newTrinket = rng:RandomInt(TrinketType.NUM_TRINKETS - 1) + 1

                player:AddTrinket(newTrinket)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, CustomPills.OnUsePill)

