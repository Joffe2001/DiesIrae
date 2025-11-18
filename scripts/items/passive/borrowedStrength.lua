local mod = DiesIraeMod
local game = Game()

local BorrowedStrength = {}

function BorrowedStrength:onCache(player, cacheFlag)
    if not player:HasCollectible(mod.Items.BorrowedStrength) then return end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 2
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BorrowedStrength.onCache)

function BorrowedStrength:OnNewFloor()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.BorrowedStrength) then
            local redHearts = player:GetHearts()
            local newHearts = math.max(1, math.floor(redHearts / 2))
            
            local toRemove = redHearts - newHearts
            if toRemove > 0 then
                player:AddHearts(-toRemove)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BorrowedStrength.OnNewFloor)
