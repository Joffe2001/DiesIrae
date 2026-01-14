local mod = DiesIraeMod

----MASSIVE THANKS TO @umimerhimhair on Discord
mod.GelloCostumes = {}

-- Block rules
local blockCostumes = {}

---@return boolean
local function canShowCostume()
    for _, rule in ipairs(blockCostumes) do
        if rule() then
            return false
        end
    end
    return true
end

---@param func function
function mod.GelloCostumes:AddNoCostumeRule(func)
    table.insert(blockCostumes, func)
end

-- Default rule example
mod.GelloCostumes:AddNoCostumeRule(function()
    return Game():GetRoom():HasCurseMist()
end)

-- Costume storage
mod.GelloCostumes.Costumes = {
    Other = {},
    Items = {}
}

---@param condition function
---@param costumes table
---@param priorities table
---@param specialEffects? function
function mod.GelloCostumes:AddCostume(condition, costumes, priorities, specialEffects)
    local config = {
        Condition = condition,
        Costumes = {
            Body = costumes.Body or nil,
            Extra1 = costumes.Extra1 or nil,
            Extra2 = costumes.Extra2 or nil,
        },
        Priorities = {
            Body = priorities.Body or -1,
            Extra1 = priorities.Extra1 or -1,
            Extra2 = priorities.Extra2 or -1,
        },
        SpecialEffects = specialEffects or nil
    }
    config.TryApplyCostumes = function(currentCostumes)
        for layer, _ in pairs(currentCostumes.Costumes) do
            if config.Priorities[layer] > currentCostumes.Priorities[layer] then
                currentCostumes.Costumes[layer] = config.Costumes[layer]
                currentCostumes.Priorities[layer] = config.Priorities[layer]
            end
        end
        return currentCostumes
    end
    table.insert(mod.GelloCostumes.Costumes.Other, config)
end

---@param id CollectibleType
---@param costumes table
---@param priorities table
---@param specialEffects? function
function mod.GelloCostumes:AddItemCostume(id, costumes, priorities, specialEffects)
    local config = {
        Item = id,
        Costumes = {
            Body = costumes.Body or nil,
            Extra1 = costumes.Extra1 or nil,
            Extra2 = costumes.Extra2 or nil,
        },
        Priorities = {
            Body = priorities.Body or -1,
            Extra1 = priorities.Extra1 or -1,
            Extra2 = priorities.Extra2 or -1,
        },
        SpecialEffects = specialEffects or nil
    }
    mod.GelloCostumes.Costumes.Items[id] = config
end

-- Layer mapping
local nameToLayerIDs = {
    Body = {0, 1},
    Extra1 = {3},
    Extra2 = {4}
}

---@param sprite Sprite
---@param costumes table
---@param specialEffects? function
function mod.GelloCostumes:ApplyCostumes(sprite, costumes, specialEffects)
    sprite:Load("gfx/familiar/gello.anm2", false)
    for layerName, ids in pairs(nameToLayerIDs) do
        for _, layerId in ipairs(ids) do
            sprite:ReplaceSpritesheet(layerId, costumes[layerName])
        end
    end
    if specialEffects then
        specialEffects(sprite)
    end
    sprite:LoadGraphics()
end

---@return table
function mod.GelloCostumes:CreateEmptyCostumeTable()
    return {
        Priorities = {
            Body = 0,
            Extra1 = 0,
            Extra2 = 0,
        },
        Costumes = {
            Body = "gfx/familiar/umbilical_baby/base.png",
            Extra1 = "gfx/familiar/umbilical_baby/null.png",
            Extra2 = "gfx/familiar/umbilical_baby/null.png",
        },
        SpecialEffects = nil
    }
end

-- Helper to find player spawner
---@param entity Entity
---@return EntityPlayer | nil
local function tryFindPlayerSpawner(entity)
    while entity do
        if entity:ToPlayer() then
            return entity:ToPlayer()
        end
        entity = entity.SpawnerEntity
    end
    return nil
end

-- Get applicable costumes for a familiar
---@param fam EntityFamiliar
---@return table
local function getCostumes(fam)
    local costumes = mod.GelloCostumes:CreateEmptyCostumeTable()
    local player = tryFindPlayerSpawner(fam)
    if player then
        local history = player:GetHistory():GetCollectiblesHistory()
        for i = 1, #history do
            local item = history[i]
            if not item:IsTrinket() then
                local config = mod.GelloCostumes.Costumes.Items[item:GetItemID()]
                if config then
                    for layer, costume in pairs(config.Costumes) do
                        if costumes.Priorities[layer] <= config.Priorities[layer] then
                            costumes.Costumes[layer] = costume
                            costumes.Priorities[layer] = config.Priorities[layer]
                        end
                    end
                    if config.SpecialEffects then
                        costumes.SpecialEffects = config.SpecialEffects
                    end
                end
            end
        end
        for _, config in ipairs(mod.GelloCostumes.Costumes.Other) do
            if config.Condition(player) then
                costumes = config.TryApplyCostumes(costumes)
                if config.SpecialEffects then
                    costumes.SpecialEffects = config.SpecialEffects
                end
            end
        end
    end
    return costumes
end

-- Apply costumes to familiar
---@param fam EntityFamiliar
function mod.GelloCostumes:ApplyToFamiliar(fam)
    if fam.SubType ~= 0 or fam.FrameCount ~= 0 or not canShowCostume() then return end
    local player = tryFindPlayerSpawner(fam)
    if not player then return end
    local costumes = getCostumes(fam)
    self:ApplyCostumes(fam:GetSprite(), costumes.Costumes, costumes.SpecialEffects)
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    if fam.SubType ~= 0 then return end
    mod.GelloCostumes:ApplyToFamiliar(fam)
end, FamiliarVariant.UMBILICAL_BABY)

--------------------
--   MODDED COSTUMES
--------------------
mod.GelloCostumes:AddItemCostume(
    mod.Items.ThoughtContagion, { Body = "gfx/familiar/gello/toughtcontagion_gello.png" }, { Body = 1 })

mod.GelloCostumes:AddItemCostume(
    mod.Items.CreatineOverdose, { Body = "gfx/familiar/gello/creatineoverdose_gello.png" }, { Body = 1 })

    mod.GelloCostumes:AddItemCostume(
        mod.Items.GoldenDay, { Body = "gfx/familiar/gello/goldenday_gello.png" }, { Body = 1 })