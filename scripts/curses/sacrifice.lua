local CurseSacrifice = {}
local game = Game()

--- MAGIC NUMBERS
---
local CURSE_SACRIFICE = 1 << 7  -- Bitmask for curse ID 7
local SATAN_GROWL = 241


function CurseSacrifice:OnEnterRoom()
    local level = game:GetLevel()
    local room = game:GetRoom()

    if level:GetCurses() & CURSE_SACRIFICE ~= 0 then
        if room:GetType() == RoomType.ROOM_TREASURE then
            -- Trigger sacrifice effects (example: damage, sound, visuals)
            for _, player in ipairs(PlayerManager.GetPlayers()) do
                player:TakeDamage(1, DamageFlag.DAMAGE_CURSED_DOOR, EntityRef(player), 0)
                SFXManager():Play(SATAN_GROWL)
            end
        end
    end
end

function CurseSacrifice:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CurseSacrifice.OnEnterRoom)
end

return CurseSacrifice
