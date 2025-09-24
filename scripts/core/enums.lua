local enums = {}

enums.Players = {
    David = Isaac.GetPlayerTypeByName("David"),
    --David_B = Isaac.GetPlayerTypeByName("David", true), -- if you add a tainted
}

enums.Items = {
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
    BigShot              = Isaac.GetItemIdByName("Big Shot"),
    BeggarsTear          = Isaac.GetItemIdByName("Beggar's Tear"),

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
    RedMap               = Isaac.GetItemIdByName("Red Map"),
    DevilsHeart          = Isaac.GetItemIdByName("Devil's Heart"),
    MomsDiary            = Isaac.GetItemIdByName("Mom's Diary"),
    AnotherMedium        = Isaac.GetItemIdByName("Another Medium"),
    LittleLies           = Isaac.GetItemIdByName("Little Lies"),
    SatansRemoteShop     = Isaac.GetItemIdByName("Satan's Remote Shop"),
}

enums.Trinkets = {
    MoneyForNothing      = Isaac.GetTrinketIdByName("Money for nothing"),
    CatchTheRainbow      = Isaac.GetTrinketIdByName("Catch the Rainbow"),
    Gaga                 = Isaac.GetTrinketIdByName("Gaga"),
    FixedMetabolism      = Isaac.GetTrinketIdByName("Fixed Metabolism"),
    BabyBlue             = Isaac.GetTrinketIdByName("Baby Blue"),
    ClearVase            = Isaac.GetTrinketIdByName("Clear Vase"),
    WonderOfYou          = Isaac.GetTrinketIdByName("Wonder of You"),
    RottenFood           = Isaac.GetTrinketIdByName("Rotten Food"),
}

enums.Costumes = {
    David = Isaac.GetCostumeIdByPath("gfx/characters/costume.david.anm2"),
    David_B = Isaac.GetCostumeIdByPath("gfx/characters/costume.davidb.anm2"),
}

enums.AchievementGraphics = {
    PlayerDavid = {
        MomsHeart = "achievement.army_of_lovers",  -- gfx/ui/achievements/achievement.army_of_lovers.png
        Isaac     = "achievement.something_else",
        Satan     = "achievement.something_else2",
    }
}

return enums
