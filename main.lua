DiesIraeMod = RegisterMod("Dies Irae", 1)
local mod = DiesIraeMod

mod.JSON = require("json")

include("scripts.core.enums")
include("scripts.core.utils")
include("scripts.core.unlocks")

if EID then
	include("scripts.modcompat.eidescs")
	include("scripts.modcompat.eid")
end
---------------------------------------------------
--  Characters
----------------------------------------------------
include("scripts.characters.david") --WORKING
include("scripts.characters.tdavid")
--include("scripts.characters.bat_kol")
---------------------------------------------------
--  Active items
----------------------------------------------------
include("scripts.items.active.big_shot") --WORKING (Need to add: wisps, sprites)
include("scripts.items.active.army_of_lovers") --WORKING (Need to add: wisps, maybe custome for the minisaacs)
include("scripts.items.active.guppys_soul")--WORKING (Need to add: wisps)
include("scripts.items.active.shboom")--WORKING (Need to add: wisps)
include("scripts.items.active.helter_skelter") --WORKING (Need to add: wisps)
include("scripts.items.active.hypa_hypa") --WORKING (Need to add: wisps)
include("scripts.items.active.holy_wood")--WORKING (Need to add: wisps)
include("scripts.items.active.diary_of_a_madman")--WORKING (Need to add: wisps)
include("scripts.items.active.coma_white")--WORKING (Need to add: wisps)
include("scripts.items.active.good_vibes")--WORKING (Need to add: wisps)
include("scripts.items.active.moms_diary")--WORKING
include("scripts.items.active.devils_heart")--WORKING
include("scripts.items.active.another_medium")--WORKING
include("scripts.items.active.little_lies")--WORKING
include("scripts.items.active.kingsheart")--WORKING
include("scripts.items.active.breakstuff")
---------------------------------------------------
--  Passive items
----------------------------------------------------
include("scripts.items.passive.u2")--WORKING
include("scripts.items.passive.Echo")--WORKING
include("scripts.items.passive.thebadtouch")--WORKING
include("scripts.items.passive.engel")--WORKING
include("scripts.items.passive.muse")--WORKING
include("scripts.items.passive.scaredshoes")--WORKING
include("scripts.items.passive.devilsluck")--WORKING
include("scripts.items.passive.heretostay")--WORKING
include("scripts.items.passive.ringoffire")--WORKING
include("scripts.items.passive.proteinpowder")--WORKING
include("scripts.items.passive.stabwound")--WORKING
include("scripts.items.passive.hysteria")-- WORKING
include("scripts.items.passive.thoughtcontagion")--WORKING
include("scripts.items.passive.enjoymentunlucky")--WORKING
include("scripts.items.passive.mutter")--WORKING
include("scripts.items.passive.momsdress")--WORKING
include("scripts.items.passive.goldenday")--WORKING
include("scripts.items.passive.psychosocial")--WORKING
include("scripts.items.passive.ultrasecretmap")--WORKING
include("scripts.items.passive.lastresort")--WORKING
include("scripts.items.passive.universal")--WORKING
include("scripts.items.passive.creatineoverdose")--WORKING
include("scripts.items.passive.solarflare")--WORKING
include("scripts.items.passive.fragileego")--WORKING
include("scripts.items.passive.everybodychanging")--WORKING
include("scripts.items.passive.beggarstear") --WORKING
include("scripts.items.passive.rainbow_korn") --WORKING
include("scripts.items.passive.big_kahuna_burger") --WORKING
include("scripts.items.passive.dads_empty_wallet")--WORKING
include("scripts.items.passive.buriedtreasuremap") 
include("scripts.items.passive.eyesacrifice")
include("scripts.items.passive.fiend_deal")
--include("scripts.items.passive.touristmap") 

---------------------------------------------------
--  Familiars
----------------------------------------------------
include("scripts.items.familiars.paranoidandroid")--WORKING
include("scripts.items.familiars.killerqueen")
---------------------------------------------------
--  Pocket items
----------------------------------------------------
include("scripts.items.pocketitems.custompills")--WORKING
---------------------------------------------------
--  Trinkets
----------------------------------------------------
include("scripts.items.trinkets.wonderofyou") --WORKING
include("scripts.items.trinkets.gaga") --WORKING
include("scripts.items.trinkets.babyblue")--WORKING
include("scripts.items.trinkets.second_breakfest")--WORKING
include("scripts.items.trinkets.fixedmetabolism")
include("scripts.items.trinkets.rottenfood")--WORKING
---------------------------------------------------
--  PIck-ups
----------------------------------------------------
include("scripts.items.pickup.locacaca") --WORKING
include("scripts.items.pickup.alpoh") --WORKING
include("scripts.items.pickup.starshard") --WORKING
---------------------------------------------------
--  Curses
----------------------------------------------------
include("scripts.curses.curse_eval")
include("scripts.curses.unloved")
---------------------------------------------------
--  Effects
----------------------------------------------------
include("scripts.effects.resonance")--WORKING
----------------------------------------------------
--  Challenges
----------------------------------------------------
include("scripts.Challenges.sound_of_silence")
---------------------------------------------------
--  Transformations
----------------------------------------------------
include("scripts.transformations.isaacsinfulmusic")--WORKING
include("scripts.transformations.dadsoldplaylist") --WORKING
---------------------------------------------------
--  NPCs
---------------------------------------------------
include("scripts.npcs.fiend_beggar")
---------------------------------------------------
--  Somethings that comes with the mod
---------------------------------------------------
include("scripts.core.voidlost") --Working