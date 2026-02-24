local mod = DiesIraeMod
local saveManager = mod.SaveManager

-------------------------------------------------
-- MenuProvider
-------------------------------------------------
local MenuProvider = {}

function MenuProvider.SaveSaveData()
    saveManager.Save()
end

function MenuProvider.GetPaletteSetting()
    local dssSave = saveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuPalette or nil
end

function MenuProvider.SavePaletteSetting(var)
    saveManager.GetDeadSeaScrollsSave().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return saveManager.GetDeadSeaScrollsSave().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        saveManager.GetDeadSeaScrollsSave().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    local dssSave = saveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.GamepadToggle or nil
end

function MenuProvider.SaveGamepadToggleSetting(var)
    saveManager.GetDeadSeaScrollsSave().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    local dssSave = saveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuKeybind or nil
end

function MenuProvider.SaveMenuKeybindSetting(var)
    saveManager.GetDeadSeaScrollsSave().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    local dssSave = saveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuHint or nil
end

function MenuProvider.SaveMenuHintSetting(var)
    saveManager.GetDeadSeaScrollsSave().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    local dssSave = saveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuBuzzer or nil
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    saveManager.GetDeadSeaScrollsSave().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    local dssSave = saveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenusNotified or nil
end

function MenuProvider.SaveMenusNotified(var)
    saveManager.GetDeadSeaScrollsSave().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    local dssSave = saveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenusPoppedUp or nil
end

function MenuProvider.SaveMenusPoppedUp(var)
    saveManager.GetDeadSeaScrollsSave().MenusPoppedUp = var
end

-------------------------------------------------
-- Init DSS
-------------------------------------------------
local dssmenucore = include("scripts.modcompat.dssmenucore")
local dssMod = dssmenucore.init("Dead Sea Scrolls (Dies Irae)", MenuProvider)


-------------------------------------------------
-- Settings helpers
-------------------------------------------------
local function GetSetting(key, default)
    local data = saveManager.GetSettingsSave()
    if data[key] == nil then return default end
    return data[key]
end

local function SetSetting(key, val)
    local data = saveManager.GetSettingsSave()
    data[key] = val
end

-------------------------------------------------
-- Achievement data
-------------------------------------------------
local GFX_ROOT = "gfx/ui/achievements/"

local achievementData = {
    -- Characters
    { group="characters", name="david",             id=mod.Achievements.David,              gfx=GFX_ROOT.."achievement_david.png",              unlock="Unlocked by getting the three golden picks in a single run", desc="Being a king is a bit of challenge" },
    { group="characters", name="elijah",            id=mod.Achievements.Elijah,             gfx=GFX_ROOT.."elijah.png",                         unlock="placeholder", desc="placeholder" },
    -- Elijah
    { group="elijah", name="scammer bum",           id=mod.Achievements.ScammerBum,         gfx=GFX_ROOT.."achievement_scammerbum.png",         unlock="placeholder", desc="placeholder" },
    { group="elijah", name="red bum",               id=mod.Achievements.RedBum,             gfx=GFX_ROOT.."redbum.png",                         unlock="placeholder", desc="placeholder" },
    { group="elijah", name="rune bum",              id=mod.Achievements.RuneBum,            gfx=GFX_ROOT.."runebum.png",                        unlock="placeholder", desc="placeholder" },
    { group="elijah", name="fair bum",              id=mod.Achievements.FairBum,            gfx=GFX_ROOT.."fairbum.png",                        unlock="placeholder", desc="placeholder" },
    { group="elijah", name="tarot bum",             id=mod.Achievements.TarotBum,           gfx=GFX_ROOT.."tarotbum.png",                       unlock="placeholder", desc="placeholder" },
    { group="elijah", name="pill bum",              id=mod.Achievements.PillBum,            gfx=GFX_ROOT.."pillbum.png",                        unlock="placeholder", desc="placeholder" },
    { group="elijah", name="pastor bum",            id=mod.Achievements.PastorBum,          gfx=GFX_ROOT.."pastorbum.png",                      unlock="placeholder", desc="placeholder" },
    { group="elijah", name="junk yard seller",      id=mod.Achievements.JYS,                gfx=GFX_ROOT.."junkyardseller.png",                 unlock="placeholder", desc="placeholder" },
    { group="elijah", name="goldsmith beggar",      id=mod.Achievements.Goldsmith,          gfx=GFX_ROOT.."goldsmith.png",                      unlock="placeholder", desc="placeholder" },
    { group="elijah", name="familiars beggar",      id=mod.Achievements.FamiliarsBeggar,    gfx=GFX_ROOT.."familiarsbeggar.png",                unlock="placeholder", desc="placeholder" },
    { group="elijah", name="sacrifice table",       id=mod.Achievements.SacrificeTable,     gfx=GFX_ROOT.."achievement_sacrificetable.png",     unlock="placeholder", desc="placeholder" },
    { group="elijah", name="chaos beggar",          id=mod.Achievements.ChaosBeggar,        gfx=GFX_ROOT.."chaosbeggar.png",                    unlock="placeholder", desc="placeholder" },
    -- Items
    { group="items", name="kings heart",            id=mod.Achievements.KingsHeart,         gfx=GFX_ROOT.."achievement_kingsheart.png",         unlock="placeholder", desc="placeholder" },
    { group="items", name="sling shot",             id=mod.Achievements.SlingShot,          gfx=GFX_ROOT.."slingshot.png",                      unlock="placeholder", desc="placeholder" },
    { group="items", name="devils heart",           id=mod.Achievements.DevilsHeart,        gfx=GFX_ROOT.."devilsheart.png",                    unlock="placeholder", desc="placeholder" },
    { group="items", name="personal beggar",        id=mod.Achievements.PersonalBeggar,     gfx=GFX_ROOT.."achievement_personalbeggar.png",     unlock="placeholder", desc="placeholder" },
    { group="items", name="golden day",             id=mod.Achievements.GoldenDay,          gfx=GFX_ROOT.."achievement_goldenday.png",          unlock="placeholder", desc="placeholder" },
    { group="items", name="michelin star",          id=mod.Achievements.MichelinStar,       gfx=GFX_ROOT.."michelinstar.png",                   unlock="placeholder", desc="placeholder" },
    { group="items", name="ultra secret map",       id=mod.Achievements.UltraSecretMap,     gfx=GFX_ROOT.."ultrasecretmap.png",                 unlock="placeholder", desc="placeholder" },
    { group="items", name="creatine overdose",      id=mod.Achievements.CreatineOverdose,   gfx=GFX_ROOT.."creatingoverdose.png",               unlock="placeholder", desc="placeholder" },
    { group="items", name="ptsd",                   id=mod.Achievements.PTSD,               gfx=GFX_ROOT.."PTSD.png",                           unlock="placeholder", desc="placeholder" },
    { group="items", name="stab wound",             id=mod.Achievements.StabWound,          gfx=GFX_ROOT.."StabWound.png",                      unlock="placeholder", desc="placeholder" },
    { group="items", name="flowering skull",        id=mod.Achievements.FloweringSkull,     gfx=GFX_ROOT.."floweringskull.png",                 unlock="placeholder", desc="placeholder" },
    { group="items", name="echo",                   id=mod.Achievements.Echo,               gfx=GFX_ROOT.."echo.png",                           unlock="placeholder", desc="placeholder" },
    { group="items", name="gaga",                   id=mod.Achievements.Gaga,               gfx=GFX_ROOT.."gaga.png",                           unlock="placeholder", desc="placeholder" },
    { group="items", name="army of lovers",         id=mod.Achievements.ArmyOfLovers,       gfx=GFX_ROOT.."achievement_armyoflovers.png",       unlock="placeholder", desc="placeholder" },
    { group="items", name="the bad touch",          id=mod.Achievements.TheBadTouch,        gfx=GFX_ROOT.."achievement_thebadtouch.png",        unlock="placeholder", desc="placeholder" },
    { group="items", name="little lies",            id=mod.Achievements.LittleLies,         gfx=GFX_ROOT.."achievement_littlelies.png",         unlock="placeholder", desc="placeholder" },
    { group="items", name="paranoid android",       id=mod.Achievements.ParanoidAndroid,    gfx=GFX_ROOT.."achievement_paranoidandroid.png",    unlock="placeholder", desc="placeholder" },
    { group="items", name="sh-boom",                id=mod.Achievements.ShBoom,             gfx=GFX_ROOT.."achievement_shboom.png",             unlock="placeholder", desc="placeholder" },
    { group="items", name="universal",              id=mod.Achievements.Universal,          gfx=GFX_ROOT.."achievement_universal.png",          unlock="placeholder", desc="placeholder" },
    { group="items", name="everybodys changing",    id=mod.Achievements.EverybodysChanging, gfx=GFX_ROOT.."achievement_everybodyschanging.png", unlock="placeholder", desc="placeholder" },
    { group="items", name="u2",                     id=mod.Achievements.U2,                 gfx=GFX_ROOT.."achievement_u2.png",                 unlock="placeholder", desc="placeholder" },
    { group="items", name="killer queen",           id=mod.Achievements.KillerQueen,        gfx=GFX_ROOT.."achievement_killerqueen.png",        unlock="placeholder", desc="placeholder" },
    { group="items", name="ring of fire",           id=mod.Achievements.RingOfFire,         gfx=GFX_ROOT.."achievement_ringoffire.png",         unlock="placeholder", desc="placeholder" },
    { group="items", name="helter skelter",         id=mod.Achievements.HelterSkelter,      gfx=GFX_ROOT.."achievement_helterskelter.png",      unlock="placeholder", desc="placeholder" },
    { group="items", name="baby blue",              id=mod.Achievements.BabyBlue,           gfx=GFX_ROOT.."achievement_babyblue.png",           unlock="placeholder", desc="placeholder" },
    { group="items", name="wonder of you",          id=mod.Achievements.WonderOfYou,        gfx=GFX_ROOT.."achievement_wonderofyou.png",        unlock="placeholder", desc="placeholder" },
    { group="items", name="muse",                   id=mod.Achievements.Muse,               gfx=GFX_ROOT.."achievement_muse.png",               unlock="placeholder", desc="placeholder" },
    { group="items", name="fiend deal",            id=mod.Achievements.FiendDeal,          gfx=GFX_ROOT.."achievement_fienddeal.png",          unlock="placeholder", desc="placeholder" },

    -- Secrets
    { group="secrets", name="cheater",              id=mod.Achievements.Cheater,            gfx=GFX_ROOT.."cheater.png",                        unlock="???", desc="???" },
    { group="secrets", name="speedrunner",          id=mod.Achievements.Speedrun1,          gfx=GFX_ROOT.."speedrun1.png",                      unlock="???", desc="???" },
    { group="secrets", name="gym",                  id=mod.Achievements.GYM,                gfx=GFX_ROOT.."gym.png",                            unlock="???", desc="???" },
    { group="secrets", name="wimter",               id=mod.Achievements.Wimter,             gfx=GFX_ROOT.."wimter.png",                         unlock="???", desc="???" },
    { group="secrets", name="skill issue 1",        id=mod.Achievements.SkillIssue1,        gfx=GFX_ROOT.."skillissue1.png",                    unlock="???", desc="???" },
    { group="secrets", name="ghosted",              id=mod.Achievements.Ghosted,            gfx=GFX_ROOT.."ghosted.png",                        unlock="???", desc="???" },
}

-------------------------------------------------
-- Build grouped tables + preload sprites
-------------------------------------------------
local groupOrder  = { "characters", "david", "elijah", "items", "secrets" }
local groupLabels = { characters="characters", david="david", elijah="elijah", items="items", secrets="secrets" }
local groupData   = {}

for _, g in ipairs(groupOrder) do
    groupData[g] = { name=groupLabels[g], achievements={} }
end

local lockedSprite = Sprite()
lockedSprite:Load("gfx/ui/achievements/achievements.anm2", true)

for _, ach in ipairs(achievementData) do
    local spr = Sprite()
    spr:Load("gfx/ui/achievements/achievements.anm2", true)
    spr:ReplaceSpritesheet(0, ach.gfx)
    spr:LoadGraphics()
    spr:Play("Idle", true)

    table.insert(groupData[ach.group].achievements, {
        name   = ach.name,
        id     = ach.id,
        sprite = spr,
        unlock = ach.unlock,
        desc   = ach.desc,
    })
end

-------------------------------------------------
-- Carousel helpers
-------------------------------------------------
local NullColor = Color.Default
local function Lerp(a, b, t) return a + (b - a) * t end

local displayScale = {
    [0]=Vector(1,1), [1]=Vector(0.75,0.75), [2]=Vector(0.5,0.5),
    [3]=Vector(0,0), [4]=Vector(0,0)
}
local displayColor = {
    [0]=NullColor,
    [1]=Color(0.9,0.9,0.9,1,0,0,0),
    [2]=Color(0.8,0.8,0.8,1,0,0,0),
    [3]=Color(0.8,0.8,0.8,0,0,0,0),
    [4]=Color(0,0,0,0,0,0,0),
}
local displayY = { [0]=-50, [1]=-40, [2]=-30, [3]=-20, [4]=5000 }

local viewerState = {
    groupIndex    = 1,
    selectedIndex = 1,
    shiftFrame    = nil,
    shiftLength   = nil,
    shiftDir      = nil,
}

local menuFont = Font()
menuFont:Load("font/teammeatfont12.fnt")

local function centeredText(font, str, centerX, y, r, g, b)
    local w = font:GetStringWidth(str)
    font:DrawStringScaled(str, centerX - w * 0.5, y, 1, 1, KColor(r,g,b,1), 0, true)
end

-------------------------------------------------
-- Menu
-------------------------------------------------
local menu = {}

menu.main = {
    title   = "dies irae",
    tooltip = dssMod.menuOpenToolTip,
    buttons = {
        { str="resume game",  action="resume" },
        dssMod.changelogsButton,
        { str="achievements", dest="achievements" },
        { str="music",        dest="music" },
        {
            str       = "menu settings",
            dest      = "menuSettings",
            displayif = function()
                return not DeadSeaScrollsMenu.CanOpenGlobalMenu()
            end,
        },
    },
}

menu.menuSettings = {
    title   = "menu settings",
    buttons = {
        dssMod.gamepadToggleButton,
        dssMod.menuKeybindButton,
        dssMod.paletteButton,
        dssMod.menuHintButton,
        dssMod.menuBuzzerButton,
    },
}

menu.music = {
    title   = "music",
    buttons = {
        {
            str      = "drowning in sorrow",
            choices  = { "off", "on" },
            setting  = 1,
            variable = "DiesIrae_FloodedCavesOST",
            generate = function(button)
                button.setting = GetSetting("FloodedCavesOST", 1)
            end,
            changefunc = function(button)
                SetSetting("FloodedCavesOST", button.setting)
            end,
        },
    },
}

menu.achievements = {
    title   = "achievements",
    tooltip = { strset={ "left/right: browse", "up/down: switch group" } },
    buttons = {
        { str=" ", nosel=true },
    },

    generate = function(item, tbl)
        viewerState.groupIndex    = 1
        viewerState.selectedIndex = 1
        viewerState.shiftFrame    = nil
        item.buttons = {
            { str=" ", nosel=true },
        }
    end,

    Panels = {
        {
            Panel = {
                RenderBack = function(panel, panelPos, tbl)
                    local group   = groupData[groupOrder[viewerState.groupIndex]]
                    local achList = group.achievements
                    local numAch  = #achList
                    if numAch == 0 then return end

                    -- Carousel
                    local displayed = {}
                    for i = -3, 3 do
                        local indexOffset = 0
                        local shiftPct

                        if viewerState.shiftFrame and viewerState.shiftLength then
                            shiftPct    = viewerState.shiftFrame / viewerState.shiftLength
                            indexOffset = (1 - shiftPct) * viewerState.shiftDir
                        end

                        local listIndex = i + 4
                        local pct       = (listIndex + indexOffset - 1) / 6
                        local xPos      = Lerp(-260, 260, pct)
                        local absI      = math.abs(i)

                        local scale = displayScale[absI] or Vector(0,0)
                        local color = displayColor[absI] or Color(0,0,0,0)
                        local yPos  = displayY[absI] or 5000

                        if shiftPct then
                            local absS = math.min(4, math.abs(i + viewerState.shiftDir))
                            local sc2  = displayScale[absS] or Vector(0,0)
                            local co2  = displayColor[absS] or Color(0,0,0,0)
                            local y2   = displayY[absS] or 5000
                            scale = Vector(Lerp(sc2.X, scale.X, shiftPct), Lerp(sc2.Y, scale.Y, shiftPct))
                            color = Color.Lerp(co2, color, shiftPct)
                            yPos  = Lerp(y2, yPos, shiftPct)
                        end

                        local idx = (((viewerState.selectedIndex + i) - 1) % numAch) + 1
                        table.insert(displayed, {
                            data  = achList[idx],
                            pos   = Vector(xPos, yPos),
                            scale = scale,
                            color = color,
                        })
                    end

                    table.sort(displayed, function(a, b) return a.pos.Y > b.pos.Y end)

                    local persistData = Isaac.GetPersistentGameData()
                    for _, d in ipairs(displayed) do
                        local unlocked = persistData:IsAchievementUnlocked(d.data.id)
                        local spr      = unlocked and d.data.sprite or lockedSprite
                        spr:SetFrame("Idle", 0)
                        spr.Scale = d.scale
                        spr.Color = d.color
                        spr:Render(panelPos + d.pos + Vector(0, 20), Vector.Zero, Vector.Zero)
                    end

                    -- Advance shift animation
                    if viewerState.shiftFrame then
                        viewerState.shiftFrame = viewerState.shiftFrame + 1
                        if viewerState.shiftFrame > viewerState.shiftLength then
                            viewerState.shiftFrame  = nil
                            viewerState.shiftLength = nil
                            viewerState.shiftDir    = nil
                        end
                    end

                    -- Info text
                    local sel      = achList[viewerState.selectedIndex]
                    local unlocked = persistData:IsAchievementUnlocked(sel.id)
                    local cx       = panelPos.X
                    local cy       = panelPos.Y

                    centeredText(menuFont, "[ "..group.name.." ]",           cx, cy+60, 1,   1,   1  )
                    centeredText(menuFont, unlocked and sel.name or string.rep("?",#sel.name), cx, cy+75, 1, 1, 1)
                    centeredText(menuFont, unlocked and sel.unlock or "???",  cx, cy+88, 0.8, 0.8, 0.8)
                    centeredText(menuFont, unlocked and sel.desc   or "???",  cx, cy+101,0.7, 0.7, 0.7)
                end,

                HandleInputs = function(panel, input, item, itemswitched, tbl)
                    if itemswitched then return end
                    local raw = input.raw
                    local men = input.menu

                    if raw.left > 0 or raw.right > 0 then
                        local numAch = #groupData[groupOrder[viewerState.groupIndex]].achievements
                        if not viewerState.shiftFrame then
                            local usingInput = raw.right > 0 and raw.right or raw.left
                            local setChange  = raw.right > 0 and 1 or -1
                            local shiftLen   = usingInput >= 88 and 7 or 10

                            if usingInput == 1 or (usingInput >= 18 and usingInput % (shiftLen + 1) == 0) then
                                viewerState.shiftLength   = shiftLen
                                viewerState.shiftFrame    = 0
                                viewerState.shiftDir      = setChange
                                viewerState.selectedIndex = ((viewerState.selectedIndex + setChange - 1) % numAch) + 1
                                dssMod.playSound(dssMod.menusounds.Pop3)
                            end
                        end

                    elseif men.up or men.down then
                        local change = men.down and 1 or -1
                        viewerState.groupIndex    = ((viewerState.groupIndex + change - 1) % #groupOrder) + 1
                        viewerState.selectedIndex = 1
                        viewerState.shiftFrame    = nil
                        dssMod.playSound(dssMod.menusounds.Pop2)
                    end
                end,
            },
            Offset = Vector.Zero,
            Color  = NullColor,
        },
    },
}

-------------------------------------------------
-- Register
-------------------------------------------------
local directoryKey = {
    Item            = menu.main,
    Main            = "main",
    Idle            = false,
    MaskAlpha       = 1,
    Settings        = {},
    SettingsChanged = false,
    Path            = {},
}

DeadSeaScrollsMenu.AddMenu("Dies Irae", {
    Run          = dssMod.runMenu,
    Open         = dssMod.openMenu,
    Close        = dssMod.closeMenu,
    UseSubMenu   = false,
    Directory    = menu,
    DirectoryKey = directoryKey,
})

-------------------------------------------------
-- OST
-------------------------------------------------
mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, function(_, musicID, isFade)
    if musicID ~= Music.MUSIC_FLOODED_CAVES then return end
    if GetSetting("FloodedCavesOST", 1) ~= 2 then return end
    return mod.Music.DrowningInSorrow
end)