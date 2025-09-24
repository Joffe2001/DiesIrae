local LittlePieceOfHeaven = {}
LittlePieceOfHeaven.COLLECTIBLE_ID = Isaac.GetItemIdByName("Little Piece of Heaven")
local game = Game()

-- Callback for when Isaac uses the item
function LittlePieceOfHeaven:onUse(player)
    if not player:HasCollectible(LittlePieceOfHeaven.COLLECTIBLE_ID) then return end

    -- Teleport Isaac to the Angel Room
    local level = game:GetLevel()
    local angelRoomIndex = level:GetAngelRoomIndex()  -- Get Angel Room index for the current floor
    if angelRoomIndex then
        -- Use teleport function to move Isaac to Angel Room
        player:Teleport(angelRoomIndex, true)  -- True indicates to use the teleport without any delay
    end
end

-- EID description
function LittlePieceOfHeaven:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, LittlePieceOfHeaven.onUse, LittlePieceOfHeaven.COLLECTIBLE_ID)
    
    if EID then
        EID:addCollectible(
            LittlePieceOfHeaven.COLLECTIBLE_ID,
            "Teleport to the Angel Room when used.",
            "Little Piece of Heaven",
            "en_us"
        )
    end
end

return LittlePieceOfHeaven