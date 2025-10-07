local mod = DiesIraeMod

mod.Data = {}

function mod:GetData(obj)
    local entHash = GetPtrHash(obj)
    local data = mod.Data[entHash]
    if not data then
        local newData = {}
        mod.Data[entHash] = newData
        data = newData
    end
    return data
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, CallbackPriority.LATE, function(_, obj)
    mod.Data[GetPtrHash(obj)] = nil
end)