---@class ModReference
local mod = DiesIraeMod

local function MakeEntityTable(name)
    return {Type = Isaac.GetEntityTypeByName(name),
            Var = Isaac.GetEntityVariantByName(name),
            SType = Isaac.GetEntitySubTypeByName(name)}
end

mod.Players = {
    David   = Isaac.GetPlayerTypeByName("David", false),
    TDavid  = Isaac.GetPlayerTypeByName("David", true),
    Elijah  = Isaac.GetPlayerTypeByName("Elijah", false),
    BatKol  = Isaac.GetPlayerTypeByName("Bat Kol", false),
}

mod.Items = {
    -- Passives
    U2                   = Isaac.GetItemIdByName("U2"),
    Muse                 = Isaac.GetItemIdByName("Muse"),
    TheBadTouch          = Isaac.GetItemIdByName("The Bad Touch"),
    Universal            = Isaac.GetItemIdByName("Universal"),
    RingOfFire           = Isaac.GetItemIdByName("Ring of Fire"),
    MomsDress            = Isaac.GetItemIdByName("Mom's Dress"),
    EnjoymentOfTheUnlucky= Isaac.GetItemIdByName("Enjoyment of the Unlucky"),
    EverybodysChanging   = Isaac.GetItemIdByName("Everybody's Changing"),
    Echo                 = Isaac.GetItemIdByName("Echo"),
    Engel                = Isaac.GetItemIdByName("Engel"),
    ScaredShoes          = Isaac.GetItemIdByName("Scared Shoes"),
    DevilsLuck           = Isaac.GetItemIdByName("Devil's Luck"),
    HereToStay           = Isaac.GetItemIdByName("Here to Stay"),
    ProteinPowder        = Isaac.GetItemIdByName("Protein Powder"),
    Hysteria             = Isaac.GetItemIdByName("Hysteria"),
    StabWound            = Isaac.GetItemIdByName("Stab Wound"),
    ThoughtContagion     = Isaac.GetItemIdByName("Thought Contagion"),
    GoldenDay            = Isaac.GetItemIdByName("Golden Day"),
    Mutter               = Isaac.GetItemIdByName("Mutter"),
    SolarFlare           = Isaac.GetItemIdByName("Solar Flare"),
    Psychosocial         = Isaac.GetItemIdByName("Psychosocial"),
    UltraSecretMap       = Isaac.GetItemIdByName("Ultra Secret Map"),
    RedCompass           = Isaac.GetItemIdByName("Red Compass"),
    LastResort           = Isaac.GetItemIdByName("Last Resort"),
    CreatineOverdose     = Isaac.GetItemIdByName("Creatine Overdose"),
    FragileEgo           = Isaac.GetItemIdByName("Fragile Ego"),
    BeggarsTear          = Isaac.GetItemIdByName("Beggar's Tear"),
    BigKahunaBurger      = Isaac.GetItemIdByName("Big Kahuna Burger"),
    DadsEmptyWallet      = Isaac.GetItemIdByName("Dad's Empty Wallet"),
    KoRn                 = Isaac.GetItemIdByName("Rainbow KoRn"),
    FiendDeal            = Isaac.GetItemIdByName("Fiend Deal"),
    BetrayalHeart        = Isaac.GetItemIdByName("Betrayal Heart"),
    StillStanding        = Isaac.GetItemIdByName("Still Standing"),
    Bloodline            = Isaac.GetItemIdByName("Bloodline"),
    BossCompass          = Isaac.GetItemIdByName("Boss Compass"),
    DevilsMap            = Isaac.GetItemIdByName("Devil's Map"),
    BorrowedStrength     = Isaac.GetItemIdByName("Borrowed Strength"),
    SymphonyOfDestr      = Isaac.GetItemIdByName("Symphony Of Destruction"),
    SweetCaffeine        = Isaac.GetItemIdByName("Sweet Caffeine"),
    PTSD                 = Isaac.GetItemIdByName("PTSD"),
    FloweringSkull       = Isaac.GetItemIdByName("Flowering Skull"),
    RewrappingPaper      = Isaac.GetItemIdByName("Rewrapping Paper"),
    FilthyRich           = Isaac.GetItemIdByName("Filthy Rich"),
    CoolStick            = Isaac.GetItemIdByName("Cool Stick"),
    Grudge               = Isaac.GetItemIdByName("Grudge"),
    BloodBattery         = Isaac.GetItemIdByName("Blood Battery"),

    -- Familiars
    ParanoidAndroid      = Isaac.GetItemIdByName("Paranoid Android"),
    KillerQueen          = Isaac.GetItemIdByName("Killer Queen"),

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
    BigShot              = Isaac.GetItemIdByName("Big Shot"),
    KingsHeart           = Isaac.GetItemIdByName("King's Heart"),
    BreakStuff           = Isaac.GetItemIdByName("Break Stuff"),
    PersonalBeggar       = Isaac.GetItemIdByName("Personal Beggar"),

    --TESTING
    Conscience           = Isaac.GetItemIdByName("Conscience"),
    PathOfTheRighteous   = Isaac.GetItemIdByName("Path Of The Righteous"),
    BackInAnger          = Isaac.GetItemIdByName("Back In Anger"),
    FriendlessChild      = Isaac.GetItemIdByName("Friendless Child"),
    Masochism            = Isaac.GetItemIdByName("Masochism"),
    TouristMap           = Isaac.GetItemIdByName("Tourist Map"),
    TravelerLogbook      = Isaac.GetItemIdByName("Traveler Logbook"),
    EyeSacrifice         = Isaac.GetItemIdByName("Eye Sacrifice"),
    SkullCrasher         = Isaac.GetItemIdByName("Skull Crasher"),
    DadsDumbbell         = Isaac.GetItemIdByName("Dad's Dumbbell"),
    SilentEcho           = Isaac.GetItemIdByName("Silent Echo"),
    PhotonLink           = Isaac.GetItemIdByName("Photon Link"),
    CloseCall            = Isaac.GetItemIdByName("Close Call!"),
    HitList              = Isaac.GetItemIdByName("Hit List"),
    Corona               = Isaac.GetItemIdByName("Corona"),
    TGS                  = Isaac.GetItemIdByName("Triple Gooberberry Sunrise"),
    ChallengerMap        = Isaac.GetItemIdByName("Challenger Map"),
    DeliriousMind        = Isaac.GetItemIdByName("Delirious Mind"),

    D8055                = Isaac.GetItemIdByName("D8055"),

    CorruptedMantle      = Isaac.GetItemIdByName("Corrupted Mantle"),

}

mod.Trinkets = {
    Gaga                 = Isaac.GetTrinketIdByName("Gaga"),
    BabyBlue             = Isaac.GetTrinketIdByName("Baby Blue"),
    WonderOfYou          = Isaac.GetTrinketIdByName("Wonder of You"),
    RottenFood           = Isaac.GetTrinketIdByName("Rotten Food"),
    SecondBreakfast      = Isaac.GetTrinketIdByName("Second Breakfast"),
    Papercut             = Isaac.GetTrinketIdByName("Papercut"),
    TarotBattery         = Isaac.GetTrinketIdByName("Tarot Battery"),

    --TESTING
    MoneyForNothing      = Isaac.GetTrinketIdByName("Money for nothing"),
    CatchTheRainbow      = Isaac.GetTrinketIdByName("Catch the Rainbow"),
    ClearVase            = Isaac.GetTrinketIdByName("Clear Vase"),
    FixedMetabolism      = Isaac.GetTrinketIdByName("Fixed Metabolism"),
    BrokenDream          = Isaac.GetTrinketIdByName("In a Broken Dream"),
    TrinketCollector     = Isaac.GetTrinketIdByName("Trinket Collector"),
}

mod.Pills = {
    CURSED        = Isaac.GetPillEffectByName("Cursed Pill"),
    BLESSED       = Isaac.GetPillEffectByName("Blessed Pill"),
    HEARTBREAK    = Isaac.GetPillEffectByName("Heartbreak Pill"),
    POWER_DRAIN   = Isaac.GetPillEffectByName("Power Drain Pill"),
    GULPING       = Isaac.GetPillEffectByName("Gulping Pill"),
    EQUAL         = Isaac.GetPillEffectByName("Equal Pill")
}

mod.Sounds ={
    JEVIL_CHAOS            = Isaac.GetSoundIdByName("Chaos chaos"),
    KILLER_QUEEN_DETONATE  = Isaac.GetSoundIdByName("Killer Queen Detonate"),
    KINGS_FART             = Isaac.GetSoundIdByName("King's Heart Fart")
}

mod.Music={
    TechBeggarWaiting      = Isaac.GetMusicIdByName("Tech Beggar Waiting"),
    Oiiai                  = Isaac.GetMusicIdByName("Oiiai"),
}

mod.Costumes = {
    David_Hair       = Isaac.GetCostumeIdByPath("gfx/characters/david_hair.anm2"),
    TDavid_Hair      = Isaac.GetCostumeIdByPath("gfx/characters/tdavid_hair.anm2"),
    Universal_active = Isaac.GetCostumeIdByPath("gfx/characters/universal_head.anm2"),
}

mod.Cards = {
    Locacaca         = Isaac.GetCardIdByName("Locacaca"),
    alpoh            = Isaac.GetCardIdByName("A Little Piece of Heaven"),
    StarShard        = Isaac.GetCardIdByName("Star Shard"),
    EnergyDrink      = Isaac.GetCardIdByName("Energy Drink"),
    DadsLottoTicket  = Isaac.GetCardIdByName("Dad's Lotto Ticket"),
}

mod.Entities = {
    FiendBeggar         = MakeEntityTable("Fiend Beggar"),
    TechBeggar          = MakeEntityTable("Tech Beggar"),
    GuppyBeggar         = MakeEntityTable("Guppy Beggar"),
    MamaHorf            = MakeEntityTable("Mama Horf"),
    Horfling            = MakeEntityTable("Horfling"),
    TechBeggarElijah    = MakeEntityTable("Tech Beggar Elijah"),
    BeggarElijah        = MakeEntityTable("Beggar Elijah"),
    BombBeggarElijah    = MakeEntityTable("Bomb Beggar Elijah"),
    KeyBeggarElijah     = MakeEntityTable("Key Beggar Elijah"),
    BatteryBeggarElijah = MakeEntityTable("Battery Beggar Elijah"),
    RottenBeggarElijah  = MakeEntityTable("Rotten Beggar Elijah"),
    MomBoxBeggarElijah  = MakeEntityTable("Mom's Chest Elijah"),
    BatKolGhost         = MakeEntityTable("Bat Kol's Ghosts"),
    RighteousGhost      = MakeEntityTable("Righteous Ghost"),
    ElijahsWill         = MakeEntityTable("Elijah's Will"),
    BurningHeart        = MakeEntityTable("Burning Heart"),
    ParanoidAndroid     = MakeEntityTable("Paranoid Android"),
    AndroidLazerRing    = MakeEntityTable("Android Lazer Ring"),
    KillerQueen         = MakeEntityTable("Killer Queen"),
    KillerQueenRocket   = MakeEntityTable("Killer Queen Rocket"),
    KillerQueenMark     = MakeEntityTable("Killer Queen Mark"),
}

mod.Curses = {
    Unloved             = Isaac.GetCurseIdByName("Curse of the Unloved!")
}

mod.Challenges = {
    SoundOfSilence       = Isaac.GetChallengeIdByName("Sound of Silence")
}

mod.Achievements = {
    --- Characters 
    David                 = Isaac.GetAchievementIdByName("David"),
    T_David               = Isaac.GetAchievementIdByName("Tainted David"),
    --- David's unlocks 
    ArmyOfLovers          = Isaac.GetAchievementIdByName("Army of Lovers"),
    TheBadTouch           = Isaac.GetAchievementIdByName("The Bad Touch"),
    LittleLies            = Isaac.GetAchievementIdByName("Little Lies"),
    ParanoidAndroid       = Isaac.GetAchievementIdByName("Paranoid Android"),
    ShBoom                = Isaac.GetAchievementIdByName("Sh-boom!!"),
    Universal             = Isaac.GetAchievementIdByName("Universal"),
    EverybodysChanging    = Isaac.GetAchievementIdByName("Everybody's Changing"),
    U2                    = Isaac.GetAchievementIdByName("U2"),
    KillerQueen           = Isaac.GetAchievementIdByName("Killer Queen"),
    RingOfFire            = Isaac.GetAchievementIdByName("Ring of Fire"),
    HelterSkelter         = Isaac.GetAchievementIdByName("Helter Skelter"),
    BabyBlue              = Isaac.GetAchievementIdByName("Baby Blue"),
    WonderOfYou           = Isaac.GetAchievementIdByName("Wonder of You"),
    Muse                  = Isaac.GetAchievementIdByName("Muse"),

    --- Tainted David's unlocks 
    Mutter               = Isaac.GetAchievementIdByName("Mutter"),
    HypaHypa             = Isaac.GetAchievementIdByName("Hypa Hypa"),
    HolyWood             = Isaac.GetAchievementIdByName("Holy Wood"),
    LastResort           = Isaac.GetAchievementIdByName("Last Resort"),
    HereToStay           = Isaac.GetAchievementIdByName("Here to Stay"),
    Hysteria             = Isaac.GetAchievementIdByName("Hysteria"),

    --- Passive items unlocks
    GoldenDay             = Isaac.GetAchievementIdByName("Golden Day"),

    --- Trinkets unlocks 
    Gaga                  = Isaac.GetAchievementIdByName("Gaga"),
}
