---@class ModReference
local mod = DiesIraeMod

---@param name string
---@alias entityTable {Type: integer, Var: integer, SType: integer}
---@return entityTable
local function MakeEntityTable(name)
    return {
        Type = Isaac.GetEntityTypeByName(name),
        Var = Isaac.GetEntityVariantByName(name),
        SType = Isaac.GetEntitySubTypeByName(name)
    }
end

mod.Players = {
    David  = Isaac.GetPlayerTypeByName("David", false),
    TDavid = Isaac.GetPlayerTypeByName("David", true),
    Elijah = Isaac.GetPlayerTypeByName("Elijah", false),
    BatKol = Isaac.GetPlayerTypeByName("Bat Kol", false),
}

mod.Items = {
    -- Passives
    U2                    = Isaac.GetItemIdByName("U2"),
    Muse                  = Isaac.GetItemIdByName("Muse"),
    TheBadTouch           = Isaac.GetItemIdByName("The Bad Touch"),
    Universal             = Isaac.GetItemIdByName("Universal"),
    RingOfFire            = Isaac.GetItemIdByName("Ring of Fire"),
    MomsDress             = Isaac.GetItemIdByName("Mom's Dress"),
    EnjoymentOfTheUnlucky = Isaac.GetItemIdByName("Enjoyment of the Unlucky"),
    EverybodysChanging    = Isaac.GetItemIdByName("Everybody's Changing"),
    Echo                  = Isaac.GetItemIdByName("Echo"),
    Engel                 = Isaac.GetItemIdByName("Engel"),
    ScaredShoes           = Isaac.GetItemIdByName("Scared Shoes"),
    DevilsLuck            = Isaac.GetItemIdByName("Devil's Luck"),
    HereToStay            = Isaac.GetItemIdByName("Here to Stay"),
    ProteinPowder         = Isaac.GetItemIdByName("Protein Powder"),
    Hysteria              = Isaac.GetItemIdByName("Hysteria"),
    StabWound             = Isaac.GetItemIdByName("Stab Wound"),
    ThoughtContagion      = Isaac.GetItemIdByName("Thought Contagion"),
    GoldenDay             = Isaac.GetItemIdByName("Golden Day"),
    Mutter                = Isaac.GetItemIdByName("Mutter"),
    SolarFlare            = Isaac.GetItemIdByName("Solar Flare"),
    Psychosocial          = Isaac.GetItemIdByName("Psychosocial"),
    UltraSecretMap        = Isaac.GetItemIdByName("Ultra Secret Map"),
    RedCompass            = Isaac.GetItemIdByName("Red Compass"),
    LastResort            = Isaac.GetItemIdByName("Last Resort"),
    CreatineOverdose      = Isaac.GetItemIdByName("Creatine Overdose"),
    FragileEgo            = Isaac.GetItemIdByName("Fragile Ego"),
    BeggarsTear           = Isaac.GetItemIdByName("Beggar's Tear"),
    BigKahunaBurger       = Isaac.GetItemIdByName("Big Kahuna Burger"),
    DadsEmptyWallet       = Isaac.GetItemIdByName("Dad's Empty Wallet"),
    KoRn                  = Isaac.GetItemIdByName("Rainbow KoRn"),
    FiendDeal             = Isaac.GetItemIdByName("Fiend Deal"),
    BetrayalHeart         = Isaac.GetItemIdByName("Betrayal Heart"),
    StillStanding         = Isaac.GetItemIdByName("Still Standing"),
    Bloodline             = Isaac.GetItemIdByName("Bloodline"),
    BossCompass           = Isaac.GetItemIdByName("Boss Compass"),
    DevilsMap             = Isaac.GetItemIdByName("Devil's Map"),
    BorrowedStrength      = Isaac.GetItemIdByName("Borrowed Strength"),
    SymphonyOfDestr       = Isaac.GetItemIdByName("Symphony Of Destruction"),
    SweetCaffeine         = Isaac.GetItemIdByName("Sweet Caffeine"),
    PTSD                  = Isaac.GetItemIdByName("PTSD"),
    FloweringSkull        = Isaac.GetItemIdByName("Flowering Skull"),
    RewrappingPaper       = Isaac.GetItemIdByName("Rewrapping Paper"),
    FilthyRich            = Isaac.GetItemIdByName("Filthy Rich"),
    CoolStick             = Isaac.GetItemIdByName("Cool Stick"),
    Grudge                = Isaac.GetItemIdByName("Grudge"),
    BloodBattery          = Isaac.GetItemIdByName("Blood Battery"),
    CorruptedMantle       = Isaac.GetItemIdByName("Corrupted Mantle"),
    DeliriousMind         = Isaac.GetItemIdByName("Delirious Mind"),
    HarpString            = Isaac.GetItemIdByName("Harp String"),
    Harp                  = Isaac.GetItemIdByName("The Harp"),
    MichelinStar          = Isaac.GetItemIdByName("Michelin Star Reward"),
	RedBulb				  = Isaac.GetItemIdByName("Red Bulb"),

    -- Familiars
    ParanoidAndroid       = Isaac.GetItemIdByName("Paranoid Android"),
    KillerQueen           = Isaac.GetItemIdByName("Killer Queen"),
    RedBum                = Isaac.GetItemIdByName("Red Bum"),
    ScammerBum            = Isaac.GetItemIdByName("Scammer Bum"),
    RuneBum               = Isaac.GetItemIdByName("Rune Bum"),
    FairBum               = Isaac.GetItemIdByName("Fair Bum"),
    TarotBum              = Isaac.GetItemIdByName("Tarot Bum"),
	PillBum				  = Isaac.GetItemIdByName("Pill Bum"),
    PastorBum             = Isaac.GetItemIdByName("Pastor Bum"),

    -- Actives
    GuppysSoul            = Isaac.GetItemIdByName("Guppy's soul"),
    ArmyOfLovers          = Isaac.GetItemIdByName("Army of Lovers"),
    ShBoom                = Isaac.GetItemIdByName("Sh-boom!!"),
    HypaHypa              = Isaac.GetItemIdByName("Hypa Hypa"),
    HelterSkelter         = Isaac.GetItemIdByName("Helter skelter"),
    HolyWood              = Isaac.GetItemIdByName("Holy Wood"),
    DiaryOfAMadman        = Isaac.GetItemIdByName("Diary of a Madman"),
    ComaWhite             = Isaac.GetItemIdByName("Coma White"),
    GoodVibes             = Isaac.GetItemIdByName("Good Vibes"),
    DevilsHeart           = Isaac.GetItemIdByName("Devil's Heart"),
    MomsDiary             = Isaac.GetItemIdByName("Mom's Diary"),
    AnotherMedium         = Isaac.GetItemIdByName("Another Medium"),
    LittleLies            = Isaac.GetItemIdByName("Little Lies"),
    SlingShot             = Isaac.GetItemIdByName("Sling Shot"),
    KingsHeart            = Isaac.GetItemIdByName("King's Heart"),
    BreakStuff            = Isaac.GetItemIdByName("Break Stuff"),
    PersonalBeggar        = Isaac.GetItemIdByName("Personal Beggar"),

    --TESTING
    Conscience            = Isaac.GetItemIdByName("Conscience"),
    PathOfTheRighteous    = Isaac.GetItemIdByName("Path Of The Righteous"),
    BackInAnger           = Isaac.GetItemIdByName("Back In Anger"),
    FriendlessChild       = Isaac.GetItemIdByName("Friendless Child"),
    Masochism             = Isaac.GetItemIdByName("Masochism"),
    TouristMap            = Isaac.GetItemIdByName("Tourist Map"),
    TravelerLogbook       = Isaac.GetItemIdByName("Traveler Logbook"),
    EyeSacrifice          = Isaac.GetItemIdByName("Eye Sacrifice"),
    SkullCrasher          = Isaac.GetItemIdByName("Skull Crasher"),
    DadsDumbbell          = Isaac.GetItemIdByName("Dad's Dumbbell"),
    SilentEcho            = Isaac.GetItemIdByName("Silent Echo"),
    PhotonLink            = Isaac.GetItemIdByName("Photon Link"),
    CloseCall             = Isaac.GetItemIdByName("Close Call!"),
    HitList               = Isaac.GetItemIdByName("Hit List"),
    Corona                = Isaac.GetItemIdByName("Corona"),
    TGS                   = Isaac.GetItemIdByName("Triple Gooberberry Sunrise"),
    ChallengerMap         = Isaac.GetItemIdByName("Challenger Map"),
}

mod.Wisps = {
    RingofFire1 = Isaac.GetItemIdByName("Wisp Ring of Fire 1"),
    RingofFire2 = Isaac.GetItemIdByName("Wisp Ring of Fire 2"),
    RingofFire3 = Isaac.GetItemIdByName("Wisp Ring of Fire 3"),
    RingofFire4 = Isaac.GetItemIdByName("Wisp Ring of Fire 4"),
    RingofFire5 = Isaac.GetItemIdByName("Wisp Ring of Fire 5"),
}

mod.Trinkets = {
    Gaga             = Isaac.GetTrinketIdByName("Gaga"),
    BabyBlue         = Isaac.GetTrinketIdByName("Baby Blue"),
    WonderOfYou      = Isaac.GetTrinketIdByName("Wonder of You"),
    RottenFood       = Isaac.GetTrinketIdByName("Rotten Food"),
    SecondBreakfast  = Isaac.GetTrinketIdByName("Second Breakfast"),
    Papercut         = Isaac.GetTrinketIdByName("Papercut"),
    TarotBattery     = Isaac.GetTrinketIdByName("Tarot Battery"),

    --TESTING
    MoneyForNothing  = Isaac.GetTrinketIdByName("Money for nothing"),
    CatchTheRainbow  = Isaac.GetTrinketIdByName("Catch the Rainbow"),
    ClearVase        = Isaac.GetTrinketIdByName("Clear Vase"),
    FixedMetabolism  = Isaac.GetTrinketIdByName("Fixed Metabolism"),
    BrokenDream      = Isaac.GetTrinketIdByName("In a Broken Dream"),
    TrinketCollector = Isaac.GetTrinketIdByName("Trinket Collector"),
}

mod.Pills = {
    CURSED            = Isaac.GetPillEffectByName("Cursed Pill"),
    BLESSED           = Isaac.GetPillEffectByName("Blessed Pill"),
    HEARTBREAK        = Isaac.GetPillEffectByName("Heartbreak Pill"),
    POWER_DRAIN       = Isaac.GetPillEffectByName("Power Drain Pill"),
    VOMIT             = Isaac.GetPillEffectByName("Vomit Pill"),
    SOMETHING_CHANGED = Isaac.GetPillEffectByName("Something Changed Pill"),
    EQUAL             = Isaac.GetPillEffectByName("Equal Pill")
}

mod.Sounds = {
    JEVIL_CHAOS           = Isaac.GetSoundIdByName("Chaos chaos"),
    KILLER_QUEEN_DETONATE = Isaac.GetSoundIdByName("Killer Queen Detonate"),
    KINGS_FART            = Isaac.GetSoundIdByName("King's Heart Fart"),
    Whoosh                = Isaac.GetSoundIdByName("Whoosh"),

    --Pills
    CURSED            = Isaac.GetSoundIdByName("Cursed Pill"),
    BLESSED           = Isaac.GetSoundIdByName("Blessed Pill"),
    HEARTBREAK        = Isaac.GetSoundIdByName("Heartbreak Pill"),
    POWER_DRAIN       = Isaac.GetSoundIdByName("Power Drain Pill"),
    VOMIT             = Isaac.GetSoundIdByName("Vomit Pill"),
    SOMETHING_CHANGED = Isaac.GetSoundIdByName("Something Changed Pill"),
    EQUAL             = Isaac.GetSoundIdByName("Equilibrium Pill")
}

mod.Music = {
    TechBeggarWaiting = Isaac.GetMusicIdByName("Tech Beggar Waiting"),
    Oiiai             = Isaac.GetMusicIdByName("Oiiai"),
    GigaChad          = Isaac.GetMusicIdByName("GigaChad"),
}

mod.Costumes = {
    David_Hair       = Isaac.GetCostumeIdByPath("gfx/characters/david_hair.anm2"),
    TDavid_Hair      = Isaac.GetCostumeIdByPath("gfx/characters/tdavid_hair.anm2"),
    Universal_active = Isaac.GetCostumeIdByPath("gfx/characters/universal_head.anm2"),
    Holywood         = Isaac.GetCostumeIdByPath("gfx/characters/holywood.anm2"),
    BrokenHolywood   = Isaac.GetCostumeIdByPath("gfx/characters/brokenholywood.anm2"),
    Harpstring1_hair = Isaac.GetCostumeIdByPath("gfx/characters/harpstring1_hair.anm2"),
    Harpstring2_hair = Isaac.GetCostumeIdByPath("gfx/characters/harpstring2_hair.anm2"),
    Harpstring3_hair = Isaac.GetCostumeIdByPath("gfx/characters/harpstring3_hair.anm2"),
    Harpstring4_hair = Isaac.GetCostumeIdByPath("gfx/characters/harpstring4_hair.anm2"),
    Harpstring1_eyes = Isaac.GetCostumeIdByPath("gfx/characters/harpstring1_eyes.anm2"),
    Harpstring2_eyes = Isaac.GetCostumeIdByPath("gfx/characters/harpstring2_eyes.anm2"),
    Harpstring3_eyes = Isaac.GetCostumeIdByPath("gfx/characters/harpstring3_eyes.anm2"),
    Harpstring4_eyes = Isaac.GetCostumeIdByPath("gfx/characters/harpstring4_eyes.anm2"),
    Harpstring1_body = Isaac.GetCostumeIdByPath("gfx/characters/harpstring1_body.anm2"),
    Harpstring2_body = Isaac.GetCostumeIdByPath("gfx/characters/harpstring2_body.anm2"),
    Harpstring3_body = Isaac.GetCostumeIdByPath("gfx/characters/harpstring3_body.anm2"),
    Harpstring4_body = Isaac.GetCostumeIdByPath("gfx/characters/harpstring4_body.anm2"),
}

mod.Cards = {
    Locacaca        = Isaac.GetCardIdByName("Locacaca"),
    alpoh           = Isaac.GetCardIdByName("A Little Piece of Heaven"),
    StarShard       = Isaac.GetCardIdByName("Star Shard"),
    EnergyDrink     = Isaac.GetCardIdByName("Energy Drink"),
    DadsLottoTicket = Isaac.GetCardIdByName("Dad's Lotto Ticket"),
}

mod.Entities = {
    BEGGAR_Fiend             = MakeEntityTable("Fiend Beggar"),
    BEGGAR_Tech              = MakeEntityTable("Tech Beggar"),
    BEGGAR_Guppy             = MakeEntityTable("Guppy Beggar"),
    BEGGAR_JYS               = MakeEntityTable("Junk Yard Seller"),
    BEGGAR_Goldsmith         = MakeEntityTable("Goldsmith Beggar"),
    BEGGAR_Familiars         = MakeEntityTable("Familiars Beggar"),
    BEGGAR_SacrificeTable    = MakeEntityTable("Sacrifice Table"),
    BEGGAR_Chaos             = MakeEntityTable("Chaos Beggar"),
    BEGGAR_Lost_Adventurer   = MakeEntityTable("Lost Adventurer"),

    BEGGAR_TechElijah        = MakeEntityTable("Tech Beggar Elijah"),
    BEGGAR_Elijah            = MakeEntityTable("Beggar Elijah"),
    BEGGAR_BombElijah        = MakeEntityTable("Bomb Beggar Elijah"),
    BEGGAR_KeyElijah         = MakeEntityTable("Key Beggar Elijah"),
    BEGGAR_BatteryElijah     = MakeEntityTable("Battery Beggar Elijah"),
    BEGGAR_RottenElijah      = MakeEntityTable("Rotten Beggar Elijah"),
    BEGGAR_MomBoxElijah      = MakeEntityTable("Mom's Chest Elijah"),
    BEGGAR_TreasureElijah    = MakeEntityTable("Treasure Beggar Elijah"),
    BEGGAR_ShopElijah        = MakeEntityTable("Shop Beggar Elijah"),
    BEGGAR_LibraryElijah     = MakeEntityTable("Library Beggar Elijah"),
    BEGGAR_AngelElijah       = MakeEntityTable("Angel Beggar Elijah"),
    BEGGAR_DemonElijah       = MakeEntityTable("Demon Beggar Elijah"),
    BEGGAR_SecretElijah      = MakeEntityTable("Secret Beggar Elijah"),
    BEGGAR_UltraSecretElijah = MakeEntityTable("Ultra Secret Beggar Elijah"),
    BEGGAR_PlanetariumElijah = MakeEntityTable("Planetarium Beggar Elijah"),
    BEGGAR_ERROR_Elijah      = MakeEntityTable("ERROR Beggar Elijah"),
    BEGGAR_Restock_Elijah    = MakeEntityTable("Restock Elijah"),
    BEGGAR_JYS_Elijah        = MakeEntityTable("Junk Yard Seller Elijah"),
    BEGGAR_Goldsmith_Elijah  = MakeEntityTable("Goldsmith Beggar Elijah"),
    BEGGAR_Familiars_Elijah  = MakeEntityTable("Familiars Beggar Elijah"),
    BEGGAR_Lost_Adventurer_E = MakeEntityTable("Lost Adventurer Elijah"),
    BEGGAR_Chaos_Elijah      = MakeEntityTable("Chaos Beggar Elijah"),

    FAMILIAR_ParanoidAndroid = MakeEntityTable("Paranoid Android"),
    FAMILIAR_KillerQueen     = MakeEntityTable("Killer Queen"),
    FAMILIAR_BatKolGhost     = MakeEntityTable("Bat Kol's Ghosts"),
    FAMILIAR_RighteousGhost  = MakeEntityTable("Righteous Ghost"),
    PICKUP_ElijahsWill       = MakeEntityTable("Elijah's Will"),
    PICKUP_ElijahsWillB      = MakeEntityTable("Elijah's Will Birthright"),
    PICKUP_BurningHeart      = MakeEntityTable("Burning Heart"),
    PICKUP_DavidChord        = MakeEntityTable("David's Chord"),
    NPC_BlindedHorf          = MakeEntityTable("Blinded Horf"),
    NPC_Horfling             = MakeEntityTable("Horfling"),
    EFFECT_AndroidLazerRing  = MakeEntityTable("Android Lazer Ring"),
    EFFECT_KillerQueenRocket = MakeEntityTable("Killer Queen Rocket"),
    EFFECT_KillerQueenMark   = MakeEntityTable("Killer Queen Mark"),
    EFFECT_LACorpse          = MakeEntityTable("Lost Adventurer Corpse"),

    FAMILIAR_RedBum          = MakeEntityTable("Red Bum"),
    FAMILIAR_ScammerBum      = MakeEntityTable("Scammer Bum"),
    FAMILIAR_RuneBum         = MakeEntityTable("Rune Bum"),
    FAMILIAR_FairBum         = MakeEntityTable("Fair Bum"),
    FAMILIAR_TarotBum        = MakeEntityTable("Tarot Bum"),
	FAMILIAR_PillBum		 = MakeEntityTable("Pill Bum"),
    FAMILIAR_PastorBum       = MakeEntityTable("Pastor Bum"),
}

mod.Curses = {
    Unloved = Isaac.GetCurseIdByName("Curse of the Unloved!")
}

mod.Grid = {
    DavidPlate = MakeEntityTable("David Plate"),
}

mod.Challenges = {
    SoundOfSilence = Isaac.GetChallengeIdByName("The Worst Touch")
}

mod.Achievements = {
    --- Characters
    David              = Isaac.GetAchievementIdByName("David"),
    T_David            = Isaac.GetAchievementIdByName("Tainted David"),
    Elijah             = Isaac.GetAchievementIdByName("Elijah"),
    --- David's unlocks
    ArmyOfLovers       = Isaac.GetAchievementIdByName("Army of Lovers"),
    TheBadTouch        = Isaac.GetAchievementIdByName("The Bad Touch"),
    LittleLies         = Isaac.GetAchievementIdByName("Little Lies"),
    ParanoidAndroid    = Isaac.GetAchievementIdByName("Paranoid Android"),
    ShBoom             = Isaac.GetAchievementIdByName("Sh-boom!!"),
    Universal          = Isaac.GetAchievementIdByName("Universal"),
    EverybodysChanging = Isaac.GetAchievementIdByName("Everybody's Changing"),
    U2                 = Isaac.GetAchievementIdByName("U2"),
    KillerQueen        = Isaac.GetAchievementIdByName("Killer Queen"),
    RingOfFire         = Isaac.GetAchievementIdByName("Ring of Fire"),
    HelterSkelter      = Isaac.GetAchievementIdByName("Helter Skelter"),
    BabyBlue           = Isaac.GetAchievementIdByName("Baby Blue"),
    WonderOfYou        = Isaac.GetAchievementIdByName("Wonder of You"),
    Muse               = Isaac.GetAchievementIdByName("Muse"),

    --- Elijah's unlocks
    RuneBum            = Isaac.GetAchievementIdByName("Rune Bum"),
    PastorBum          = Isaac.GetAchievementIdByName("Pastor Bum"),
    TarotBum           = Isaac.GetAchievementIdByName("Tarot Bum"),
    RedBum             = Isaac.GetAchievementIdByName("Red Bum"),
    SacrificeTable     = Isaac.GetAchievementIdByName("Sacrifice Table"),
    PillBum            = Isaac.GetAchievementIdByName("Pill Bum"),
    LostAdventurer     = Isaac.GetAchievementIdByName("Lost Adventurer"),
    FamiliarsBeggar    = Isaac.GetAchievementIdByName("Familiars Beggar"),
    FiendDeal          = Isaac.GetAchievementIdByName("Fiend Deal"),
    JYS                = Isaac.GetAchievementIdByName("Junk Yard Seller"),
    FairBum            = Isaac.GetAchievementIdByName("Fair Bum"),
    Goldsmith          = Isaac.GetAchievementIdByName("Goldsmith Beggar"),
    ScammerBum         = Isaac.GetAchievementIdByName("Scammer Bum"),
    ChaosBeggar        = Isaac.GetAchievementIdByName("Chaos Beggar"),

    --- Tainted David's unlocks
    Mutter             = Isaac.GetAchievementIdByName("Mutter"),
    HypaHypa           = Isaac.GetAchievementIdByName("Hypa Hypa"),
    HolyWood           = Isaac.GetAchievementIdByName("Holy Wood"),
    LastResort         = Isaac.GetAchievementIdByName("Last Resort"),
    HereToStay         = Isaac.GetAchievementIdByName("Here to Stay"),
    Hysteria           = Isaac.GetAchievementIdByName("Hysteria"),

    --- Active items unlocks
    DevilsHeart        = Isaac.GetAchievementIdByName("Devil's Heart"),
    KingsHeart         = Isaac.GetAchievementIdByName("King's Heart"),
    SlingShot          = Isaac.GetAchievementIdByName("Sling Shot"),
    PersonalBeggar     = Isaac.GetAchievementIdByName("Personal Beggar"),

    --- Passive items unlocks
    GoldenDay          = Isaac.GetAchievementIdByName("Golden Day"),
    UltraSecretMap     = Isaac.GetAchievementIdByName("Ultra Secret Map"),
    CreatineOverdose   = Isaac.GetAchievementIdByName("Creatine Overdose"),
    PTSD               = Isaac.GetAchievementIdByName("PTSD"),
    StabWound          = Isaac.GetAchievementIdByName("Stab Wound"),
    MichelinStar       = Isaac.GetAchievementIdByName("Michelin Star Reward"),
    FloweringSkull     = Isaac.GetAchievementIdByName("Flowering Skull"),
    Echo               = Isaac.GetAchievementIdByName("Echo"),

    --- Trinkets unlocks
    Gaga               = Isaac.GetAchievementIdByName("Gaga"),

    --- Extra unlocks
    Cheater            = Isaac.GetAchievementIdByName("Cheater"),
    Speedrun1          = Isaac.GetAchievementIdByName("Speedrunner1"),
    GYM                = Isaac.GetAchievementIdByName("GYM"),
    Wimter             = Isaac.GetAchievementIdByName("Wimter"),
    SkillIssue1        = Isaac.GetAchievementIdByName("Skill Issue 1"),
    Ghosted            = Isaac.GetAchievementIdByName("Ghosted"),
}
