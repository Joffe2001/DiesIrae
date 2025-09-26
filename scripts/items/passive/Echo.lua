local Echo = {}
Echo.COLLECTIBLE_ID = Enums.Items.Echo
local rng = RNG()

function Echo:Init(mod)
    rng:SetSeed(Random(), 1)

    mod:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_ITEMS, function(_, chance)
        local player = Isaac.GetPlayer(0)
        if player:HasCollectible(Echo.COLLECTIBLE_ID) then
            local stage = Game():GetLevel():GetStage()
            local bonus = stage >= LevelStage.STAGE4_1 and 0.10 or 0.25
            local newChance = chance + bonus

            print("[Echo] Player has Echo! Current stage: " .. tostring(stage))
            print(string.format("[Echo] Base chance: %.2f%% | Bonus: %.2f%% | Final chance: %.2f%%", chance * 100, bonus * 100, newChance * 100))

            return newChance
        end
        return chance
    end)

    if EID then
        EID:addCollectible(
            Echo.COLLECTIBLE_ID,
            "{{Planetarium}} Adds +25% Planetarium chance, +10% on Womb and onward.",
            "Echo",
            "en_us"
        )
    end
end

return Echo
