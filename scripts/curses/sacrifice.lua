local CurseSacrifice = {}
local game = Game()
local CURSE_SACRIFICE = 1 << 7  -- Bitmask for curse ID 7

function CurseSacrifice:OnEnterRoom()
    local level = game:GetLevel()
    local room = game:GetRoom()

    if level:GetCurses() & CURSE_SACRIFICE ~= 0 then
        if room:GetType() == RoomType.ROOM_TREASURE then
            -- Trigger sacrifice effects (example: damage, sound, visuals)
            for i = 0, game:GetNumPlayers() - 1 do
                local player = Isaac.GetPlayer(i)
                player:TakeDamage(1, DamageFlag.DAMAGE_CURSED, EntityRef(player), 0)
                SFXManager():Play(241)
            end
        end
    end
end

function CurseSacrifice:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CurseSacrifice.OnEnterRoom)
end

return CurseSacrifice