local mod = DiesIraeMod

mod.Players = {
    David = Isaac.GetPlayerTypeByName("David"),
    --David_B = Isaac.GetPlayerTypeByName("David", true), -- Waiting of Tainted
}

mod.Items = {
    -- Passives
    U2                   = Isaac.GetItemIdByName("U2"),
    Muse                 = Isaac.GetItemIdByName("Muse"),
    TheBadTouch          = Isaac.GetItemIdByName("The Bad Touch"),
    Universal            = Isaac.GetItemIdByName("Universal"),
    RingOfFire           = Isaac.GetItemIdByName("Ring of Fire"),
    KillerQueen          = Isaac.GetItemIdByName("Killer Queen"),
    MomsDress            = Isaac.GetItemIdByName("Mom's Dress"),
    EnjoymentOfTheUnlucky= Isaac.GetItemIdByName("Enjoyment of the Unlucky"),
    EverybodysChanging   = Isaac.GetItemIdByName("Everybody's Changing"),
    Echo                 = Isaac.GetItemIdByName("Echo"),
    Engel                = Isaac.GetItemIdByName("Engel"),
    ScaredShoes          = Isaac.GetItemIdByName("Scared Shoes"),
    DevilsLuck           = Isaac.GetItemIdByName("Devil's Luck"),
    HereToStay           = Isaac.GetItemIdByName("Here to Stay"),
    SkullCrasher         = Isaac.GetItemIdByName("Skull Crasher"),
    ProteinPowder        = Isaac.GetItemIdByName("Protein Powder"),
    Hysteria             = Isaac.GetItemIdByName("Hysteria"),
    StabWound            = Isaac.GetItemIdByName("Stab Wound"),
    ThoughtContagion     = Isaac.GetItemIdByName("Thought Contagion"),
    DadsDumbbell         = Isaac.GetItemIdByName("Dad's Dumbbell"),
    GoldenDay            = Isaac.GetItemIdByName("Golden Day"),
    Mutter               = Isaac.GetItemIdByName("Mutter"),
    SolarFlare           = Isaac.GetItemIdByName("Solar Flare"),
    EyeSacrifice         = Isaac.GetItemIdByName("Eye Sacrifice"),
    MonstersUnderTheBed  = Isaac.GetItemIdByName("Monsters Under The Bed"),
    TravelerLogbook      = Isaac.GetItemIdByName("Traveler Logbook"),
    UltraSecretMap       = Isaac.GetItemIdByName("Ultra Secret Map"),
    RedCompass           = Isaac.GetItemIdByName("Red Compass"),
    LastResort           = Isaac.GetItemIdByName("Last Resort"),
    SlaughterToPrevail   = Isaac.GetItemIdByName("Slaughter to Prevail"),
    CreatineOverdose     = Isaac.GetItemIdByName("Creatine Overdose"),
    FragileEgo           = Isaac.GetItemIdByName("Fragile Ego"),
    TouristMap           = Isaac.GetItemIdByName("Tourist Map"),
    BeggarsTear          = Isaac.GetItemIdByName("Beggar's Tear"),
    BackInAnger          = Isaac.GetItemIdByName("Back In Anger"),
    BossCompass          = Isaac.GetItemIdByName("Boss Compass"),
    FriendlessChild      = Isaac.GetItemIdByName("Friendless Child"),
    BuriedTreasureMap    = Isaac.GetItemIdByName("Buried Treasure Map"),
    GooglyEyes           = Isaac.GetItemIdByName("Googly Eyes"),
    Masochism            = Isaac.GetItemIdByName("Masochism"),
    Unsainted            = Isaac.GetItemIdByName("Unsainted"),
    BigKahunaBurger      = Isaac.GetItemIdByName("Big Kahuna Burger"),
    DadsEmptyWallet      = Isaac.GetItemIdByName("Dad's Empty Wallet"),

    -- Familiars
    ParanoidAndroid      = Isaac.GetItemIdByName("Paranoid Android"),

    -- Actives
    GuppysSoul           = Isaac.GetItemIdByName("Guppy's soul"),
    ArmyOfLovers         = Isaac.GetItemIdByName("Army of Lovers"),
    ShBoom               = Isaac.GetItemIdByName("Sh-boom!!"),
    HypaHypa             = Isaac.GetItemIdByName("Hypa Hypa"),
    HelterSkelter        = Isaac.GetItemIdByName("Helter skelter"),
    HolyWood             = Isaac.GetItemIdByName("Holy Wood"),
    DiaryOfAMadman       = Isaac.GetItemIdByName("Diary of a Madman"),
    ComaWhite            = Isaac.GetItemIdByName("Coma White"),
    GoodVibes            = Isaac.GetItemIdByName("Good Vibes"),
    DevilsHeart          = Isaac.GetItemIdByName("Devil's Heart"),
    MomsDiary            = Isaac.GetItemIdByName("Mom's Diary"),
    AnotherMedium        = Isaac.GetItemIdByName("Another Medium"),
    LittleLies           = Isaac.GetItemIdByName("Little Lies"),
    SatansRemoteShop     = Isaac.GetItemIdByName("Satan's Remote Shop"),
    BigShot              = Isaac.GetItemIdByName("Big Shot")
}

mod.Trinkets = {
    MoneyForNothing      = Isaac.GetTrinketIdByName("Money for nothing"),
    CatchTheRainbow      = Isaac.GetTrinketIdByName("Catch the Rainbow"),
    Gaga                 = Isaac.GetTrinketIdByName("Gaga"),
    FixedMetabolism      = Isaac.GetTrinketIdByName("Fixed Metabolism"),
    BabyBlue             = Isaac.GetTrinketIdByName("Baby Blue"),
    ClearVase            = Isaac.GetTrinketIdByName("Clear Vase"),
    WonderOfYou          = Isaac.GetTrinketIdByName("Wonder of You"),
    RottenFood           = Isaac.GetTrinketIdByName("Rotten Food"),
    TrinketCollector     = Isaac.GetTrinketIdByName("Trinket Collector"),
    SecondBreakfast      = Isaac.GetTrinketIdByName("Second Breakfast"),
    BrokenDream          = Isaac.GetTrinketIdByName("In a Broken Dream")
}

mod.Pills = {
    CURSED        = Isaac.GetPillEffectByName("Cursed Pill"),
    BLESSED       = Isaac.GetPillEffectByName("Blessed Pill"),
    HEARTBREAK    = Isaac.GetPillEffectByName("Heartbreak Pill"),
    LOVE          = Isaac.GetPillEffectByName("Love Pill"),
    POWER_DRAIN   = Isaac.GetPillEffectByName("Power Drain Pill"),
    ANGELIC       = Isaac.GetPillEffectByName("Angelic Pill"),
    GULPING       = Isaac.GetPillEffectByName("Gulping Pill"),
    EQUAL         = Isaac.GetPillEffectByName("Equal Pill"),
    USER          = Isaac.GetPillEffectByName("User Pill"),
}

mod.Costumes = {
    David_Hair = Isaac.GetCostumeIdByPath("gfx/characters/david_hair.anm2"),
}

mod.EntityVariant = {
    ParanoidAndroid  = Isaac.GetEntityVariantByName("Paranoid Android"),
    AndroidLazerRing = Isaac.GetEntityVariantByName("Android Lazer Ring"),
}

mod.Curses = {
    Unloved   = Isaac.GetCurseIdByName("Curse of the Unloved!")
}

mod.Achievements = {
    David              = Isaac.GetAchievementIdByName("David"),
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
}

mod.Challenges = {
    SoundOfSilence = Isaac.GetChallengeIdByName("Sound of Silence")
}
