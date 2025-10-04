local BrokenDream = {}
BrokenDream.TRINKET_ID = Enums.Trinkets.BrokenDream
local game = Game()

local ENDGAME_BOSSES = {
    [EntityType.ENTITY_MOM] = { [1] = true },     
    [EntityType.ENTITY_ISAAC] = { [0] = true },
    [EntityType.ENTITY_BLUEBABY] = { [0] = true },
    [EntityType.ENTITY_SATAN] = { [0] = true },
    [EntityType.ENTITY_THE_LAMB] = { [0] = true },
    [EntityType.ENTITY_MEGA_SATAN_2] = { [0] = true },
    [EntityType.ENTITY_MOTHER] = { [10] = true }
}

function BrokenDream:OnBossDeath(npc)
    if not npc or not npc:IsBoss() then return end

    local typeTable = ENDGAME_BOSSES[npc.Type]
    if not typeTable or not typeTable[npc.Variant] then return end

    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(BrokenDream.TRINKET_ID) then
            print("[Broken Dream] Delirium portal triggered.")
            game:GetLevel():ShowDeliriumPortal()
            return
        end
    end
end

function BrokenDream:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, BrokenDream.OnBossDeath)

    if EID then
        EID:addTrinket(
            BrokenDream.TRINKET_ID,
            "Guarantees Delirium's portal spawns after killing endgame bosses:#It Lives, Isaac, ???, Satan, The Lamb, Mega Satan, Mother.",
            "In a Broken Dream",
            "en_us"
        )
    end
end

return BrokenDream
