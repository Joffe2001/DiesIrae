local mod = DiesIraeMod
local BreakStuff = {}

local ENEMY_DAMAGE = 100

function BreakStuff:UseBreakStuff(_, _, player, _, _)
    local room = Game():GetRoom()
    Game():ShakeScreen(30)
    SFXManager():Play(SoundEffect.SOUND_LARYNX_SCREAM_HI)
    for x = 0, room:GetGridSize() - 1 do
        local grid = room:GetGridEntity(x)
        if grid and grid:ToRock() then
            room:DestroyGrid(x, true)
        elseif grid and grid:ToDoor() then
            room:DestroyGrid(x, true)
        elseif grid and grid:ToPoop() then
            room:DestroyGrid(x, true)
        end
    end
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy(false) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
            entity:TakeDamage(ENEMY_DAMAGE, 0, EntityRef(player), 0)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, BreakStuff.UseBreakStuff, mod.Items.BreakStuff)

return BreakStuff
