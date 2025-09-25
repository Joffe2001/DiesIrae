DiesIraeMod = RegisterMod("Dies Irae", 1)
GameRef = Game()
SfxManager = SFXManager()

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
---------------------------------------------------
--  Passive items
----------------------------------------------------
local U2 = include("scripts.items.passive.u2")
U2:Init(DiesIraeMod) --WORKING
local Echo = include("scripts.items.passive.Echo")
Echo:Init(DiesIraeMod) --WORKING
local BadTouch = include("scripts.items.passive.the_bad_touch")
BadTouch:Init(DiesIraeMod) --WORKING
local Engel = include("scripts.items.passive.engel")
Engel:Init(DiesIraeMod) --WORKING
local Muse = include("scripts.items.passive.muse")
Muse:Init(DiesIraeMod) --WORKING
--local KillerQueen = include("scripts.items.passive.killerqueen")
--KillerQueen:Init(mod)
local ScaredShoes = include("scripts.items.passive.scared_shoes")
ScaredShoes:Init(DiesIraeMod) --WORKING
local DevilsLuck = include("scripts.items.passive.devils_luck")
DevilsLuck:Init(DiesIraeMod) --WORKING
local HereToStay = include("scripts.items.passive.here_to_stay")
HereToStay:Init(DiesIraeMod) --WORKING
local RingOfFire = include("scripts.items.passive.ring_of_fire")
RingOfFire:Init(DiesIraeMod) --WORKING
local ProteinPowder = include("scripts.items.passive.protein_powder")
ProteinPowder:Init(DiesIraeMod) --WORKING
local StabWound = include("scripts.items.passive.stab_wound")
StabWound:Init(DiesIraeMod) --WORKING
local Hysteria = include("scripts.items.passive.hysteria")
Hysteria:Init(DiesIraeMod) -- WORKING
local ThoughtContagion = include("scripts.items.passive.thought_contagion")
ThoughtContagion:Init(DiesIraeMod) --WORKING
local EnjoymentUnlucky = include("scripts.items.passive.enjoyment_of_the_unlucky")
EnjoymentUnlucky:Init(DiesIraeMod) --WORKING
local Mutter = include("scripts.items.passive.mutter")
Mutter:Init(DiesIraeMod) --WORKING
local MomsDress = include("scripts.items.passive.moms_dress")
MomsDress:Init(DiesIraeMod) --WORKING
local GoldenDay = include("scripts.items.passive.golden_day")
GoldenDay:Init(DiesIraeMod) --WORKING
local MonstersUnderTheBed = include("scripts.items.passive.monsters_under_the_bed")
MonstersUnderTheBed:Init(DiesIraeMod) --WORKING
local UltraSecretMap = include("scripts.items.passive.ultra_secret_map")
UltraSecretMap:Init(DiesIraeMod) --WORKING
local LastResort = include("scripts.items.passive.last_resort")
LastResort:Init(DiesIraeMod) --WORKING
local Universal = include("scripts.items.passive.universal")
Universal:Init(DiesIraeMod) --WORKING
local SlaughterToPrevail = include("scripts.items.passive.slaughter_to_prevail")
SlaughterToPrevail:Init(DiesIraeMod)
local EyeSacrifice = include("scripts.items.passive.eye sacrifice")
EyeSacrifice:Init(DiesIraeMod)
local CreatineOverdose = include("scripts.items.passive.creatine_overdose")
CreatineOverdose:Init(DiesIraeMod) --WORKING
local SolarFlare = include("scripts.items.passive.solar_flare")
SolarFlare:Init(DiesIraeMod) --WORKING
local FragileEgo = include("scripts.items.passive.fragile_ego")
FragileEgo:Init(DiesIraeMod) --WORKING
local EverybodysChanging = include("scripts.items.passive.everybodys_changing") 
EverybodysChanging:Init(DiesIraeMod) --WORKING
local BigShot = include("scripts.items.passive.big_shot") 
BigShot:Init(DiesIraeMod)
local BeggarsTear = include("scripts.items.passive.beggars_tear") 
BeggarsTear:Init(DiesIraeMod)
--local TouristMap = include("scripts.items.passive.touristmap") 
--TouristMap:Init(mod)

---------------------------------------------------
--  Familiars
----------------------------------------------------
local ParanoidAndroid = include("scripts.items.familiars.paranoid_android") 
ParanoidAndroid:Init(DiesIraeMod)
---------------------------------------------------
--  Pocket items
----------------------------------------------------
local CustomPills = include("scripts.items.pocketitems.custom_pills")
CustomPills:Init(DiesIraeMod)  --WORKING
---------------------------------------------------
--  Trinkets
----------------------------------------------------
local WonderOfYou = include("scripts.items.trinkets.wonder_of_you")
WonderOfYou:Init(DiesIraeMod)
local Gaga = include("scripts.items.trinkets.gaga")
Gaga:Init(DiesIraeMod)
--local BrokenDream = include("scripts.items.trinkets.inabrokendream")
--BrokenDream:Init(mod)
local FixedMetabolism = include("scripts.items.trinkets.fixed_metabolism")
FixedMetabolism:Init(DiesIraeMod)
local BabyBlue = include("scripts.items.trinkets.baby_blue")
BabyBlue:Init(DiesIraeMod) --WORKING
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
MusicTears:Init(DiesIraeMod)

---------------------------------------------------
--  Transformations
----------------------------------------------------
local DadPlaylist = include("scripts.core.transformations.dads_old_playlist")
DadPlaylist:Init(DiesIraeMod)

---------------------------------------------------
--  Somethings that comes with the mod
----------------------------------------------------
local RemoveCurseOnVoid = include("scripts.core.remove_lost_curse_on_void")
RemoveCurseOnVoid:Init(DiesIraeMod)

return DiesIraeMod
