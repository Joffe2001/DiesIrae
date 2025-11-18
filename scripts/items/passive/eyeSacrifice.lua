local mod = DiesIraeMod
local game = Game()

function mod:EyeSacrifice_PreTear(player)
    if player:HasCollectible(mod.Items.EyeSacrifice) then
        local tearDisplacement = player:GetTearDisplacement()
        if tearDisplacement == -1 then
            return false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_FIRE_TEAR, mod.EyeSacrifice_PreTear)