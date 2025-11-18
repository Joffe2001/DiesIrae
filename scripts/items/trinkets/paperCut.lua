local mod = DiesIraeMod
local game = Game()


function mod:OnCardUse_Papercut(card, player, useFlags)
    if player:HasTrinket(mod.Trinkets.Papercut) then
        local room = game:GetRoom()
        local entities = Isaac.GetRoomEntities()
        for _, enemy in ipairs(entities) do
            if enemy:IsActiveEnemy() and not enemy:IsDead() then
                enemy:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnCardUse_Papercut)
