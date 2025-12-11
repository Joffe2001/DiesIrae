local DiesIraeMod = RegisterMod("Dies Irae", 1)
DiesIraeMod.savedata = nil

local json = require("json")
function DiesIraeMod.GetSaveData()
    if not DiesIraeMod.menusavedata then
        if Isaac.HasModData(DiesIraeMod) then
            DiesIraeMod.menusavedata = json.decode(Isaac.LoadModData(DiesIraeMod))
        else
            DiesIraeMod.menusavedata = {}
        end
    end

    return DiesIraeMod.menusavedata
end

function DiesIraeMod.StoreSaveData()
    Isaac.SaveModData(DiesIraeMod, json.encode(DiesIraeMod.menusavedata))
end

local DSSModName = "Dead Sea Scrolls (Dies Irae)"