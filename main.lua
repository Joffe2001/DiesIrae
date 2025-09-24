local mod = RegisterMod("Dies Irae", 1)
local json = require("json")
local game = Game()
local rng = RNG()
---------------------------------------------------
--  Charecters
----------------------------------------------------
local David = include("scripts.characters.david")
David:Init(mod)
---------------------------------------------------
--  Active items
----------------------------------------------------
local ArmyOfLovers = include("scripts.items.active.armyoflovers")
ArmyOfLovers:Init(mod) --WORKING (Need to add: wisps, maybe custome for the minisaacs)
local Guppys_soul =  include("scripts.items.active.guppysoul")
Guppys_soul:Init(mod) --WORKING (Need to add: wisps)
local Shboom = include("scripts.items.active.shboom")
Shboom:Init(mod) --WORKING (Need to add: wisps)
local HelterSkelter = include("scripts.items.active.helterskelter")
HelterSkelter:Init(mod) --WORKING (Need to add: wisps)
local HypaHypa = include("scripts.items.active.hypahypa")
HypaHypa:Init(mod) --WORKING (Need to add: wisps)
local HolyWood = include("scripts.items.active.HolyWood")
HolyWood:Init(mod) --WORKING (Need to add: wisps)
local Diary_madman = include("scripts.items.active.diaryofamadman")
Diary_madman:Init(mod) --WORKING (Need to add: wisps)
local ComaWhite = include("scripts.items.active.comawhite")
ComaWhite:Init(mod) --WORKING (Need to add: wisps)
local GoodVibes = include("scripts.items.active.GoodVibes")
GoodVibes:Init(mod) --WORKING (Need to add: wisps)
local MomsDiary = include("scripts.items.active.momsdiary")
MomsDiary:Init(mod) --WORKING
local Devilsheart = include("scripts.items.active.devilsheart")
Devilsheart:Init(mod) --WORKING
local AnotherMedium = include("scripts.items.active.anothermedium")
AnotherMedium:Init(mod) --WORKING
local LittleLies = include("scripts.items.active.littlelies")
LittleLies:Init(mod) --WORKING
local SatansRemoteShop = include("scripts.items.active.satansremoteshop")
SatansRemoteShop:Init(mod)
---------------------------------------------------
--  Passive items
----------------------------------------------------
local U2 = include("scripts.items.passive.u2")
U2:Init(mod) --WORKING
local Echo = include("scripts.items.passive.Echo")
Echo:Init(mod) --WORKING
local BadTouch = include("scripts.items.passive.thebadtouch")
BadTouch:Init(mod) --WORKING
local Engel = include("scripts.items.passive.engel")
Engel:Init(mod) --WORKING
local Muse = include("scripts.items.passive.muse")
Muse:Init(mod) --WORKING
--local KillerQueen = include("scripts.items.passive.killerqueen")
--KillerQueen:Init(mod)
local ScaredShoes = include("scripts.items.passive.scaredshoes")
ScaredShoes:Init(mod) --WORKING
local DevilsLuck = include("scripts.items.passive.devilsluck")
DevilsLuck:Init(mod) --WORKING
local HereToStay = include("scripts.items.passive.heretostay")
HereToStay:Init(mod) --WORKING
local RingOfFire = include("scripts.items.passive.ringoffire")
RingOfFire:Init(mod) --WORKING
local ProteinPowder = include("scripts.items.passive.proteinpowder")
ProteinPowder:Init(mod) --WORKING
local StabWound = include("scripts.items.passive.stabwound")
StabWound:Init(mod) --WORKING
local Hysteria = include("scripts.items.passive.hysteria")
Hysteria:Init(mod) -- WORKING
local ThoughtContagion = include("scripts.items.passive.thoughtcontagion")
ThoughtContagion:Init(mod) --WORKING
local EnjoymentUnlucky = include("scripts.items.passive.enjoymentunlucky")
EnjoymentUnlucky:Init(mod) --WORKING
local Mutter = include("scripts.items.passive.mutter")
Mutter:Init(mod) --WORKING
local MomsDress = include("scripts.items.passive.momsdress")
MomsDress:Init(mod) --WORKING
local GoldenDay = include("scripts.items.passive.goldenday")
GoldenDay:Init(mod) --WORKING
local MonstersUnderTheBed = include("scripts.items.passive.monstersbed")
MonstersUnderTheBed:Init(mod) --WORKING
local UltraSecretMap = include("scripts.items.passive.ultrasecretmap")
UltraSecretMap:Init(mod) --WORKING
local LastResort = include("scripts.items.passive.lastresort")
LastResort:Init(mod) --WORKING
local Universal = include("scripts.items.passive.universal")
Universal:Init(mod) --WORKING
local SlaughterToPrevail = include("scripts.items.passive.slaughtertoprevail")
SlaughterToPrevail:Init(mod)
local EyeSacrifice = include("scripts.items.passive.eyesacrifice")
EyeSacrifice:Init(mod)
local CreatineOverdose = include("scripts.items.passive.creatineoverdose")
CreatineOverdose:Init(mod) --WORKING
local SolarFlare = include("scripts.items.passive.solarflare")
SolarFlare:Init(mod) --WORKING
local FragileEgo = include("scripts.items.passive.fragileego")
FragileEgo:Init(mod) --WORKING
local EverybodysChanging = include("scripts.items.passive.everybodychanging") 
EverybodysChanging:Init(mod) --WORKING
local BigShot = include("scripts.items.passive.bigshot") 
BigShot:Init(mod)
local BeggarsTear = include("scripts.items.passive.beggarstear") 
BeggarsTear:Init(mod)
--local TouristMap = include("scripts.items.passive.touristmap") 
--TouristMap:Init(mod)

---------------------------------------------------
--  Familiars
----------------------------------------------------
local ParanoidAndroid = include("scripts.items.familiars.paranoidandroid") 
ParanoidAndroid:Init(mod)
---------------------------------------------------
--  Pocket items
----------------------------------------------------
local CustomPills = include("scripts.items.pocketitems.custompills")
CustomPills:Init(mod)  --WORKING
---------------------------------------------------
--  Trinkets
----------------------------------------------------
local WonderOfYou = include("scripts.items.trinkets.wonderofyou")
WonderOfYou:Init(mod)
local Gaga = include("scripts.items.trinkets.gaga")
Gaga:Init(mod)
--local BrokenDream = include("scripts.items.trinkets.inabrokendream")
--BrokenDream:Init(mod)
local FixedMetabolism = include("scripts.items.trinkets.fixedmetabolism")
FixedMetabolism:Init(mod)
local BabyBlue = include("scripts.items.trinkets.babyblue")
BabyBlue:Init(mod) --WORKING
--local clearvase = include("scripts.items.trinkets.clearvase")
--clearvase:Init(mod)
--local RottenFood= include("scripts.items.trinkets.rottenfood")
--RottenFood:Init(mod)
--local CatchTheRainbow = include("scripts.items.trinkets.catch_the_rainbow")
--CatchTheRainbow:Init(mod)


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
MusicTears:Init(mod)

---------------------------------------------------
--  Transformations
----------------------------------------------------
local DadPlaylist = include("scripts.core.transformations.dadsoldplaylist")
DadPlaylist:Init(mod)

---------------------------------------------------
--  Somethings that comes with the mod
----------------------------------------------------
local RemoveCurseOnVoid = include("scripts.core.voidlost")
RemoveCurseOnVoid:Init(mod)

return mod
