local BrokenDream = {}
BrokenDream.TRINKET_ID = Isaac.GetTrinketIdByName("In a Broken Dream")
local game = Game()

-- Boss types that should trigger Delirium's portal
local ENDGAME_BOSSES = {
    [EntityType.ENTITY_IT_LIVES] = true,
    [EntityType.ENTITY_ISAAC] = true,
    [EntityType.ENTITY_BLUE_BABY] = true,
    [EntityType.ENTITY_SATAN] = true,
    [EntityType.ENTITY_THE_LAMB] = true,
    [EntityType.ENTITY_MEGA_SATAN] = true,
    [EntityType.ENTITY_MOTHER] = true
}

function BrokenDream:OnBossDeath(npc)
    if not npc or not npc:IsBoss() then return end

    local shouldTrigger = ENDGAME_BOSSES[npc.Type]
    if not shouldTrigger then return end

    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(BrokenDream.TRINKET_ID) then
            print("[Broken Dream] Delirium portal triggered.")
            game:GetLevel():ShowDeliriumPortal()
            break
        end
    end
end

function BrokenDream:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, BrokenDream.OnBossDeath)

    if EID then
        EID:addTrinket(
            BrokenDream.TRINKET_ID,
            "Delirium's portal always spawns after killing endgame bosses.#Triggers after: Mom's Heart, ???, Isaac, Satan, The Lamb, Mega Satan, and Corpse.",
            "In a Broken Dream",
            "en_us"
        )
    end
end

return BrokenDream
