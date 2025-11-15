---@class ModReference
DiesIraeMod = RegisterMod("Dies Irae", 1)

local saveManager = include("path.to.save.manager")

DiesIraeMod.JSON = require("json")

include("scripts.core.enums")
include("scripts.core.pools")
include("scripts.core.utils")
include("scripts.core.unlocks")

if EID then
	include("scripts.modcompat.eidescs")
	include("scripts.modcompat.eid")
end
---------------------------------------------------
--  Dependencies
---------------------------------------------------
--include("scripts.dependencies.hud_helper")
---------------------------------------------------
--  Characters
---------------------------------------------------
include("scripts.characters.david") --WORKING
include("scripts.characters.tdavid")
include("scripts.characters.elijah")
--include("scripts.characters.bat_kol")
---------------------------------------------------
--  Active items
----------------------------------------------------
include("scripts.items.active.big_shot") 
include("scripts.items.active.army_of_lovers") 
include("scripts.items.active.guppys_soul")
include("scripts.items.active.shboom")
include("scripts.items.active.helter_skelter") 
include("scripts.items.active.hypa_hypa") 
include("scripts.items.active.holy_wood")
include("scripts.items.active.diary_of_a_madman")
include("scripts.items.active.coma_white")
include("scripts.items.active.good_vibes")
include("scripts.items.active.moms_diary")
include("scripts.items.active.devils_heart")
include("scripts.items.active.another_medium")
include("scripts.items.active.little_lies")
include("scripts.items.active.kingsheart")
include("scripts.items.active.personalbeggar") 
include("scripts.items.active.breakstuff") 
---------------------------------------------------
--  Passive items
----------------------------------------------------
include("scripts.items.passive.u2")
include("scripts.items.passive.Echo")
include("scripts.items.passive.thebadtouch")
include("scripts.items.passive.engel")
include("scripts.items.passive.muse")
include("scripts.items.passive.scaredshoes")
include("scripts.items.passive.devilsluck")
include("scripts.items.passive.heretostay")
include("scripts.items.passive.ringoffire")
include("scripts.items.passive.proteinpowder")
include("scripts.items.passive.stabwound")
include("scripts.items.passive.hysteria")
include("scripts.items.passive.thoughtcontagion")
include("scripts.items.passive.enjoymentunlucky")
include("scripts.items.passive.mutter")
include("scripts.items.passive.momsdress")
include("scripts.items.passive.goldenday")
include("scripts.items.passive.psychosocial")
include("scripts.items.passive.ultrasecretmap")
include("scripts.items.passive.lastresort")
include("scripts.items.passive.universal")
include("scripts.items.passive.creatineoverdose")
include("scripts.items.passive.solarflare")
include("scripts.items.passive.fragileego")
include("scripts.items.passive.everybodychanging")
include("scripts.items.passive.beggarstear") 
include("scripts.items.passive.rainbow_korn") 
include("scripts.items.passive.big_kahuna_burger") 
include("scripts.items.passive.dads_empty_wallet")
include("scripts.items.passive.fiend_deal")
include("scripts.items.passive.redcompass")
include("scripts.items.passive.betrayalheart")
include("scripts.items.passive.stillstanding") 
include("scripts.items.passive.bloodline") 
include("scripts.items.passive.bosscompass") 
include("scripts.items.passive.devilmap") 
include("scripts.items.passive.borrowedstrength")
include("scripts.items.passive.symphonyofdestruction") 
include("scripts.items.passive.sweetcaffeine") 
include("scripts.items.passive.PTSD") 
include("scripts.items.passive.floweringskull") 
include("scripts.items.passive.rewrappingpaper")
include("scripts.items.passive.filthyrich")
include("scripts.items.passive.grudge")
include("scripts.items.passive.coolstick")
include("scripts.items.passive.bloodbattery") 
---------------------------------------------------
--  Familiars
----------------------------------------------------
include("scripts.items.familiars.paranoidandroid")
include("scripts.items.familiars.killerqueen")
---------------------------------------------------
--  Pocket items
----------------------------------------------------
include("scripts.items.pocketitems.custompills")
include("scripts.items.pocketitems.locacaca") 
include("scripts.items.pocketitems.alpoh") 
include("scripts.items.pocketitems.starshard") 
include("scripts.items.pocketitems.energydrink") 
include("scripts.items.pocketitems.dadslottoticket") 
---------------------------------------------------
--  Trinkets
----------------------------------------------------
include("scripts.items.trinkets.wonderofyou") 
include("scripts.items.trinkets.gaga") 
include("scripts.items.trinkets.babyblue")
include("scripts.items.trinkets.second_breakfest")
include("scripts.items.trinkets.rottenfood")
include("scripts.items.trinkets.papercut")
include("scripts.items.trinkets.tarotbattery")
---------------------------------------------------
--  PIck-ups
----------------------------------------------------

---------------------------------------------------
--  Curses
----------------------------------------------------
include("scripts.curses.curse_eval")
include("scripts.curses.unloved")
---------------------------------------------------
--  Effects
----------------------------------------------------
include("scripts.effects.resonance")
include("scripts.effects.fragile")
----------------------------------------------------
--  Challenges
----------------------------------------------------
---------------------------------------------------
--  Transformations
----------------------------------------------------
include("scripts.transformations.isaacsinfulmusic")
include("scripts.transformations.dadsoldplaylist") 
---------------------------------------------------
--  NPCs
---------------------------------------------------
include("scripts.npcs.fiend_beggar") 
include("scripts.npcs.tech_beggar") 
include("scripts.npcs.guppy_beggar") 
--------Elijah's NPCs------------------------------
include("scripts.npcs.elijah.elijah_tech_beggar") 
include("scripts.npcs.elijah.elijah_beggar") 
include("scripts.npcs.elijah.elijah_bomb_beggar")
include("scripts.npcs.elijah.elijah_key_beggar") 
include("scripts.npcs.elijah.elijah_rotten_beggar") 
include("scripts.npcs.elijah.elijah_battery_beggar")
---------------------------------------------------
--  ENEMIES
---------------------------------------------------
include("scripts.enemies.mamahorf")
---------------------------------------------------
--  Somethings that comes with the mod
---------------------------------------------------
include("scripts.core.voidlost")
---------------------------------------------------
--  TESTING ITEMS
---------------------------------------------------
--include("scripts.items.active.D8055")
--include("scripts.items.passive.hitlist")
--include("scripts.items.passive.photonlink") 
--include("scripts.items.passive.silentEcho")
--include("scripts.items.passive.conscience") 
--include("scripts.items.passive.eyesacrifice")
--include("scripts.items.passive.the_path_of_the_righteous")
--include("scripts.items.passive.challengemap") 
--include("scripts.items.passive.closecall") 
--include("scripts.items.passive.TGS") 
--include("scripts.items.passive.deliriousmind") 
--include("scripts.items.passive.corona")
--include("scripts.items.trinkets.fixedmetabolism")
--include("scripts.items.pickup.burningheart")
--include("scripts.Challenges.sound_of_silence")
--include("scripts.npcs.elijah.elijah_mom_beggar")