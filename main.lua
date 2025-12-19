---@class ModReference
DiesIraeMod = RegisterMod("Dies Irae", 1)

---@class SaveManager
DiesIraeMod.SaveManager = include("scripts.dependencies.save_manager")
DiesIraeMod.SaveManager.Init(DiesIraeMod)

DiesIraeMod.JSON = require("json")

include("scripts.core.enums")
include("scripts.core.pools")
DiesIraeMod.Utils = include("scripts.core.utils")
include("scripts.core.chargebar_utils")
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
include("scripts.characters.david")
include("scripts.characters.tdavid")
include("scripts.characters.elijah")
--include("scripts.characters.bat_kol")
---------------------------------------------------
--  Active items
----------------------------------------------------
include("scripts.items.active.SlingShot")
include("scripts.items.active.armyOfLovers")
include("scripts.items.active.guppysSoul")
include("scripts.items.active.shBoom")
include("scripts.items.active.helterSkelter")
include("scripts.items.active.hypaHypa")
include("scripts.items.active.holyWood")
include("scripts.items.active.diaryOfAMadman")
include("scripts.items.active.comaWhite")
include("scripts.items.active.goodVibes")
include("scripts.items.active.momsDiary")
include("scripts.items.active.devilsHeart")
include("scripts.items.active.anotherMedium")
include("scripts.items.active.littleLies")
include("scripts.items.active.kingsHeart")
include("scripts.items.active.personalBegger")
include("scripts.items.active.breakStuff")
---------------------------------------------------
--  Passive items
----------------------------------------------------
include("scripts.items.passive.u2")
include("scripts.items.passive.echo")
include("scripts.items.passive.theBadTouch")
include("scripts.items.passive.engel")
include("scripts.items.passive.muse")
include("scripts.items.passive.scaredShoes")
include("scripts.items.passive.devilsLuck")
include("scripts.items.passive.hereToStay")
include("scripts.items.passive.ringOfFire")
include("scripts.items.passive.proteinPowder")
include("scripts.items.passive.stabWound")
include("scripts.items.passive.hysteria")
include("scripts.items.passive.thoughtContagion")
include("scripts.items.passive.enjoymentUnlucky")
include("scripts.items.passive.mutter")
include("scripts.items.passive.momsDress")
include("scripts.items.passive.goldenDay")
include("scripts.items.passive.psychosocial")
include("scripts.items.passive.ultraSecretMap")
include("scripts.items.passive.lastResort")
include("scripts.items.passive.universal")
include("scripts.items.passive.creatineOverdose")
include("scripts.items.passive.solarFlare")
include("scripts.items.passive.fragileEgo")
include("scripts.items.passive.everybodyChanging")
include("scripts.items.passive.beggarsTear")
include("scripts.items.passive.rainbowKorn")
include("scripts.items.passive.bigKahunaBurger")
include("scripts.items.passive.dadsEmptyWallet")
include("scripts.items.passive.fiendDeal")
include("scripts.items.passive.redCompass")
include("scripts.items.passive.betrayalHeart")
include("scripts.items.passive.stillStanding")
include("scripts.items.passive.bloodLine")
include("scripts.items.passive.bossCompass")
include("scripts.items.passive.devilMap")
include("scripts.items.passive.borrowedStrength")
include("scripts.items.passive.symphonyOfDestruction")
include("scripts.items.passive.sweetCaffeine")
include("scripts.items.passive.PTSD")
include("scripts.items.passive.floweringSkull")
include("scripts.items.passive.rewrappingPaper")
include("scripts.items.passive.filthyRich")
include("scripts.items.passive.grudge")
include("scripts.items.passive.coolStick")
include("scripts.items.passive.bloodBattery")
include("scripts.items.passive.corruptedMantle")
include("scripts.items.passive.harpString")
include("scripts.items.passive.Harp")
include("scripts.items.passive.deliriousmind")
---------------------------------------------------
--  Familiars
----------------------------------------------------
include("scripts.items.familiars.paranoidAndroid")
include("scripts.items.familiars.killerQueen")
include("scripts.items.familiars.RedBum")
include("scripts.items.familiars.ScammerBum")
include("scripts.items.familiars.runeBum")
include("scripts.items.familiars.fairBum")
include("scripts.items.familiars.tarotBum")
---------------------------------------------------
--  Pocket items
----------------------------------------------------
include("scripts.items.pocketitems.customPills")
include("scripts.items.pocketitems.locacaca")
include("scripts.items.pocketitems.alpoh")
include("scripts.items.pocketitems.starShard")
include("scripts.items.pocketitems.energyDrink")
include("scripts.items.pocketitems.dadsLottoTicket")
---------------------------------------------------
--  Trinkets
----------------------------------------------------
include("scripts.items.trinkets.wonderOfYou")
include("scripts.items.trinkets.gaga")
include("scripts.items.trinkets.babyBlue")
include("scripts.items.trinkets.secondBreakfast")
include("scripts.items.trinkets.rottenFood")
include("scripts.items.trinkets.paperCut")
include("scripts.items.trinkets.tarotBattery")
---------------------------------------------------
--  PIck-ups
----------------------------------------------------

---------------------------------------------------
--  Curses
----------------------------------------------------
include("scripts.curses.curse_eval")
--include("scripts.curses.unloved")
---------------------------------------------------
--  Effects
----------------------------------------------------
include("scripts.effects.resonance")
include("scripts.effects.fragile")
----------------------------------------------------
--  Challenges
----------------------------------------------------
include("scripts.challenges.worsttouch")
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
include("scripts.npcs.elijah.elijah_treasure_beggar")
include("scripts.npcs.elijah.elijah_shop_beggar")
include("scripts.npcs.elijah.elijah_angel_beggar")
include("scripts.npcs.elijah.elijah_devil_beggar")
include("scripts.npcs.elijah.elijah_planeterium_beggar")
include("scripts.npcs.elijah.elijah_secret_beggar")
include("scripts.npcs.elijah.elijah_ultra_secret_beggar")
include("scripts.npcs.elijah.elijah_error_beggar")
include("scripts.npcs.elijah.elijah_book_beggar")
---------------------------------------------------
--  ENEMIES
---------------------------------------------------
include("scripts.enemies.blindedHorf")
include("scripts.enemies.horfling")
---------------------------------------------------
--  Somethings that comes with the mod
---------------------------------------------------
include("scripts.core.voidlost")
---------------------------------------------------
--  TESTING ITEMS
---------------------------------------------------
--include("scripts.items.passive.hitlist")
--include("scripts.items.passive.photonlink")
--include("scripts.items.passive.silentEcho")
--include("scripts.items.passive.conscience")
--include("scripts.items.passive.eyesacrifice")
--include("scripts.items.passive.the_path_of_the_righteous")
--include("scripts.items.passive.challengemap")
--include("scripts.items.passive.closecall")
--include("scripts.items.passive.TGS")
--include("scripts.items.passive.corona")
--include("scripts.items.passive.redbulb.main")
include("scripts.npcs.jys")
--include("scripts.items.trinkets.fixedmetabolism")
--include("scripts.items.pickup.burningheart")
--include("scripts.Challenges.sound_of_silence")
--include("scripts.npcs.elijah.elijah_mom_beggar")
