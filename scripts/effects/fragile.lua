local mod = DiesIraeMod
local Fragile = {}

function Fragile.ApplyFragile(player)
    if player then
        player:GetData().IsFragile = true
        print("[Fragile] Applied to player")
    end
end

function Fragile.OnIsaacDamage(_, entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player then return end

    local data = player:GetData()
    if data and data.IsFragile then
        player:Die()
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, Fragile.OnIsaacDamage)

return Fragile
