local mod = DiesIraeMod
local BigKahunaBurger = {}
BigKahunaBurger.COLLECTIBLE_ID = mod.Items.BigKahunaBurger

function BigKahunaBurger:onCollectibleAdded(_, Type, Charge, FirstTime, Slot, VarData, player)
    if Type ~= BigKahunaBurger.COLLECTIBLE_ID then return end

    local containers = math.random(1, 3)
    player:AddMaxHearts(containers * 2)
    player:AddHearts(containers * 2)
end

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(mod, Type, Charge, FirstTime, Slot, VarData, player)
    BigKahunaBurger:onCollectibleAdded(mod, Type, Charge, FirstTime, Slot, VarData, player)
end)

return BigKahunaBurger
