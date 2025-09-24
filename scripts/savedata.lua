local SaveData = {}
local json = require("json")

SaveData.Data = {
    Unlocks = {
        David = {
            MomsHeart = false,  -- Unlocks Army of Lovers
            Isaac = false,      -- Unlocks The Bad Touch
            BlueBaby = false,   -- Unlocks Baby Blue (Trinket)
            Satan = false,      -- Unlocks Little Lies
            Lamb = false,       -- Unlocks Paranoid Android
            MegaSatan = false,  -- Unlocks Sh-boom!!
            BossRush = false,   -- Unlocks Universal
            Hush = false,       -- Unlocks Everybody's Changing
            Beast = false,      -- Unlocks U2
            Corpse = false,     -- Unlocks Killer Queen
            UltraGreed = false, -- Unlocks Wonder of You
            UltraGreedier = false, -- Unlocks Ring of Fire
            Delirium = false,   -- Unlocks Helter Skelter
        }
    }
}

-- Save helper
function SaveData.Save(mod)
    mod:SaveData(json.encode(SaveData.Data))
end

-- Load helper
function SaveData.Load(mod)
    if mod:HasData() then
        local loaded = json.decode(mod:LoadData())
        if loaded then
            SaveData.Data = loaded
        end
    end
end

-- Save on exit
function SaveData:OnGameExit()
    SaveData.Save(SaveData.mod)
end

function SaveData:Init(mod)
    SaveData.mod = mod
    SaveData.Load(mod)
    mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, SaveData.OnGameExit)
end

return SaveData
