local mod = DiesIraeMod
local CurseOfTheUnloved = {}

---@param pickup EntityPickup
---@param collider Entity
---@param low boolean
function CurseOfTheUnloved:OnPickupCollision(pickup, collider, low)
    if (Game():GetLevel():GetCurses() & mod.Curses.Unloved) == 0 then
        return
    end

    local player = collider:ToPlayer()
    if not player then return end
    if pickup.Variant == PickupVariant.PICKUP_HEART then
        return true 
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CurseOfTheUnloved.OnPickupCollision)
