local EverybodysChanging = {}
EverybodysChanging.COLLECTIBLE_ID = Enums.Items.EverybodysChanging

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
        and id ~= EverybodysChanging.COLLECTIBLE_ID
end

function EverybodysChanging:OnUpdate()
    local room = game:GetRoom()

    if room:IsClear() then
        if not roomCleared then
            roomCleared = true

            for i = 0, game:GetNumPlayers() - 1 do
                local player = Isaac.GetPlayer(i)

                if player:HasCollectible(EverybodysChanging.COLLECTIBLE_ID) then
                    local toRemove = {}
                    for id = 1, MAX_ITEM_ID do
                        if player:HasCollectible(id) and IsValidCandidate(id) then
                            table.insert(toRemove, id)
                        end
                    end

                    for _, id in ipairs(toRemove) do
                        player:RemoveCollectible(id)
                    end
                    player:EvaluateItems()

                    for _, oldID in ipairs(toRemove) do
                        local newID
                        local tries = 0
                        repeat
                            newID = math.random(1, MAX_ITEM_ID)
                            tries = tries + 1
                        until (newID and IsValidCandidate(newID)) or tries > 100

                        if newID and IsValidCandidate(newID) then
                            player:AddCollectible(newID, 0, false) 
                        end
                    end

                    player:EvaluateItems()
                    player:AnimateCollectible(EverybodysChanging.COLLECTIBLE_ID)
                    SFX:Play(SoundEffect.SOUND_EDEN_GLITCH, 1.0, 0, false, 1.0)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
                end
            end
        end
    else
        roomCleared = false
    end
end

function EverybodysChanging:Init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
        EverybodysChanging:OnUpdate()
    end)

    if EID then
        EID:addCollectible(
            EverybodysChanging.COLLECTIBLE_ID,
            "After clearing a room, all passive/familiar items are replaced with random ones.",
            "Everybody's Changing",
            "en_us"
        )
        EID:assignTransformation("collectible", EverybodysChanging.COLLECTIBLE_ID, "Dad's Playlist")
    end
end

return EverybodysChanging
