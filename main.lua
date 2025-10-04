DiesIraeMod = RegisterMod("Dies Irae", 1)
GameRef = Game()
SfxManager = SFXManager()
local json = require("json")
local enums = require("scripts.core.enums")
local json = require("json")
local enums = require("scripts.core.enums")
---------------------------------------------------
--  Charecters
----------------------------------------------------
local David = include("scripts.characters.david")
David:Init(DiesIraeMod)
---------------------------------------------------
--  Active items
----------------------------------------------------
local ArmyOfLovers = include("scripts.items.active.army_of_lovers")
ArmyOfLovers:Init(DiesIraeMod) --WORKING (Need to add: wisps, maybe custome for the minisaacs)
local Guppys_soul =  include("scripts.items.active.guppys_soul")
Guppys_soul:Init(DiesIraeMod) --WORKING (Need to add: wisps)
local Shboom = include("scripts.items.active.shboom")
Shboom:Init(DiesIraeMod) --WORKING (Need to add: wisps)
local HelterSkelter = include("scripts.items.active.helter_skelter")
HelterSkelter:Init(DiesIraeMod) --WORKING (Need to add: wisps)
local HypaHypa = include("scripts.items.active.hypa_hypa")
HypaHypa:Init(DiesIraeMod) --WORKING (Need to add: wisps)
local HolyWood = include("scripts.items.active.holy_wood")
HolyWood:Init(DiesIraeMod) --WORKING (Need to add: wisps)
local DiaryOfAMadman = include("scripts.items.active.diary_of_a_madman")
DiaryOfAMadman:Init(DiesIraeMod) --WORKING (Need to add: wisps)
local ComaWhite = include("scripts.items.active.coma_white")
ComaWhite:Init(DiesIraeMod) --WORKING (Need to add: wisps)
local GoodVibes = include("scripts.items.active.good_vibes")
GoodVibes:Init(DiesIraeMod) --WORKING (Need to add: wisps)
local MomsDiary = include("scripts.items.active.moms_diary")
MomsDiary:Init(DiesIraeMod) --WORKING
local Devilsheart = include("scripts.items.active.devils_heart")
Devilsheart:Init(DiesIraeMod) --WORKING
local AnotherMedium = include("scripts.items.active.another_medium")
AnotherMedium:Init(DiesIraeMod) --WORKING
local LittleLies = include("scripts.items.active.little_lies")
LittleLies:Init(DiesIraeMod) --WORKING
local SatansRemoteShop = include("scripts.items.active.satans_remote_shop")
SatansRemoteShop:Init(DiesIraeMod)
local D8055 = include("scripts.items.active.D8055")
D8055:Init(DiesIraeMod)
local BigShot = include("scripts.items.active.big_shot")
BigShot:Init(DiesIraeMod)
---------------------------------------------------
--  Passive items
----------------------------------------------------
local U2 = include("scripts.items.passive.u2")
U2:Init(DiesIraeMod) --WORKING
local Echo = include("scripts.items.passive.Echo")
Echo:Init(DiesIraeMod) --WORKING
local BadTouch = include("scripts.items.passive.thebadtouch")
BadTouch:Init(DiesIraeMod) --WORKING
local Engel = include("scripts.items.passive.engel")
Engel:Init(DiesIraeMod) --WORKING
local Muse = include("scripts.items.passive.muse")
Muse:Init(DiesIraeMod) --WORKING
--local KillerQueen = include("scripts.items.passive.killerqueen")
--KillerQueen:Init(mod)
local ScaredShoes = include("scripts.items.passive.scaredshoes")
ScaredShoes:Init(DiesIraeMod) --WORKING
local DevilsLuck = include("scripts.items.passive.devilsluck")
DevilsLuck:Init(DiesIraeMod) --WORKING
local HereToStay = include("scripts.items.passive.heretostay")
HereToStay:Init(DiesIraeMod) --WORKING
local RingOfFire = include("scripts.items.passive.ringoffire")
RingOfFire:Init(DiesIraeMod) --WORKING
local ProteinPowder = include("scripts.items.passive.proteinpowder")
ProteinPowder:Init(DiesIraeMod) --WORKING
local StabWound = include("scripts.items.passive.stabwound")
StabWound:Init(DiesIraeMod) --WORKING
local Hysteria = include("scripts.items.passive.hysteria")
Hysteria:Init(DiesIraeMod) -- WORKING
local ThoughtContagion = include("scripts.items.passive.thoughtcontagion")
ThoughtContagion:Init(DiesIraeMod) --WORKING
local EnjoymentUnlucky = include("scripts.items.passive.enjoymentunlucky")
EnjoymentUnlucky:Init(DiesIraeMod) --WORKING
local Mutter = include("scripts.items.passive.mutter")
Mutter:Init(DiesIraeMod) --WORKING
local MomsDress = include("scripts.items.passive.momsdress")
MomsDress:Init(DiesIraeMod) --WORKING
local GoldenDay = include("scripts.items.passive.goldenday")
GoldenDay:Init(DiesIraeMod) --WORKING
local MonstersUnderTheBed = include("scripts.items.passive.monstersbed")
MonstersUnderTheBed:Init(DiesIraeMod) --WORKING
local UltraSecretMap = include("scripts.items.passive.ultrasecretmap")
UltraSecretMap:Init(DiesIraeMod) --WORKING
local LastResort = include("scripts.items.passive.lastresort")
LastResort:Init(DiesIraeMod) --WORKING
local Universal = include("scripts.items.passive.universal")
Universal:Init(DiesIraeMod) --WORKING
local SlaughterToPrevail = include("scripts.items.passive.slaughtertoprevail")
SlaughterToPrevail:Init(DiesIraeMod)
local EyeSacrifice = include("scripts.items.passive.eyesacrifice")
EyeSacrifice:Init(DiesIraeMod)
local CreatineOverdose = include("scripts.items.passive.creatineoverdose")
CreatineOverdose:Init(DiesIraeMod) --WORKING
local SolarFlare = include("scripts.items.passive.solarflare")
SolarFlare:Init(DiesIraeMod) --WORKING
local FragileEgo = include("scripts.items.passive.fragileego")
FragileEgo:Init(DiesIraeMod) --WORKING
local EverybodysChanging = include("scripts.items.passive.everybodychanging") 
EverybodysChanging:Init(DiesIraeMod) --WORKING
local BigShot = include("scripts.items.passive.bigshot") 
BigShot:Init(DiesIraeMod)
local BeggarsTear = include("scripts.items.passive.beggarstear") 
BeggarsTear:Init(DiesIraeMod)
--local TouristMap = include("scripts.items.passive.touristmap") 
--TouristMap:Init(mod)

---------------------------------------------------
--  Familiars
----------------------------------------------------
local ParanoidAndroid = include("scripts.items.familiars.paranoidandroid") 
ParanoidAndroid:Init(DiesIraeMod)
---------------------------------------------------
--  Pocket items
----------------------------------------------------
local CustomPills = include("scripts.items.pocketitems.custompills")
CustomPills:Init(DiesIraeMod)  --WORKING
---------------------------------------------------
--  Trinkets
----------------------------------------------------
local WonderOfYou = include("scripts.items.trinkets.wonderofyou")
WonderOfYou:Init(DiesIraeMod)
local Gaga = include("scripts.items.trinkets.gaga")
Gaga:Init(DiesIraeMod)
--local BrokenDream = include("scripts.items.trinkets.inabrokendream")
--BrokenDream:Init(mod)
local FixedMetabolism = include("scripts.items.trinkets.fixedmetabolism")
FixedMetabolism:Init(DiesIraeMod)
local BabyBlue = include("scripts.items.trinkets.babyblue")
BabyBlue:Init(DiesIraeMod) --WORKING
--local clearvase = include("scripts.items.trinkets.clearvase")
--clearvase:Init(mod)
--local RottenFood= include("scripts.items.trinkets.rottenfood")
--RottenFood:Init(mod)
--local CatchTheRainbow = include("scripts.items.trinkets.catch_the_rainbow")
--CatchTheRainbow:Init(mod)
--local BrokenDream = include("scripts.items.trinkets.inabrokendream")
--BrokenDream:Init(mod)
--local clearvase = include("scripts.items.trinkets.clearvase")
--clearvase:Init(mod)


---------------------------------------------------
--  PIck-ups
----------------------------------------------------
--include("scripts.items.pickup.burningheart")
--local LittlePieceOfHeaven = include("scripts.items.pickup.alpoh")
--LittlePieceOfHeaven:Init(mod)

---------------------------------------------------
--  Curses
----------------------------------------------------
--local CurseSacrifice = include("scripts.curses.sacrifice")
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
--    CurseSacrifice:Init(mod)
--end)

---------------------------------------------------
--  Core mechanics
---------------------------------------------------
local MusicTears = include("scripts.core.music_tears")
MusicTears:Init(DiesIraeMod)

---------------------------------------------------
--  Transformations
----------------------------------------------------
local DadPlaylist = include("scripts.core.transformations.dadsoldplaylist")
DadPlaylist:Init(DiesIraeMod)

---------------------------------------------------
--  Somethings that comes with the mod
----------------------------------------------------
local RemoveCurseOnVoid = include("scripts.core.voidlost")
RemoveCurseOnVoid:Init(DiesIraeMod)

return DiesIraeMod
