---@class ModReference
local mod = DiesIraeMod
local game = Game()
local Symphony = mod.Items.SymphonyOfDestr
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

function mod:OnPickup_SymphonyOfDestruction(player, item)
    if item == Symphony then
        ConvertAllCardsOnFloor()
        ConvertPlayerCards(player)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.OnPickup_SymphonyOfDestruction)

function mod:OnCardSpawn_SymphonyOfDestruction(pickup)
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
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OnCardSpawn_SymphonyOfDestruction, PickupVariant.PICKUP_TAROTCARD)

function mod:OnNewRoom_SymphonyOfDestruction()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(Symphony) then
            ConvertAllCardsOnFloor()
            ConvertPlayerCards(player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom_SymphonyOfDestruction)

function mod:OnPlayerUpdate_SymphonyOfDestruction(player)
    if not player:HasCollectible(Symphony) then return end
    ConvertPlayerCards(player)
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPlayerUpdate_SymphonyOfDestruction)

if EID then 
    EID:assignTransformation("collectible", mod.Items.SymphonyOfDestr, "Isaac's sinful Playlist") 
end
