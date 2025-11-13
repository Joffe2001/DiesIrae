local mod = DiesIraeMod

local VANILLA_ITEM_IDS = {}

for i = 1, 732 do
    table.insert(VANILLA_ITEM_IDS, i)
end

local function IsVanillaItem(itemID)
    for _, id in ipairs(VANILLA_ITEM_IDS) do
        if id == itemID then
            return true
        end
    end
    return false
end

function mod:DeliriousmindCollect(pickup)
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(mod.Items.DeliriousMind) then
        if not IsVanillaItem(pickup.Item) then
            player:AddTears(0.15)
            player:AddDamage(0.15)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLECT, mod.DeliriousmindCollect)
