local mod = DiesIraeMod

local DadsDumbbell = {}
local game = Game()

mod.CollectibleType.COLLECTIBLE_DADS_DUMBBELL = Isaac.GetItemIdByName("Dad's Dumbbell")

local TEAR_EFFECT_TAG = "DadsDumbbellEffect"

function DadsDumbbell:OnTearInit(tear)
    local player = tear.Parent
    if not player or not player:HasCollectible(mod.CollectibleType.COLLECTIBLE_DADS_DUMBBELL) then
        return
    end

    if math.random() < 0.10 then
        local data = tear:GetData()
        data[TEAR_EFFECT_TAG] = true
        tear:SetColor(Color(1, 0, 0, 1, 0, 0, 0), 1, 1, true, false)
        data["OriginalDamage"] = tear.CollisionDamage
        Isaac.ConsoleOutput("DadsDumbbell effect applied to a tear!\n")
    end
end

function DadsDumbbell:OnTearUpdate(tear)
    local data = tear:GetData()
    if data[TEAR_EFFECT_TAG] then
        if not data["DamageApplied"] then
            tear.CollisionDamage = tear.CollisionDamage + 2
            data["DamageApplied"] = true
            Isaac.ConsoleOutput("DadsDumbbell damage increased!\n")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, DadsDumbbell.OnTearInit)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, DadsDumbbell.OnTearUpdate)
