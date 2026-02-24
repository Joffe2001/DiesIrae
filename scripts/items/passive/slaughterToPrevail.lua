---@class ModReference
local mod = DiesIraeMod
local game = Game()
local sfx = SFXManager()

mod.CollectibleType.COLLECTIBLE_SLAUGHTER_TO_PREVAIL = Isaac.GetItemIdByName("Slaughter to Prevail")

local KILL_THRESHOLD = 20
local ANGEL_CHANCE_MIN = 0.05
local ANGEL_CHANCE_MAX = 0.2

mod.SlaughterData = {} -- use the save manager instead

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, entity)
    if not entity:IsEnemy() or entity:IsBoss() then return end

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.Items.SlaughterToPrevail) then
            local data = mod.SlaughterData[player.Index] or {Kills = 0}
            data.Kills = data.Kills + 1

            if data.Kills >= KILL_THRESHOLD then
                local rngIncrease = math.random() * (ANGEL_CHANCE_MAX - ANGEL_CHANCE_MIN) + ANGEL_CHANCE_MIN
                local level = game:GetLevel()
                level:AddAngelRoomChance(rngIncrease)

                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, nil)
                Game():GetHUD():ShowItemText("Slaughter to Prevail: +" .. string.format("%.0f", rngIncrease*100) .. "% Angel Chance!")

                sfx:Play(SoundEffect.SOUND_POWERUP1, 1.0, 0, false, 1.0)

                data.Kills = 0 
            end

            mod.SlaughterData[player.Index] = data
        end
    end
end)
