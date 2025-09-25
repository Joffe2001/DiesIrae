local DadsDumbbell = {}
DadsDumbbell.COLLECTIBLE_ID = Isaac.GetItemIdByName("Dad's Dumbbell")
local game = Game()

local TEAR_EFFECT_TAG = "DadsDumbbellEffect"

function DadsDumbbell:OnTearInit(tear)
    local player = tear.Parent
    if not player or not player:HasCollectible(DadsDumbbell.COLLECTIBLE_ID) then
        return
    end

    -- 10% chance to give this tear the effect
    if math.random() < 0.10 then
        local data = tear:GetData()
        data[TEAR_EFFECT_TAG] = true
        -- Change tear color to red
        tear:SetColor(Color(1, 0, 0, 1, 0, 0, 0), 1, 1, true, false)
        -- Save original damage for reference if needed
        data["OriginalDamage"] = tear.CollisionDamage
        -- Debug: print when effect is assigned
        Isaac.ConsoleOutput("DadsDumbbell effect applied to a tear!\n")
    end
end

function DadsDumbbell:OnTearUpdate(tear)
    local data = tear:GetData()
    if data[TEAR_EFFECT_TAG] then
        -- Increase damage by 2 once
        if not data["DamageApplied"] then
            -- Increase damage
            tear.CollisionDamage = tear.CollisionDamage + 2
            data["DamageApplied"] = true
            -- Debug: print when damage is increased
            Isaac.ConsoleOutput("DadsDumbbell damage increased!\n")
        end
    end
end

function DadsDumbbell:Init(mod)
    -- Hook into tear creation
    mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, DadsDumbbell.OnTearInit)
    -- Hook into tear update
    mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, DadsDumbbell.OnTearUpdate)

    if EID then
        EID:addCollectible(
            DadsDumbbell.COLLECTIBLE_ID,
            "Each tear has a 10% chance to deal +2 damage and turn red.",
            "Dad's Dumbbell"
        )
    end
end

return DadsDumbbell