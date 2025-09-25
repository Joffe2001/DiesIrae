local HelterSkelter = {}
HelterSkelter.COLLECTIBLE_ID = Enums.Items.HelterSkelter

---@param rng RNG
---@param player EntityPlayer
function HelterSkelter:UseItem(_, rng, player)
    local roomEntities = Isaac.GetRoomEntities()

    for _, entity in ipairs(roomEntities) do
        if entity:IsActiveEnemy(false) and not entity:IsBoss() then
            if rng:RandomFloat() < 0.25 then
                local bony = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, entity.Position, Vector.Zero, player):ToNPC()
                if bony then
                    bony:AddCharmed(EntityRef(player), -1)
                    bony.HitPoints = entity.MaxHitPoints * 0.3
                    bony:SetColor(Color(1, 1, 1, 0.5, 0, 0, 0), -1, 0, false, false)
                end
                entity:Remove()
            end
        end
    end

    return true
end

function HelterSkelter:Init(mod)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, HelterSkelter.UseItem, HelterSkelter.COLLECTIBLE_ID)

    if EID then
        EID:addCollectible(HelterSkelter.COLLECTIBLE_ID,
            "25% chance to turn each enemy into a friendly Bony",
            "Helter Skelter",
            "en_us"
        )
        EID:assignTransformation("collectible", HelterSkelter.COLLECTIBLE_ID, "Dad's Playlist")
    end
end

return HelterSkelter
