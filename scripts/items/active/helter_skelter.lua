local mod = DiesIraeMod

local HelterSkelter = {}

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

mod:AddCallback(ModCallbacks.MC_USE_ITEM, HelterSkelter.UseItem, mod.Items.HelterSkelter)

