---@class ModReference
local mod = DiesIraeMod
local game = Game()
local symphonyOfDestruction = {}

mod.CollectibleType.COLLECTIBLE_SYMPHONY_OF_DESTRUCTION = Isaac.GetItemIdByName("Symphony of Destruction")

local Symphony = mod.CollectibleType.COLLECTIBLE_SYMPHONY_OF_DESTRUCTION
local TOWER_CARD = Card.CARD_TOWER

local function ConvertAllCardsOnFloor()
    for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, -1, false, false)) do
        local pickup = entity:ToPickup()
        if pickup == nil then return end
        if pickup.SubType ~= TOWER_CARD then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, TOWER_CARD, true, true)
        end
    end
end

local function ConvertPlayerCards(player)
    for slot = 0, 1 do
        local card = player:GetCard(slot)
        if card ~= 0 and card ~= TOWER_CARD then
            player:SetCard(slot, TOWER_CARD)
        end
    end
end

function symphonyOfDestruction:OnPickup_SymphonyOfDestruction(player, item)
    if item == Symphony then
        ConvertAllCardsOnFloor()
        ConvertPlayerCards(player)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, symphonyOfDestruction.OnPickup_SymphonyOfDestruction)

function symphonyOfDestruction:OnCardSpawn_SymphonyOfDestruction(pickup)
    if game:GetFrameCount() < 10 then return end
    if pickup.Variant == PickupVariant.PICKUP_TAROTCARD and pickup.SubType ~= TOWER_CARD then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player:HasCollectible(Symphony) then
                pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, TOWER_CARD, true, true)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, symphonyOfDestruction.OnCardSpawn_SymphonyOfDestruction, PickupVariant.PICKUP_TAROTCARD)

function symphonyOfDestruction:OnNewRoom_SymphonyOfDestruction()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(Symphony) then
            ConvertAllCardsOnFloor()
            ConvertPlayerCards(player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, symphonyOfDestruction.OnNewRoom_SymphonyOfDestruction)

function symphonyOfDestruction:OnPlayerUpdate_SymphonyOfDestruction(player)
    if not player:HasCollectible(Symphony) then return end
    ConvertPlayerCards(player)
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, symphonyOfDestruction.OnPlayerUpdate_SymphonyOfDestruction)

if EID then 
    EID:assignTransformation("collectible", mod.CollectibleType.COLLECTIBLE_SYMPHONY_OF_DESTRUCTION, "Isaac's sinful Playlist") 
end
