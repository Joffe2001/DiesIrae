local mod = DiesIraeMod
local game = Game()

function mod:PostPlayerUpdate_MimicMemory(player)
    if not player:HasCollectible(mod.Items.MimicMemory) then return end

    local data = player:GetData()
    data.LastCollectibles = data.LastCollectibles or {}

    for itemID = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
        local count = player:GetCollectibleNum(itemID)

        local lastCount = data.LastCollectibles[itemID] or 0
        if count > lastCount then

            local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
            if itemConfig then
                local itemPool = game:GetItemPool()
                local poolType = itemPool:GetPoolForRoom(itemConfig.RoomPool or ItemPoolType.POOL_TREASURE, game:GetLevel():GetCurrentRoom():GetSpawnSeed())

                if poolType ~= ItemPoolType.POOL_NULL then
                    itemPool:AddCollectible(itemID, 0, poolType)
                end
            end
        end

        data.LastCollectibles[itemID] = count
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.PostPlayerUpdate_MimicMemory)
