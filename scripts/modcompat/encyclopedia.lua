local mod = DiesIraeMod

if not Encyclopedia then return end


local pdata = Isaac.GetPersistentGameData()
local function Unlocked(ach)
    if not ach or ach <= 0 then return true end
    return pdata:Unlocked(ach)
end

------------------------------------------------------------
-- EID
------------------------------------------------------------
local EIDStr = {
    -- Passives
    U2                    = "↑ +0.2 Damage#↑ +0.2 Tears#↑ +0.2 Speed#↑ +0.2 Range#↑ +0.2 Luck#↑ +0.2 Shot Speed",
    Muse                  = "Taking a pickup has a chance to spawn another#Taking a collectible has a chance to spawn the same one",
    TheBadTouch           = "Kill non-boss enemies on contact#{{Poison}} Poison bosses on contact",
    Universal             = "Hold and release fire button to absorb projectiles near Isaac#For each absorbed projectile a beam of light will spawn",
    RingOfFire            = "Spawns 6 Fire Wisps around Isaac#{{Burning}} Fire Wisps burn enemies on contact#Fire Wisps are unable to shoot#Upon clearing a room, add 1 fire wisp",
    EverybodysChanging    = "Randomize all passive items on room clear",
    Echo                  = "{{Planetarium}} +25% Planetarium chance#+10% after Womb",
    ProteinPowder         = "↑ +1 Damage#Future copies grant +1 damage for each collected copy#Effect stops after the fourth copy",
    GoldenDay             = "Spawns a golden pickup#{{SecretRoom}} 50% chance to spawn a golden pickup in the secret room",
    CreatineOverdose      = "↑ +0.2 Damage#↑ 1.2x Damage multiplier",
    FiendDeal             = "Spawns a fiend beggar in the first room on every floor#Interacting with the beggar spawns two devil items on the next floor#{{Warning}} Interacting results in Isaac dying in one hit for the floor",
    PTSD                  = "{{BossRoom}} Entering a boss room grants +0.2 tears for each time the boss has killed the player before",
    FloweringSkull        = "Revives Isaac with 2 heart containers in the same room dealing 40 damage to all enemies and rerolling all passive items",
    HarpString            = "↑ +1 Item pedestal in the Treasure room",
    Harp                  = "↑ +0.15 damage multiplier for every passive item#Not including the Harp or Harp strings",
    MichelinStar          = "Spawn two golden hearts on pickup#Spawn two golden hearts when picking up a food item",
    -- Familiars
    ParanoidAndroid       = "Shoots a static laser around itself",
    KillerQueen           = "Fires rockets at enemies",
    RedBum                = "{{Key}} Picks up nearby Keys#Has a chance to spawn Cracked Key",
    ScammerBum            = "{{Coin}} Picks up nearby pennies#Has a chance to spawn a purchasable item",
    RuneBum               = "{{Rune}} Picks up nearby runes#Has a chance to spawn a Q 0-2 pedestal",
    FairBum               = "Picks up the pickup Isaac has the most of#Has a chance to drop the pickup Isaac has the least of",
    PastorBum             = "{{SoulHeart}} Picks up soul hearts#{{AngelRoom}} Has a chance to drop angel room item#{{DevilRoom}} After dropping the item becomes corrupted with sin#{{BlackHeart}} Might reward with black hearts and devil items",
    PillBum               = "{{Pill}} Picks up pills#{{ArrowUp}} Positive pills give a minor stat boost#{{Poison}} Negative pills make the bum poison all enemies#Neutral pills give Isaac a random pill effect",
    TarotBum              = "Gets tarot cards, drop soul hearts. #Picking up reverse tarot cards spawn rotten hearts/ black hearts",
    -- Actives
    ArmyOfLovers          = "Spawns 2 Minisaacs#{{Heart}} 12% chance to spawn 5 rewards",
    SlingShot             = "Shoots a large piercing tear which destroys rocks#Tear explodes on wall impact",
    ShBoom                = "{{Collectible483}} Activates Mama Mega!#{{BrokenHeart}} +1 Broken Heart#Can only be used once per floor",
    HelterSkelter         = "25% chance for each enemy to turn into a friendly Bony",
    LittleLies            = "Size down for the room#↑ +2 Tears for the room",
    KingsHeart            = "{{Timer}} Pay 10 {{Coin}} coins to receive a {{UnknownHeart}} random heart",
    PersonalBeggar        = "{{Beggar}} Spawns a random Beggar",
    -- Trinkets
    BabyBlue              = "{{SoulHeart}} All Red Heart pickups turn into Soul Hearts",
    Gaga                  = "Increase spawn-chance for golden pickups",
    WonderOfYou           = "Taking damage has a 5% chance to kill all non-boss enemies",
    -- Cards
    DavidChord              = "David's special pickup. Has a different effect for every challenge.",
}

local function W(key)
    if not EIDStr[key] then return nil end
    return Encyclopedia.EIDtoWiki(EIDStr[key])
end

------------------------------------------------------------
-- Wiki descriptions
------------------------------------------------------------
local ItemsWiki = {
    -- Passives
    ProteinPowder    = W("ProteinPowder"),
    HarpString       = W("HarpString"),
    Harp             = W("TheHarp"),
    -- Unlockable passives
    Echo             = W("Echo"),
    TheBadTouch      = W("TheBadTouch"),
    Universal        = W("Universal"),
    RingOfFire       = W("RingOfFire"),
    EverybodysChanging = W("EverybodysChanging"),
    Muse             = W("Muse"),
    U2               = W("U2"),
    GoldenDay        = W("GoldenDay"),
    CreatineOverdose = W("CreatineOverdose"),
    PTSD             = W("PTSD"),
    FloweringSkull   = W("FloweringSkull"),
    MichelinStar     = W("MichelinStar"),
    FiendDeal        = W("FiendDeal"),
    -- Unlockable Familiars
    ParanoidAndroid  = W("ParanoidAndroid"),
    KillerQueen      = W("KillerQueen"),
    RedBum           = W("RedBum"),
    ScammerBum       = W("ScammerBum"),
    RuneBum          = W("RuneBum"),
    FairBum          = W("FairBum"),
    PastorBum        = W("PastorBum"),
    PillBum          = W("PillBum"),
    TarotBum         = W("TarotBum"),
    -- Unlockable Actives
    ArmyOfLovers     = W("ArmyOfLovers"),
    SlingShot        = W("SlingShot"),
    ShBoom           = W("ShBoom"),
    HelterSkelter    = W("HelterSkelter"),
    LittleLies       = W("LittleLies"),
    KingsHeart       = W("KingsHeart"),
    PersonalBeggar   = W("PersonalBeggar"),
    -- Unlockable Trinkets
    BabyBlue         = W("BabyBlue"),
    Gaga             = W("Gaga"),
    WonderOfYou      = W("WonderOfYou"),
    -- Pickups
    DavidChord       = W("DavidChord"),
}

local CharactersWiki = {
    David = {
        { -- Start Data
            {str = "Start Data",        fsize = 2, clr = 3, halign = 0},
            {str = "Active Item: Sling Shot"},
            {str = "Coins: 10 | HP: 1 Golden Heart"},
            {str = "Speed: 1.2 | Damage: 6 | Tears: 2.73"},
            {str = "Range: 6.5 | Shot Speed: 1.0 | Luck: 0"},
        },
        { -- Traits
            {str = "Traits",            fsize = 2, clr = 3, halign = 0},
            {str = "Has a unique challenges in every floor. Challenges starts on the second floor"},
            {str = "Completing floor challenges gives Harp String."},
            {str = "{{BrokenHeart}} Completing a challenge without using David's Chord heals 1 Broken Heart."},
        },
        { -- Birthright
            {str = "Birthright: Goliath Killer", fsize = 2, clr = 3, halign = 0},
            {str = "David deals double damage to bosses."},
            {str = "David's Chord spawn rate greatly increased."},
        },
    },
    Elijah = {
        { -- Start Data
            {str = "Start Data",        fsize = 2, clr = 3, halign = 0},
            {str = "HP: 2 Rotten Hearts + 1 Black Heart"},
            {str = "Speed: 0.9 | Damage: 1.5 | Tears: 2.73"},
            {str = "Range: 5.0 | Shot Speed: 0.8 | Luck: -1"},
            {str = "Starts with 1 Bomb and 1 Key"},
        },
        { -- Traits
            {str = "Traits",            fsize = 2, clr = 3, halign = 0},
            {str = "Cannot get regular pickups"},
            {str = "Gain Elijah's wills instead"},
            {str = "Donating to beggars gives items and pickups"},
        },
        { -- Birthright
            {str = "Birthright: Force of Will", fsize = 2, clr = 3, halign = 0},
            {str = "Wills can become stronger and give permanent stat boosts."},
        },
    },
}

------------------------------------------------------------
-- Unlock descriptions
------------------------------------------------------------
local UnlockDescs = {
    -- David completion marks
    ArmyOfLovers       = "Defeat Mom's Heart as David.",
    TheBadTouch        = "Defeat Isaac as David.",
    LittleLies         = "Defeat Satan as David.",
    ParanoidAndroid    = "Defeat The Lamb as David.",
    ShBoom             = "Defeat Mega Satan as David.",
    Universal          = "Beat Boss Rush as David.",
    EverybodysChanging = "Defeat Hush as David.",
    U2                 = "Defeat The Beast as David.",
    KillerQueen        = "Beat the Corpse as David.",
    RingOfFire         = "Beat Greedier Mode as David.",
    HelterSkelter      = "Defeat Delirium as David.",
    BabyBlue           = "Defeat ??? as David.",
    WonderOfYou        = "Beat Greed Mode as David.",
    Muse               = "Get all hard completion marks as David.",
    -- Elijah completion marks
    RuneBum            = "Defeat Mom's Heart as Elijah.",
    PastorBum          = "Defeat Isaac as Elijah.",
    TarotBum           = "Defeat Satan as Elijah.",
    RedBum             = "Defeat The Lamb as Elijah.",
    SacrificeTable     = "Defeat Mega Satan as Elijah.",
    PillBum            = "Beat Boss Rush as Elijah.",
    LostAdventurer     = "Defeat Hush as Elijah.",
    FamiliarsBeggar    = "Defeat The Beast as Elijah.",
    FiendDeal          = "Beat the Corpse as Elijah.",
    JYS                = "Beat Greedier Mode as Elijah.",
    FairBum            = "Defeat Delirium as Elijah.",
    Goldsmith          = "Defeat ??? as Elijah.",
    ScammerBum         = "Beat Greed Mode as Elijah.",
    ChaosBeggar        = "Get all hard completion marks as Elijah.",
    -- Misc unlocks
    SlingShot          = "Complete 1 challenge as David.",
    GoldenDay          = "Pick up a golden key, bomb, and coin in one run as David.",
    CreatineOverdose   = "Have 2 copies of Protein Powder at the same time.",
    PTSD               = "Die to a boss on Basement 1.",
    FloweringSkull     = "Die while holding Helter Skelter.",
    Echo               = "Visit a Planetarium without taking an item.",
    MichelinStar       = "Complete 4 challenges as David.",
    Gaga               = "Die as David.",
    KingsHeart         = "Hold 3 Golden Hearts at once as David.",
    PersonalBeggar     = "Win a run as Elijah.",
}

------------------------------------------------------------
-- UnlockFunc table
------------------------------------------------------------
local UnlocksTable = {
    -- Characters
    David = function(self)
        if not Unlocked(mod.Achievements.David) then
            self.Desc = UnlockDescs.David
            return self
        end
    end,
    Elijah = function(self)
        if not Unlocked(mod.Achievements.Elijah) then
            self.Desc = UnlockDescs.Elijah
            return self
        end
    end,
    -- David completion mark unlocks
    ArmyOfLovers = function(self)
        if not Unlocked(mod.Achievements.ArmyOfLovers) then
            self.Desc = UnlockDescs.ArmyOfLovers
            return self
        end
    end,
    TheBadTouch = function(self)
        if not Unlocked(mod.Achievements.TheBadTouch) then
            self.Desc = UnlockDescs.TheBadTouch
            return self
        end
    end,
    LittleLies = function(self)
        if not Unlocked(mod.Achievements.LittleLies) then
            self.Desc = UnlockDescs.LittleLies
            return self
        end
    end,
    ParanoidAndroid = function(self)
        if not Unlocked(mod.Achievements.ParanoidAndroid) then
            self.Desc = UnlockDescs.ParanoidAndroid
            return self
        end
    end,
    ShBoom = function(self)
        if not Unlocked(mod.Achievements.ShBoom) then
            self.Desc = UnlockDescs.ShBoom
            return self
        end
    end,
    Universal = function(self)
        if not Unlocked(mod.Achievements.Universal) then
            self.Desc = UnlockDescs.Universal
            return self
        end
    end,
    EverybodysChanging = function(self)
        if not Unlocked(mod.Achievements.EverybodysChanging) then
            self.Desc = UnlockDescs.EverybodysChanging
            return self
        end
    end,
    U2 = function(self)
        if not Unlocked(mod.Achievements.U2) then
            self.Desc = UnlockDescs.U2
            return self
        end
    end,
    KillerQueen = function(self)
        if not Unlocked(mod.Achievements.KillerQueen) then
            self.Desc = UnlockDescs.KillerQueen
            return self
        end
    end,
    RingOfFire = function(self)
        if not Unlocked(mod.Achievements.RingOfFire) then
            self.Desc = UnlockDescs.RingOfFire
            return self
        end
    end,
    HelterSkelter = function(self)
        if not Unlocked(mod.Achievements.HelterSkelter) then
            self.Desc = UnlockDescs.HelterSkelter
            return self
        end
    end,
    BabyBlue = function(self)
        if not Unlocked(mod.Achievements.BabyBlue) then
            self.Desc = UnlockDescs.BabyBlue
            return self
        end
    end,
    WonderOfYou = function(self)
        if not Unlocked(mod.Achievements.WonderOfYou) then
            self.Desc = UnlockDescs.WonderOfYou
            return self
        end
    end,
    Muse = function(self)
        if not Unlocked(mod.Achievements.Muse) then
            self.Desc = UnlockDescs.Muse
            return self
        end
    end,
    -- Elijah completion mark unlocks
    RuneBum = function(self)
        if not Unlocked(mod.Achievements.RuneBum) then
            self.Desc = UnlockDescs.RuneBum
            return self
        end
    end,
    PastorBum = function(self)
        if not Unlocked(mod.Achievements.PastorBum) then
            self.Desc = UnlockDescs.PastorBum
            return self
        end
    end,
    TarotBum = function(self)
        if not Unlocked(mod.Achievements.TarotBum) then
            self.Desc = UnlockDescs.TarotBum
            return self
        end
    end,
    RedBum = function(self)
        if not Unlocked(mod.Achievements.RedBum) then
            self.Desc = UnlockDescs.RedBum
            return self
        end
    end,
    SacrificeTable = function(self)
        if not Unlocked(mod.Achievements.SacrificeTable) then
            self.Desc = UnlockDescs.SacrificeTable
            return self
        end
    end,
    PillBum = function(self)
        if not Unlocked(mod.Achievements.PillBum) then
            self.Desc = UnlockDescs.PillBum
            return self
        end
    end,
    LostAdventurer = function(self)
        if not Unlocked(mod.Achievements.LostAdventurer) then
            self.Desc = UnlockDescs.LostAdventurer
            return self
        end
    end,
    FamiliarsBeggar = function(self)
        if not Unlocked(mod.Achievements.FamiliarsBeggar) then
            self.Desc = UnlockDescs.FamiliarsBeggar
            return self
        end
    end,
    FiendDeal = function(self)
        if not Unlocked(mod.Achievements.FiendDeal) then
            self.Desc = UnlockDescs.FiendDeal
            return self
        end
    end,
    JYS = function(self)
        if not Unlocked(mod.Achievements.JYS) then
            self.Desc = UnlockDescs.JYS
            return self
        end
    end,
    FairBum = function(self)
        if not Unlocked(mod.Achievements.FairBum) then
            self.Desc = UnlockDescs.FairBum
            return self
        end
    end,
    Goldsmith = function(self)
        if not Unlocked(mod.Achievements.Goldsmith) then
            self.Desc = UnlockDescs.Goldsmith
            return self
        end
    end,
    ScammerBum = function(self)
        if not Unlocked(mod.Achievements.ScammerBum) then
            self.Desc = UnlockDescs.ScammerBum
            return self
        end
    end,
    ChaosBeggar = function(self)
        if not Unlocked(mod.Achievements.ChaosBeggar) then
            self.Desc = UnlockDescs.ChaosBeggar
            return self
        end
    end,
    -- Misc unlocks
    SlingShot = function(self)
        if not Unlocked(mod.Achievements.SlingShot) then
            self.Desc = UnlockDescs.SlingShot
            return self
        end
    end,
    GoldenDay = function(self)
        if not Unlocked(mod.Achievements.GoldenDay) then
            self.Desc = UnlockDescs.GoldenDay
            return self
        end
    end,
    CreatineOverdose = function(self)
        if not Unlocked(mod.Achievements.CreatineOverdose) then
            self.Desc = UnlockDescs.CreatineOverdose
            return self
        end
    end,
    PTSD = function(self)
        if not Unlocked(mod.Achievements.PTSD) then
            self.Desc = UnlockDescs.PTSD
            return self
        end
    end,
    FloweringSkull = function(self)
        if not Unlocked(mod.Achievements.FloweringSkull) then
            self.Desc = UnlockDescs.FloweringSkull
            return self
        end
    end,
    Echo = function(self)
        if not Unlocked(mod.Achievements.Echo) then
            self.Desc = UnlockDescs.Echo
            return self
        end
    end,
    MichelinStar = function(self)
        if not Unlocked(mod.Achievements.MichelinStar) then
            self.Desc = UnlockDescs.MichelinStar
            return self
        end
    end,
    Gaga = function(self)
        if not Unlocked(mod.Achievements.Gaga) then
            self.Desc = UnlockDescs.Gaga
            return self
        end
    end,
    KingsHeart = function(self)
        if not Unlocked(mod.Achievements.KingsHeart) then
            self.Desc = UnlockDescs.KingsHeart
            return self
        end
    end,
    PersonalBeggar = function(self)
        if not Unlocked(mod.Achievements.PersonalBeggar) then
            self.Desc = UnlockDescs.PersonalBeggar
            return self
        end
    end,
}

------------------------------------------------------------
-- Completion tracker helpers
------------------------------------------------------------
local DavidCompletions = {
    [CompletionType.MOMS_HEART]     = mod.Achievements.ArmyOfLovers,
    [CompletionType.ISAAC]          = mod.Achievements.TheBadTouch,
    [CompletionType.SATAN]          = mod.Achievements.LittleLies,
    [CompletionType.LAMB]           = mod.Achievements.ParanoidAndroid,
    [CompletionType.MEGA_SATAN]     = mod.Achievements.ShBoom,
    [CompletionType.BOSS_RUSH]      = mod.Achievements.Universal,
    [CompletionType.HUSH]           = mod.Achievements.EverybodysChanging,
    [CompletionType.BEAST]          = mod.Achievements.U2,
    [CompletionType.MOTHER]         = mod.Achievements.KillerQueen,
    [CompletionType.ULTRA_GREEDIER] = mod.Achievements.RingOfFire,
    [CompletionType.DELIRIUM]       = mod.Achievements.HelterSkelter,
    [CompletionType.BLUE_BABY]      = mod.Achievements.BabyBlue,
    [CompletionType.ULTRA_GREED]    = mod.Achievements.WonderOfYou,
}

local ElijahCompletions = {
    [CompletionType.MOMS_HEART]     = mod.Achievements.RuneBum,
    [CompletionType.ISAAC]          = mod.Achievements.PastorBum,
    [CompletionType.SATAN]          = mod.Achievements.TarotBum,
    [CompletionType.LAMB]           = mod.Achievements.RedBum,
    [CompletionType.MEGA_SATAN]     = mod.Achievements.SacrificeTable,
    [CompletionType.BOSS_RUSH]      = mod.Achievements.PillBum,
    [CompletionType.HUSH]           = mod.Achievements.LostAdventurer,
    [CompletionType.BEAST]          = mod.Achievements.FamiliarsBeggar,
    [CompletionType.MOTHER]         = mod.Achievements.FiendDeal,
    [CompletionType.ULTRA_GREEDIER] = mod.Achievements.JYS,
    [CompletionType.DELIRIUM]       = mod.Achievements.FairBum,
    [CompletionType.BLUE_BABY]      = mod.Achievements.Goldsmith,
    [CompletionType.ULTRA_GREED]    = mod.Achievements.ScammerBum,
}

local function MakeCompletionTracker(completionMap)
    return {
        function()
            local tab = {}
            for ctype, ach in pairs(completionMap) do
                tab[ctype] = {
                    Unlock = Unlocked(ach),
                    Hard   = false,
                }
            end
            return tab
        end
    }
end

------------------------------------------------------------
-- Main registration function
------------------------------------------------------------
function mod:AddEncyclopediaDescs()
    -- Characters
    Encyclopedia.AddCharacter({
        Class    = "Dies Irae",
        ModName  = "Dies Irae",
        Name     = "David",
        ID       = mod.Players.David,
        WikiDesc = CharactersWiki.David,
        CompletionTrackerFuncs = MakeCompletionTracker(DavidCompletions),
        UnlockFunc = function(self)
            if not Unlocked(mod.Achievements.David) then
                self.Desc = "Get the 3 golden pickups in the same run."
                return self
            end
        end,
    })

    Encyclopedia.AddCharacter({
        Class    = "Dies Irae",
        ModName  = "Dies Irae",
        Name     = "Elijah",
        ID       = mod.Players.Elijah,
        WikiDesc = CharactersWiki.Elijah,
        CompletionTrackerFuncs = MakeCompletionTracker(ElijahCompletions),
        UnlockFunc = function(self)
            if not Unlocked(mod.Achievements.Elijah) then
                self.Desc = "Pay 3 different beggars in one run."
                return self
            end
        end,
    })

    ----------------------------------------------------------
    -- Item registration helper
    ----------------------------------------------------------
    local function Item(id, wikiKey, unlockKey)
        if not id or id < 0 then return end
        Encyclopedia.AddItem({
            Class      = "Dies Irae",
            ModName    = "Dies Irae",
            ID         = id,
            WikiDesc   = wikiKey  and ItemsWiki[wikiKey]   or nil,
            UnlockFunc = unlockKey and UnlocksTable[unlockKey] or nil,
        })
    end

    local function Trinket(id, wikiKey, unlockKey)
        if not id or id < 0 then return end
        Encyclopedia.AddTrinket({
            Class      = "Dies Irae",
            ModName    = "Dies Irae",
            ID         = id,
            WikiDesc   = wikiKey  and ItemsWiki[wikiKey]   or nil,
            UnlockFunc = unlockKey and UnlocksTable[unlockKey] or nil,
        })
    end

    local function Card(id, wikiKey)
        if not id or id < 0 then return end
        Encyclopedia.AddCard({
            Class    = "Dies Irae",
            ModName  = "Dies Irae",
            ID       = id,
            WikiDesc = wikiKey and ItemsWiki[wikiKey] or nil,
        })
    end

    local function PocketItem(id, wikiKey)
        if not id or id < 0 then return end
        Encyclopedia.AddPocketItem({
            Class    = "Dies Irae",
            ModName  = "Dies Irae",
            ID       = id,
            WikiDesc = wikiKey and ItemsWiki[wikiKey] or nil,
        })
    end
    ----------------------------------------------------------
    -- Collectibles without achievements
    ----------------------------------------------------------
    Item(mod.Items.ProteinPowder,         "ProteinPowder")
    Item(mod.Items.HarpString,            "HarpString")
    Item(mod.Items.Harp,                  "TheHarp")

    ----------------------------------------------------------
    -- Collectibles with achievements
    ----------------------------------------------------------

    -- David unlocks
    Item(mod.Items.ArmyOfLovers,          "ArmyOfLovers",       "ArmyOfLovers")
    Item(mod.Items.TheBadTouch,           "TheBadTouch",        "TheBadTouch")
    Item(mod.Items.LittleLies,            "LittleLies",         "LittleLies")
    Item(mod.Items.ParanoidAndroid,       "ParanoidAndroid",    "ParanoidAndroid")
    Item(mod.Items.ShBoom,                "ShBoom",             "ShBoom")
    Item(mod.Items.Universal,             "Universal",          "Universal")
    Item(mod.Items.EverybodysChanging,    "EverybodysChanging", "EverybodysChanging")
    Item(mod.Items.U2,                    "U2",                 "U2")
    Item(mod.Items.KillerQueen,           "KillerQueen",        "KillerQueen")
    Item(mod.Items.RingOfFire,            "RingOfFire",         "RingOfFire")
    Item(mod.Items.HelterSkelter,         "HelterSkelter",      "HelterSkelter")
    Item(mod.Items.Muse,                  "Muse",               "Muse")
    Trinket(mod.Trinkets.WonderOfYou,     "WonderOfYou",        "WonderOfYou")
    Trinket(mod.Trinkets.BabyBlue,        "BabyBlue",           "BabyBlue")

    -- Elijah unlocks
    Item(mod.Items.RuneBum,               "RuneBum",            "RuneBum")
    Item(mod.Items.PastorBum,             "PastorBum",          "PastorBum")
    Item(mod.Items.FairBum,               "FairBum",            "FairBum")
    Item(mod.Items.RedBum,                "RedBum",             "RedBum")
    Item(mod.Items.PillBum,               "PillBum",            "PillBum")
    Item(mod.Items.ScammerBum,            "ScammerBum",         "ScammerBum")
    Item(mod.Items.FiendDeal,             "FiendDeal",          "FiendDeal")

    -- Misc unlocks
    Item(mod.Items.SlingShot,             "SlingShot",          "SlingShot")
    Item(mod.Items.GoldenDay,             "GoldenDay",          "GoldenDay")
    Item(mod.Items.Echo,                  "Echo",               "Echo")
    Item(mod.Items.CreatineOverdose,      "CreatineOverdose",   "CreatineOverdose")
    Item(mod.Items.PTSD,                  "PTSD",               "PTSD")
    Item(mod.Items.FloweringSkull,        "FloweringSkull",     "FloweringSkull")
    Item(mod.Items.MichelinStar,          "MichelinStar",       "MichelinStar")
    Item(mod.Items.KingsHeart,            "KingsHeart",         "KingsHeart")
    Item(mod.Items.PersonalBeggar,        "PersonalBeggar",     "PersonalBeggar")

    ----------------------------------------------------------
    -- Trinkets
    ----------------------------------------------------------
    Trinket(mod.Trinkets.Gaga,            "Gaga",               "Gaga")

    ----------------------------------------------------------
    -- Pickups
    ----------------------------------------------------------
    PocketItem(mod.Cards.DavidChord,      "DavidChord")
end


mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function()
    if not Encyclopedia then return end
    mod:AddEncyclopediaDescs()
end)