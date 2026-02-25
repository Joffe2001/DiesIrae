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
    Elijah = Isaac.GetPlayerTypeByName("Elijah", false),
}

mod.Items = {
    -- Passives
    U2                    = Isaac.GetItemIdByName("U2"),
    Muse                  = Isaac.GetItemIdByName("Muse"),
    TheBadTouch           = Isaac.GetItemIdByName("The Bad Touch"),
    Universal             = Isaac.GetItemIdByName("Universal"),
    RingOfFire            = Isaac.GetItemIdByName("Ring of Fire"),
    EverybodysChanging    = Isaac.GetItemIdByName("Everybody's Changing"),
    Echo                  = Isaac.GetItemIdByName("Echo"),
    ProteinPowder         = Isaac.GetItemIdByName("Protein Powder"),
    GoldenDay             = Isaac.GetItemIdByName("Golden Day"),
    CreatineOverdose      = Isaac.GetItemIdByName("Creatine Overdose"),
    FiendDeal             = Isaac.GetItemIdByName("Fiend Deal"),
    PTSD                  = Isaac.GetItemIdByName("PTSD"),
    FloweringSkull        = Isaac.GetItemIdByName("Flowering Skull"),
    HarpString            = Isaac.GetItemIdByName("Harp String"),
    Harp                  = Isaac.GetItemIdByName("The Harp"),
    MichelinStar          = Isaac.GetItemIdByName("Michelin Star Reward"),

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
    ArmyOfLovers          = Isaac.GetItemIdByName("Army of Lovers"),
    ShBoom                = Isaac.GetItemIdByName("Sh-boom!!"),
    HelterSkelter         = Isaac.GetItemIdByName("Helter skelter"),
    LittleLies            = Isaac.GetItemIdByName("Little Lies"),
    SlingShot             = Isaac.GetItemIdByName("Sling Shot"),
    KingsHeart            = Isaac.GetItemIdByName("King's Heart"),
    PersonalBeggar        = Isaac.GetItemIdByName("Personal Beggar"),
}

mod.Trinkets = {
    Gaga             = Isaac.GetTrinketIdByName("Gaga"),
    BabyBlue         = Isaac.GetTrinketIdByName("Baby Blue"),
    WonderOfYou      = Isaac.GetTrinketIdByName("Wonder of You"),
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
    --Actually OST
    DrowningInSorrow  = Isaac.GetMusicIdByName("Drowning in Sorrow"),
    
    --Random stuff
    TechBeggarWaiting = Isaac.GetMusicIdByName("Tech Beggar Waiting"),
    Oiiai             = Isaac.GetMusicIdByName("Oiiai"),
    GigaChad          = Isaac.GetMusicIdByName("GigaChad"),
}

mod.Costumes = {
    David_Hair       = Isaac.GetCostumeIdByPath("gfx/characters/david_hair.anm2"),
    TDavid_Hair      = Isaac.GetCostumeIdByPath("gfx/characters/tdavid_hair.anm2"),
    Universal_active = Isaac.GetCostumeIdByPath("gfx/characters/universal_head.anm2"),
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
    DavidChord      = Isaac.GetCardIdByName("David's Chord"),
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

mod.Achievements = {
    --- Characters
    David              = Isaac.GetAchievementIdByName("David"),
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

    --- Active items unlocks
    KingsHeart         = Isaac.GetAchievementIdByName("King's Heart"),
    SlingShot          = Isaac.GetAchievementIdByName("Sling Shot"),
    PersonalBeggar     = Isaac.GetAchievementIdByName("Personal Beggar"),

    --- Passive items unlocks
    GoldenDay          = Isaac.GetAchievementIdByName("Golden Day"),
    CreatineOverdose   = Isaac.GetAchievementIdByName("Creatine Overdose"),
    PTSD               = Isaac.GetAchievementIdByName("PTSD"),
    MichelinStar       = Isaac.GetAchievementIdByName("Michelin Star Reward"),
    FloweringSkull     = Isaac.GetAchievementIdByName("Flowering Skull"),
    Echo               = Isaac.GetAchievementIdByName("Echo"),

    --- Trinkets unlocks
    Gaga               = Isaac.GetAchievementIdByName("Gaga"),

}
