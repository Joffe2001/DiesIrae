Enums = {}

Enums.Players = {
    David                = Isaac.GetPlayerTypeByName("David"),
    --David_B = Isaac.GetPlayerTypeByName("David", true), -- if you add a tainted
}

Enums.Items = {
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
    BigKahunaBurger      = Isaac.GetItemIdByName("Big Kahuna Burger"),
    DadsEmptyWallet      = Isaac.GetItemIdByName("Dad's Empty Wallet"),
    BuriedTreasure       = Isaac.GetItemIdByName("Buried Treasure"),

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
    D8055                = Isaac.GetItemIdByName("D8055"),
    BigShot              = Isaac.GetItemIdByName("Big Shot")
}

Enums.Familiars = {
    ParanoidAndroid      = Isaac.GetItemIdByName("Paranoid Android")
}

Enums.Trinkets = {
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

Enums.Costumes = {
    David                = Isaac.GetCostumeIdByPath("gfx/characters/costume.david.anm2"),
    David_B              = Isaac.GetCostumeIdByPath("gfx/characters/costume.davidb.anm2")
}

Enums.Challenges = {
    SOUND_OF_SILENCE     = Isaac.GetChallengeIdByName("Sound of Silence")
}

Enums.Curses = {}

Enums.AchievementGraphics = {
    PlayerDavid = {
        MomsHeart = "achievement.",  -- gfx/ui/achievements/achievement.army_of_lovers.png
        Isaac = "achievement.",      
        BlueBaby = "achievement.baby_blue_unlock",   
        Satan = "achievement.",      
        Lamb = "achievement.paranoid_android_unlock",       
        MegaSatan = "achievement.sh_boom_unlock",  
        BossRush = "achievement.",   
        Hush = "achievement.everybodys_changing_unlock",      
        Beast = "achievement.u2_unlock",     
        Corpse = "achievement.",    
        UltraGreed = "achievement.wonder_of_you_unlock", 
        UltraGreedier = "achievement.", 
        Delirium = "achievement.helter_skelter_unlock",  
    }
}

return Enums
