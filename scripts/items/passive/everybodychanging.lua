local mod = DiesIraeMod

local EverybodysChanging = {}

local game = Game()
local itemConfig = Isaac.GetItemConfig()
local SFX = SFXManager()
local MAX_ITEM_ID = itemConfig:GetCollectibles().Size - 1

local roomCleared = false

local function IsValidCandidate(id)
    if type(id) ~= "number" then return false end
    local cfg = itemConfig:GetCollectible(id)
    return cfg
        and cfg:IsAvailable()
        and not cfg:HasTags(ItemConfig.TAG_QUEST)
        and (cfg.Type == ItemType.ITEM_PASSIVE or cfg.Type == ItemType.ITEM_FAMILIAR)
        and id ~= mod.Items.EverybodysChanging
end

function EverybodysChanging:OnUpdate()
    local room = game:GetRoom()

    if room:IsClear() then
        if not roomCleared then
            roomCleared = true

            for i = 0, game:GetNumPlayers() - 1 do
                local player = Isaac.GetPlayer(i)

                if player:HasCollectible(mod.Items.EverybodysChanging) then
                    local toRemove = {}

                    -- collect all eligible items
                    for id = 1, MAX_ITEM_ID do
                        if player:HasCollectible(id) and IsValidCandidate(id) then
                            table.insert(toRemove, id)
                        end
                    end

                    -- remove them
                    for _, id in ipairs(toRemove) do
                        player:RemoveCollectible(id)
                    end
                    player:EvaluateItems()

                    -- replace 1-for-1
                    for _, oldID in ipairs(toRemove) do
                        local newID
                        local tries = 0
                        repeat
                            newID = math.random(1, MAX_ITEM_ID)
                            tries = tries + 1
                        until (newID and IsValidCandidate(newID)) or tries > 100

                        if newID and IsValidCandidate(newID) then
                            player:AddCollectible(newID, 0, true)  -- silent add
                        end
                    end

                    player:EvaluateItems()
                    player:AnimateCollectible(mod.Items.EverybodysChanging)
                    SFX:Play(SoundEffect.SOUND_EDEN_GLITCH, 1.0, 0, false, 1.0)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
                end
            end
        end
    else
        roomCleared = false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    EverybodysChanging:OnUpdate()
end)

if EID then
    EID:addCollectible(
        mod.Items.EverybodysChanging,
        "After clearing a room, all passive/familiar items are replaced with random ones.",
        "Everybody's Changing",
        "en_us"
    )
    EID:assignTransformation("collectible", mod.Items.EverybodysChanging, "Dad's Playlist")
end
