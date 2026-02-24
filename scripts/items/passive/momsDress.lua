local mod = DiesIraeMod
local momsDress = {}
local mantle = CollectibleType.COLLECTIBLE_HOLY_MANTLE
local game = Game()

mod.CollectibleType.COLLECTIBLE_MOMS_DRESS = Isaac.GetItemIdByName("Mom's Dress")

function momsDress:SpawnRottenHearts(player)
    for _ = 1, 2 do
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_HEART,
            HeartSubType.HEART_ROTTEN,
            Isaac.GetFreeNearPosition(player.Position, 40),
            Vector.Zero,
            player
        )
    end
end

function momsDress:OnPostAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    if collectibleType == mod.CollectibleType.COLLECTIBLE_MOMS_DRESS then
        momsDress:SpawnRottenHearts(player)
    end
end

function momsDress:OnPostNewRoom()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_MOMS_DRESS) then return end

        local room = game:GetRoom()
        if room:IsClear() then
            return
        end

        local rng = RNG()
        rng:SetSeed(game:GetSeeds():GetStartSeed() + room:GetDecorationSeed(), 35)

        local chance = 0.2 + player:GetCollectibleNum(mod.CollectibleType.COLLECTIBLE_MOMS_DRESS, false) * 0.1

        if rng:RandomFloat() < chance then
            player:AddCollectibleEffect(mantle, true)
        end
    end
end

function momsDress:OnPlayerUpdate(player)
    momsDress:CheckPickup(player)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, momsDress.OnPostNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, momsDress.OnPostAddCollectible)

