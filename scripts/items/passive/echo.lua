local mod = DiesIraeMod

mod.CollectibleType.COLLECTIBLE_ECHO = Isaac.GetItemIdByName("Echo")

mod:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_STAGE_PENALTY, function()
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(mod.CollectibleType.COLLECTIBLE_ECHO) then
        return false 
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PLANETARIUM_CALCULATE, function(_, chance)
    local player = Isaac.GetPlayer(0)
    if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_ECHO) then
        return chance
    end
    local stage = Game():GetLevel():GetStage()

    if stage >= LevelStage.STAGE4_1 then
        return 0.10
    end

    local bonus = 0.25
    local newChance = chance + bonus
    return newChance
end)
