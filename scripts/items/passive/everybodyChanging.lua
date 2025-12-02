local mod = DiesIraeMod
local game = Game()
local EverybodysChanging = {}
local itemConfig = Isaac.GetItemConfig()
local SFX = SFXManager()
local MAX_ITEM_ID = itemConfig:GetCollectibles().Size - 1

local roomCleared = false

local function IsValidCandidate(id) 
    if type(id) ~= "number" then return false end 
    local cfg = itemConfig:GetCollectible(id) 
    return cfg 
        and cfg:IsAvailable() 
        and not cfg:HasTags(ItemConfig.TAG_QUEST) and (cfg.Type == ItemType.ITEM_PASSIVE or cfg.Type == ItemType.ITEM_FAMILIAR) 
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
                    local toShuffle = {}
                    for id = 1, MAX_ITEM_ID do
                        local count = player:GetCollectibleNum(id)
                        if count > 0 and IsValidCandidate(id) then
                            for j = 1, count do
                                table.insert(toShuffle, id)
                            end
                        end
                    end

                    for _, id in ipairs(toShuffle) do
                        player:RemoveCollectible(id)
                    end
                    player:EvaluateItems()

                    for _, oldID in ipairs(toShuffle) do
                        local newID
                        local tries = 0
                        repeat
                            newID = math.random(1, MAX_ITEM_ID)
                            tries = tries + 1
                        until (newID and IsValidCandidate(newID)) or tries > 100

                        if newID and IsValidCandidate(newID) then
                            player:AddCollectible(newID, 0, true)
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

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local queued = player.QueuedItem

        if queued and queued.Item and queued.Item.ID == mod.Items.EverybodysChanging then
            SFXManager():Play(mod.Sounds.JEVIL_CHAOS, 1.0, 0, false, 1.0)
            player:FlushQueueItem()
        end
    end
end)

if EID then
    EID:assignTransformation("collectible", mod.Items.EverybodysChanging, "Dad's Playlist")
end
