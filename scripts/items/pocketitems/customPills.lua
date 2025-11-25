local mod = DiesIraeMod

local CustomPills = {}
local game = Game()
local sfx = SFXManager()


function CustomPills:OnUsePill(pillEffect, player, flags)
    local level = game:GetLevel()
    local slot = ActiveSlot.SLOT_PRIMARY

------ Cursed pill -----------
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
------ blessed pill -----------
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
------ Heartbreak pill -----------
    elseif pillEffect == mod.Pills.HEARTBREAK then
        player:AnimateSad()
        sfx:Play(267)
        player:AddBrokenHearts(1)

------ Power drain pill -----------
    elseif pillEffect == mod.Pills.POWER_DRAIN then
        player:AnimateSad()
        sfx:Play(493)
        if player:GetActiveItem(slot) ~= 0 then
            player:SetActiveCharge(0, slot)
        end

------ Equal pill -----------
    elseif pillEffect == mod.Pills.EQUAL then
        sfx:Play(197)
        local coins, bombs, keys = player:GetNumCoins(), player:GetNumBombs(), player:GetNumKeys()
        local values = {coins, bombs, keys}
        table.sort(values)
        local target = math.random() < 0.5 and values[1] or values[3]
        player:AddCoins(target - coins)
        player:AddBombs(target - bombs)
        player:AddKeys(target - keys)

------ Vomit pill -----------        
    elseif pillEffect == mod.Pills.VOMIT then

        local rng = player:GetPillRNG(mod.Pills.VOMIT)
        local trinketID = rng:RandomInt(TrinketType.NUM_TRINKETS - 1) + 1

        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TRINKET,
            trinketID,
            game:GetRoom():FindFreePickupSpawnPosition(player.Position),
            Vector.Zero,
            player
        )

------ Something changed pill -----------        
    elseif pillEffect == mod.Pills.SOMETHING_CHANGED then
        sfx:Play(268)

        for trinketSlot = 0, 1 do
            local oldTrinket = player:GetTrinket(trinketSlot)
            if oldTrinket > 0 then
                player:TryRemoveTrinket(oldTrinket)

                local rng = player:GetPillRNG(mod.Pills.SOMETHING_CHANGED)
                local newTrinket = rng:RandomInt(TrinketType.NUM_TRINKETS - 1) + 1
                player:AddTrinket(newTrinket)
            end
        end
    end
end    
mod:AddCallback(ModCallbacks.MC_USE_PILL, CustomPills.OnUsePill)

