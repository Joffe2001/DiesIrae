--------------------------------------------------------
----Syntax----
---https://github.com/wofsauge/External-Item-Descriptions/wiki/Markup
---
---stat changes are always indicated by ↑ or ↓
---!make sure to know the difference between Tears up and Fire rate up!
---!don't use functions in descriptions (e.g. change the damage number of a familiar if isaac has bff)!
--↑ +[change_amount > 1] [stat(Health/Speed/Tears/Fire rate/Damage/Range/Shot speed/Luck)]
--↓ -[change_amount < 1] [stat]
--↑ x[multiplier_amount > 0] [stat] multiplier
--↓ x[multiplier_amount < 0] [stat] multiplier
--
--{{[pickup]}} [pickup related effect]
--{{HealingRed}} full health
--
---Luck based effects:
--{{[fitting Icon]}} [effect]
--{{Luck}} [change of effect]
--
---stay with often used phrases like "When taking damage, receive..." or "Taking damage has a chance to..."
---don't talk directly to the reader ("holding the fire button" instead of "hold the fire button to")
---try to not use words like "is", "are", "will"
---look at the descriptions found in the folders of the External Item Description mod!
---icons schould be surounded by a space character if in text
---icons are not often needed! only use them if fitting
--------------------------------------------------------

---@class ModReference
local mod = DiesIraeMod

----------------------------------------------------------------------------------------------------------
--Shenanigans Explanation

--Firstly, you don't need to place "#" symbol at the start of each string, eid.lua does that automatically

--You can put in the description table either a string, a function or a table

--String - will be inserted into the in-game description no matter what

--Function(return string) - will be called each frame on description rendering, returned string 
--will be inserted into the in-game description no matter what
--DescObject and ClosestPlayer args are passed to the function

--Table - contains 2 functions with DescObject and ClosestPlayer args passed to them:
--  First(return boolean) - will be called each frame on description rendering, returned bool will
--  determine if the second function will be called

--  Second(return string) - will be called on description rendering if the first function returns true,
--  returned string will be inserted into the in-game description
----------------------------------------------------------------------------------------------------------

mod.EIDescs = {
	Collectible = {
		EIDadd = function(...) EID:addCollectible(...) end,
--------------------------------------------------------
--Passive items
--------------------------------------------------------    
		[mod.Items.U2] = {
			en_us = { 
                "↑ +0.2 Damage",
                "↑ +0.2 Tears",
                "↑ +0.2 Speed",
                "↑ +0.2 Range",
                "↑ +0.2 Luck",
                "↑ +0.2 Shot Speed"
            },
            ru = { 
                "↑ +0.2 Урона",
                "↑ +0.2 Слёзы",
                "↑ +0.2 Скорости",
                "↑ +0.2 Дальности",
                "↑ +0.2 Удачи",
                "↑ +0.2 Скорости Слезы"
            },
		},
		[mod.Items.Muse] = {
			en_us = { 
                "Taking a pickup has a chance to spawn another",
                "Taking a collectible has a chnce to spawn the same one",
            },
		},
		[mod.Items.TheBadTouch] = {
			en_us = { 
                "Kill non-boss enemies on contact",
                "{{Poison}} Poison bosses on contact"
            },
            ru = { 
                "Убийство врагов не-боссов при контакте",
                "{{Poison}} Отравляет боссов при контакте"
            }
		},
		[mod.Items.Universal] = {
			en_us = { 
                "Hold and release fire button to absorb projectiles near Isaac",
                "For each absorbed projectile a beam of light will spawn"
            },
            ru = { 
                "Зажмите и отпустите кнопку стрельбы чтобы поглотить снаряды вблизи Исаака",
                "За каждый поглощённый снаряд появится луч света"
            }
		},
		[mod.Items.RingOfFire] = {
			en_us = { 
                "Spawns 6 Center ring Fire Wisps",
                "{{Burning}} Fire Wisps burn enemies on contact",
				"Fire Wisps are unable to shoot",
                "Upon clearing a room, add 1 fire wisp",
            },
            ru = { 
                "Создаёт кольцо из 6 Огоньков",
                "{{Burning}} Огоньки поджигают врагов при контакте",
                "Огоньки не могут стрелять",
                "Даёт один огонёк после зачистки комнаты",
            },
		},
		[mod.Items.MomsDress ] = {
			en_us = {
                "{{RottenHeart}} Spawns 2 Rotten Hearts",
				"{{HolyMantle}} 30% chance to grant a Holy Mantel shield for the room",
				"each additional copie increases the chance by 10%"
            },
            ru = {
                "{{RottenHeart}} Создаёт 2 Гнилых Сердца",
                "{{HolyMantle}} 30% шанс дать эффект Святой Мантии на комнату",
                "каждая дополнительная копия увеличивает шанс на 10%"
            }
		},
		[mod.Items.EnjoymentOfTheUnlucky] = {
			en_us = { 
                "{{Luck}} Each point of negative luck grants:",
                "↑ +0.4 Damage",
                "↑ +0.1 Speed",
                "↑ +0.2 Range",
                "↑ +0.05 Shot Speed",
                "↓ -0.7 Fire Delay"
            },
            ru = { 
                "{{Luck}} За каждую отрицательную удачу даёт:",
                "↑ +0.4 Урона",
                "↑ +0.1 Скорости",
                "↑ +0.2 Дальности",
                "↑ +0.05 Скорости Слезы",
                "↓ -0.7 Задержки Выстрела"
            }
		},
		[mod.Items.EverybodysChanging] = {
			en_us = { 
                "Randomize all passive items on room clear"
            },
            ru = { 
                "Рандомизирует все пассивные предметы при зачистке комнаты"
            }
		},
		[mod.Items.Echo] = {
            en_us = { 
                "{{Planetarium}} +25% Planetarium chance",
				"+10% after womb" --per floor? gives +25 pre womb and only +10 after?
            },
            ru = { 
                "{{Planetarium}} +25% шанс Планетария",
				"+10% после Матки"
            }
        },
        [mod.Items.Engel] = {
            en_us = { 
                "↑ +5 Luck",
                "Grants spectral and homing tears",
                "Disables Flight"
            },
            ru = { 
                "↑ +5 Удачи",
                "Даёт спектральные и самонаводящиеся слёзы",
                "Отключает Полёт"
            }
        },
        [mod.Items.ScaredShoes] = {
            en_us = { 
                "↑ Sets speed to 2 in non-hostile rooms",
				"Randomly spawns small, yellow creep in hostile rooms"
            },
            ru = { 
                "↑ Устанавливает скорость на 2 в зачищенных комнатах",
                "Случайно создаёт маленькую, жёлтую лужу в незачищенных комнатах"
            }
        },
        [mod.Items.DevilsLuck] = {
            en_us = { 
                "↓ -6 Luck",
                "50% chance for pickups to vanish",
                "↑ +0.05 Damage per vanished pickup"
            },
            ru = { 
                "↓ -6 Удачи",
                "50% шанс на исчезновение подбираемого предмета",
                "↑ +0.05 Урона за каждый исчезнувший предмет"
            }
        },
        [mod.Items.HereToStay] = {
            en_us = {  
                "Spawns creep when standing still",
                "Creep grows while standing still"
            },
            ru = {  
                "Стоя неподвижно создаёт лужу",
                "Лужа растёт без движения"
            }
        },
        [mod.Items.ProteinPowder] = {
            en_us = { -- not done
                "↑ +1 Damage",
                "Future copies will grant +1 damage for each collected copy",
				"This effect stops after the fourth copy"
            },
            ru = { -- не готово
                "↑ +1 Урон",
                "Следующие копии дадут +1 урон за каждую",
                "После 4 копии не даёт ничего"
            },
        },
        [mod.Items.Hysteria] = {
            en_us = { 
                "Taking damage twice doubles damage for the room",
                "{{BrokenHeart}} Taking damage an additional time in the room removes the effect and grants a Broken Heart",
                "{{BrokenHeart}} Taking damage an additional time in the room grants a Broken Heart and doubles the Tear Rate for the room",
            },
            ru = { 
                "При получении урона дважды удваивает урон на комнату",
                "{{BrokenHeart}} Получение урона ещё раз в комнате убирает эффект и даёт Разбитое Сердце",
                "{{BrokenHeart}} Получение урона ещё раз в комнате даёт Разбитое Сердце и удваивает Скорострельность на комнату",
            },
        },
        [mod.Items.StabWound] = {
            en_us = { 
                "↑ +1 Damage",
                "↑ +0.5 Tears"
            },
            ru = { 
                "↑ +1 Урон",
                "↑ +0.5 Слёзы"
            }
        },
        [mod.Items.ThoughtContagion] = {
            en_us = { 
				"Enemies mirror pure damage to nearby enemies"
            },
            ru = { 
                "Враги отражают чистый урон на ближайших врагов"
            }
        },
        [mod.Items.GoldenDay] = {
            en_us = { 
                "Spawns a golden pickup",
                "{{SecretRoom}} 50% chance to spawn a golden pickup in the secret room"
            },
            ru = { 
                "Создаёт золотой подбираемый предмет",
                "{{SecretRoom}} 50% шанс создать золотой подбираемый предмет в секретной комнате"
            }
        },
        [mod.Items.Mutter] = { --outdated description? rework coming?
            en_us = { 
                "↑ +0.3 Speed",
                "↑ Increased chance to find Mom's items, Dr. Fetus and C-Section",
                "Stats up for each Mom item:",
                "↑ +0.5 Damage",
                "↑ +1 Luck",
                "↑ +0.05 Speed",
                "↓ -0.3 Tear Delay"
            },
            ru = { 
                "↑ +0.3 Скорости",
                "↑ Увеличенный шанс найти предметы {{Mom}}Мамы, Доктора Зародыша и Кесарево",
                "Повышение характеристик за каждый предмет Мамы:",
                "↑ +0.5 Урона",
                "↑ +1 Удачи",
                "↑ +0.05 Скорости",
                "↓ -0.3 Задержки Выстрела"
            }
        },
        [mod.Items.SolarFlare] = {
            en_us = { 
                "Tears get fired at low shot speed",
				"{{Timer}} Tears dash towards the nearest enemy after 0.2 seconds",
				"Tears leave a trail of fire",
                "{{Burning}} Tears burn enemies on hit"
            },
            ru = { 
                "Слёзы медленные при выстреле",
                "{{Timer}} Слёзы ускоряются к ближайшему врагу после 0.2 секунды",
                "Слёзы оставляют огненный след",
                "{{Burning}} Слёзы поджигают врагов при контакте"
            }
        },
        [mod.Items.Psychosocial] = {
            en_us = { 
                "↓ -0.5 Tears per enemy in the room"
            },
            ru = { 
                "↓ -0.5 Слёзы за каждого врага в комнате"
            }
        },
        [mod.Items.UltraSecretMap] = {
            en_us = { 
                "{{UltraSecretRoom}} Reveals ultra secret room locations on the map",
                "{{Card78}} Spawns a cracked key in the secret room"
            },
            ru = { 
                "{{UltraSecretRoom}} Показывает Ультра Секретную Комнату на карте",
                "{{Card78}} Создаёт Треснувший Ключ в Секретной Комнате"
            }
        },
        [mod.Items.RedCompass] = {
            en_us = { 
                "Chance to open an adjacent red room on room clear"
            },
            ru = { 
                "Шанс открыть красную комнату рядом при зачистке комнаты"
            }
        },
        [mod.Items.LastResort] = {
            en_us = { 
				"Grants a permanent stat change upon clearing a room with half a heart",
                "↑ +0.3 Damage",
                "↑ +0.1 Speed",
                "↓ -0.3 Tears"
            },
            ru = { 
                "Зачистка комнаты на половине сердца даёт характеристику навсегда:",
                "↑ +0.3 Урона",
                "↑ +0.1 Скорости",
                "↓ -0.3 Слёзы"
            }
        },
        [mod.Items.CreatineOverdose] = {
            en_us = { 
                "↑ +0.2 Damage",
                "↑ 1.2x Damage multiplier"
            },
            ru = { 
                "↑ +0.2 Урона",
                "↑ 1.2x Множитель Урона"
            }
        },
        [mod.Items.FragileEgo] = {
            en_us = { 
                "Grants a stat up upon clearing a room",
				"Taking damage resets the effect",
				"{{BrokenHeart}} Taking damage has a chance to grant a Broken Heart"
            },
            ru = { 
                "При зачистке комнаты даёт повышение характеристики",
                "Получение урона сбрасывает эффект",
                "{{BrokenHeart}} Шанс получить Разбитое Сердце при получении урона"
            }
        },
        [mod.Items.BeggarsTear] = {
            en_us = { 
                "Tears collect pickups",
				"Tears push consumables towards isaac"
            },
            ru = { 
                "Слёзы подбирают предметы",
                "Слёзы притягивают расходники к Исааку"
            }
        },
        [mod.Items.KoRn] = {
            en_us = { 
                "10% chance to shoot a colored tear",
				"Colored tears create status effects inflicting mist"
            },
            ru = { 
                "10% шанс выстрелить цветной слезой",
                "Цветные слёзы создают облака, накладывающие эффекты"
            }
        },
        [mod.Items.BackInAnger] = {
            en_us = { 
                "Tears are fired from your bag (based on moving)",
                "↑ +4 Damage"
            },
            ru = { 
                "Стрельба сзади (зависит от направления движения)",
                "↑ +4 Урона"
            }
        },
        [mod.Items.BigKahunaBurger] = {
            en_us = { 
                "↑ +1 to 3 Health"
            },
            ru = { 
                "↑ +1-3 Здоровья"
            }
        },
        [mod.Items.DadsEmptyWallet] = {
            en_us = { 
                "↑ +1 Tears",
                "↓ -0.02 Tears for every {{coin}} coin Isaac has stopping at -1 Tears"
            },
            ru = { 
                "↑ +1 Слёзы",
                "↓ -0.02 Слёз за каждую {{coin}} монету у Исаака до -1 Слёзы"
            },
        },
        [mod.Items.FiendDeal] = {
            en_us = { 
                "Spawns a fiend beggar in the first room on every floor who leaves if the player leaves the room",
				"Interacting with the beggar spawns two devil items on the next floor",
				"{{Warning}} Interacting with the beggar results in Isaac dying in one hit for the floor"
            },
            ru = { 
                "Создаёт Попрошайку-Изверга в первой комнате каждого этажа, который исчезает, если игрок покинет комнату",
                "Взаимодействие с Попрошайкой создаст 2 Дьявольских предмета на следующем этаже",
                "{{Warning}} После взаимодействия с Попрошайкой Исаак умрёт от одного удара на этаже"
            },
        },
        [mod.Items.Bloodline] = {
            en_us = {
				"Enemies mirror damage to enemies of the same type"
            },
            ru = { 
                "Враги отражают урон на врагов того же типа"
            },
        },
        [mod.Items.BetrayalHeart] = {
            en_us = { 
                "{{BrokenHeart}} +1 Broken Heart",
                "↑ +1 damage up for every {{BrokenHeart}} Broken Heart"
            },
            ru = { 
                "{{BrokenHeart}} +1 Разбитое Сердце",
                "↑ +1 Урон за каждое {{BrokenHeart}} Разбитое Сердце"
            },
        },
        [mod.Items.StillStanding] = {
            en_us = { 
                "↑ While standing still damage keeps increasing",
				"Caps at +4 damage"
            },
            ru = { 
                "↑ Стоя на месте урон увеличивается",
                "До +4 урона"
            },
        },
        [mod.Items.BossCompass] = {
            en_us = { 
                "Reveals the location of all Boss {{BossRoom}} and {{MiniBoss}} Mini-boss rooms",
                "↑ +0.2 Damage for each Boss defeated",
                "↑ +0.1 Damage for each Mini-boss defeated"
            },
            ru = { 
                "Показывает все комнаты {{BossRoom}} Босса и {{MiniBoss}} Мини-босса на карте",
                "↑ +0.2 Урона за победу над Боссом",
                "↑ +0.1 Урона за победу над Мини-боссом"
            },
        },
        [mod.Items.DevilsMap] = {
            en_us = { 
				"Reveales the location of all {{SacrificeRoom}} Sacrifice and {{CursedRoom}} Curse rooms",
				"↑ +0.6 Tears for visiting Sacrivice, Curse and Devil deal rooms"
            },
            ru = { 
                "Показывает все комнаты {{SacrificeRoom}} Жертвоприношения и {{CursedRoom}} Проклятые комнаты на карте",
                "↑ +0.6 Слёзы за посещение комнаты Жертвоприношения, Сделки с Дьяволом и Проклятую комнату"
            },
        },
        [mod.Items.BorrowedStrength] = {
            en_us = { 
                "↑ +2 Damage",
                "{{Warning}} Lose half your health upon entering a new floor"
            },
            ru = { 
                "↑ +2 Урона",
                "{{Warning}} Исаак теряет половину своего здоровья при переходе на новый этаж"
            },
        },
        [mod.Items.SymphonyOfDestr] = {
            en_us = { 
				"{{Card}} Turns all Cards into {{Card17}} The Tower"
            },
            ru = { 
                "{{Card}} Все карты превращаются в {{Card17}} Башню"
            },
        },
        [mod.Items.SweetCaffeine] = {
            en_us = { 
				"Spawns Energy Drink",
                "Increase chance for Energy Drink to spawn"
            },
            ru = { 
                "Создаёт Энергетик",
                "Больше шанс найти Энергетик"
            },
        },
        [mod.Items.PTSD] = {
            en_us = { 
				"{{BossRoom}} Entering a boss room grants +0.2 tears for each time the boss killed the player before"
            },
            ru = { 
                "{{BossRoom}} При заходе в комнату босса даёт +0.2 слёзы за каждую смерть от этого босса"
            },
        },
        [mod.Items.FloweringSkull] = {
            en_us = { 
				"Revives Isaac with 2 heart containers in the same room dealing 40 damage to all enemies and rerolling all passive items"
            },
            ru = { 
                "Возрождает Исаака с 2 контейнерами сердец в текущей комнате, нанося 40 урона всем врагам и меняя все пассивные предметы"
            },
        },
        [mod.Items.RewrappingPaper] = {
            en_us = { 
				"{{TreasureRoom}} All Treasure Room items are replaced with {{Collectible515}} Mystery gift"
            },
            ru = { 
                "{{TreasureRoom}} Все предметы в Сокровищнице заменяются {{Collectible515}} Загадочным Подарком",
            },
        },
        [mod.Items.FilthyRich] = {
            en_us = { 
				"{{Poison}} Chance to shoot poison tears and to spawn poison mist",
				"{{Coin}} Holding coins increases the chance"
            },
            ru = { 
                "{{Poison}} Шанс выстрелить отравляющей слезой и создать отравляющее облако",
                "{{Coin}} Держа монеты шанс увеличивается"
            },
        },
        [mod.Items.CoolStick] = {
            en_us = { 
                "↑ +0.4 Damage",
                "↑ +1 Luck",
                "{{WoodenChest}} 15% chance to turn chests into wooden chests",
            },
            ru = { 
                "↑ +0.4 Урона",
                "↑ +1 Удача",
                "{{WoodenChest}} 15% шанс заменить сундуки на деревянные сундуки",
            },
        },
        [mod.Items.Grudge] = {
            en_us = { 
				"{{DeathMark}} Taking damage markes the responsible enemy type",
				"Marked enemies take double damage"
            },
            ru = { 
                "{{DeathMark}} Получение урона помечает тип нанёсшего его врага",
                "Помеченные враги получают двойной урон"
            },
        },
        [mod.Items.BloodBattery] = {
            en_us = { 
                "{{Battery}} Taking damage has a chance to spawn a battery"
            },
            ru = { 
                "{{Battery}} Шанс создать батарейку при получении урона"
            },
        },
        [mod.Items.DeliriousMind] = {
            en_us = { 
				"↑ Increase Damage and Tears by 0.15 for every modded item"
            },
            ru = { 
                "↑ +0.15 Урона и Слёзы за каждый предмет из модов"
            },
        },
        [mod.Items.CorruptedMantle] = {
            en_us = { 
				"{{HolyMantle}} Grants Holy Mantle",
				"↑ +0.1 Speed",
				"↑ +3 Luck",
				"↑ x1.5 damage multiplier",
				"{{Warning}} Losing Holy Mantle removes the damage multiplier for the room",
				"{{Warning}} Taking damage results in:",
				"↓ x0.3 damage multiplier",
				"↓ -5 luck",
				"{{BrokenHeart}} +2 Broken Hearts"
            },
            ru = { 
                "{{HolyMantle}} Даёт Святую Мантию",
                "↑ +0.1 Скорости",
                "↑ +3 Удачи",
                "↑ x1.5 множитель урона",
                "{{Warning}} При потере щита множитель урона пропадёт на комнату",
                "{{Warning}} При последующем получении урона:",
                "↓ x0.3 множитель урона",
                "↓ -5 удачи",
                "{{BrokenHeart}} +2 Разбитых Сердца"
            }
        },
        [mod.Items.HarpString] = {
            en_us = { 
				"↑ +1 Item pedestal in the Treasure room"
            },
        },
        [mod.Items.Harp] = {
            en_us = { 
				"↑ +0.15 damage multiplier for every passive item",
                "Not including the Harp or Harp strings"
            },
        },
        [mod.Items.MichelinStar] = {
            en_us = { 
				"Spawn two golden hearts on pickup",
                "Spawn two golden hearts when picking up food item"
            },
        },
		[mod.Items.RedBulb] = {
			en_us = {
				"Inverts all Devil and Angel Rooms into angelic Devil and demonic Angel Rooms",
				"{{DevilRoom}} Take only one item but for free",
				"{{AngelRoom}} Take multiple items but cost Broken Hearts",
				{
					function()
						return EID:PlayersHaveCollectible(CollectibleType.COLLECTIBLE_SANGUINE_BOND)
					end,
					function()
						return "{{Collectible692}} Spawns a Confessional in demonic Angel Rooms"
					end
				},
				{
					function()
						return EID:PlayersHaveCollectible(CollectibleType.COLLECTIBLE_STAIRWAY)
					end,
					function()
						return "{{Collectible586}} Becomes a demonic Stairway"
					end
				},
			},
		},
--------------------------------------------------------
--Familiars
--------------------------------------------------------    
[mod.Items.ParanoidAndroid] = {
    en_us = { 
        "Shoots a static laser around itself",
    },
    ru = { 
        "Создаёт статический лазер вокруг себя",
    }
},
[mod.Items.KillerQueen] = {
    en_us = { 
        "Fires rockets at enemies"
    },
    ru = { 
        "Стреляет ракетами во врагов"
    }
},
[mod.Items.RedBum] = {
    en_us = { 
        "{{Key}} Picks up nearby Keys",
        "Has a chance to spawn Cracked Key"
    },
},
[mod.Items.ScammerBum] = {
    en_us = { 
        "{{Coin}} Picks up nearby pennies",
        "Has a chance to spawn a purchable item"
    },
},
[mod.Items.RuneBum] = {
    en_us = { 
        "{{Rune}} Picks up nearby runes",
        "Has a chance to spawn a Q 0-2 pedestal"
    },
},
[mod.Items.FairBum] = {
    en_us = { 
        "Takes the pickup Isaac has the most of",
        "Has a chance to drop the pickup Isaac has the least of"
    },
},
--------------------------------------------------------
--Active items
--------------------------------------------------------    
[mod.Items.AnotherMedium] = { 
    en_us = { 
        "Rerolls one passive item",
        "Can only be used once per floor"
    },
    ru = { 
        "Меняет один пассивный предмет",
        "Только раз за этаж"
    }
},
[mod.Items.ArmyOfLovers] = {
    en_us = {   
        "Spawns 2 Minisaacs",
        "{{Heart}} 12% chance to spawn 5 rewards",
        "{{Luck}} +0.5% chance per Luck: Minimum chance at 8% and maximum chance at 20%",
        "For each reward:",
        "{{Heart}} 50% for full red heart",
        "{{Card}} 50% for Lovers Card",
        "{{Player1}} {{Player22}} 75% for Lovers Card",
        "{{BrokenHeart}} Each Lovers Card has a  1% chance to transform into Reversed Lovers:",
        "{{CurseDarkness}} Curse: +10%",
        "{{Collectible316}} Cursed Eye: +15%",
        "{{CursedRoom}} In Cursed Room: +10%",
        "{{Collectible260}} Black Candle: -100%"
    },
    ru = {   
        "Создаёт 2 Мини-Исааков",
        "!!! outdated description"
    }
},
[mod.Items.SlingShot] = {
    en_us = {
        "Shoots a large piercing tear which destroys rocks",
        "Tear explodes on wall impact",
    },
    ru = {
        "Стреляет огромной пронзающей слезой, ломающей камни",
        "Слеза взрывается при столкновении со стеной",
    }
},
[mod.Items.GuppysSoul] = {
    en_us = {
        "{{Guppy}} Grants Guppy transformation for the room"
    },
    ru = {
        "{{Guppy}} Даёт превращение Гаппи на комнату"
    }
},

[mod.Items.ShBoom] = {
    en_us = {
        "{{Collectible483}} Activates Mama Mega!",
        "{{BrokenHeart}} +1 Broken Heart",
        "Can only be used once per floor"
    },
    ru = {
        "{{Collectible483}} Активирует Мама Мега!",
        "{{BrokenHeart}} +1 Разбитое Сердце",
        "Только раз за этаж",
    }
},

[mod.Items.HypaHypa] = {
    en_us = {
        "{{Warning}} SINGLE USE {{Warning}}",
        "{{Quality4}} 30% chance to spawn a Quality 4",
        "{{Collectible36}} 70% chance to spawn The Poop",
    },
    ru = {
        "{{Warning}} ОДНОРАЗОВЫЙ {{Warning}}",
        "{{Quality4}} 30% шанс создать предмет 4-го качества",
        "{{Collectible36}} 70% шанс создать Какашку",

    }
},

[mod.Items.HelterSkelter] = {
    en_us = {
        "25% chance for each enemy to turn into a friendly Bony"
    },
    ru = {
        "25% шанс превратить каждого врага в дружественного Костяшку"
    }
},

[mod.Items.HolyWood] = {
    en_us = {
        "{{HolyMantle}} Grants Holy Mantle for the current room"
    },
    ru = {
        "{{HolyMantle}} Даёт Святую Мантию на комнату"
    }
},

[mod.Items.DiaryOfAMadman] = {
    en_us = {
        "Randomizes all stats for the current room"
    },
    ru = {
        "Рандомизирует характеристики на комнату"
    }
},

[mod.Items.ComaWhite] = {
    en_us = {
        "{{EternalHeart}} +1 Eternal Heart",
        "Removes the boss reward for this floor"
    },
    ru = {
        "{{EternalHeart}} +1 Вечное Сердце",
        "Убирает предмет в награду за босса на этом этаже"
    }
},

[mod.Items.GoodVibes] = {
    en_us = {
        "{{BlendedHeart}} Converts all Red Hearts into Soul Hearts in the room"
    },
    ru = {
        "{{BlendedHeart}} Превращает все Красные Сердца в Сердца Душ в комнате"
    }
},

[mod.Items.DevilsHeart] = {
    en_us = {
        "Grants either +1 Health or +1 Broken Heart",
        "All items cost hearts for the floor"
    },
    ru = {
        "Даёт либо +1 Здоровье, либо +1 Разбитое Сердце",
        "Все предметы на этаже стоят сердца"
    }
},

[mod.Items.MomsDiary] = {
    en_us = {
        "Spawns a random item",
        "Taking damage adds 1 charge"
    },
    ru = {
        "Создаёт случайный предмет",
        "Получение урона даёт 1 заряд"
    }
},

[mod.Items.LittleLies] = {
    en_us = {
        "Size down for the room",
        "↑ +2 Tears for the room"
    },
    ru = {
        "Уменьшает размер на комнату",
        "↑ +2 Слёзы на комнату"
    }
},
[mod.Items.KingsHeart] = {
    en_us = {
        "{{Timer}} Pay 10 {{Coin}} coins to receive a {{UnknownHeart}} random heart"
    },
    ru = {
        "{{Timer}} Заплати 10 {{Coin}} монет за {{UnknownHeart}} случайное сердце"
    }
},
[mod.Items.BreakStuff] = {
    en_us = {
        "Deals 40 damage to all enemies in the room",
        "Opens secret rooms and breaks rocks"
    },
    ru = {
        "Наносит 40 урона всем врагам в комнате",
        "Открывает секретные комнаты и ломает камни"
    }
},
[mod.Items.PersonalBeggar] = {
    en_us = {
        "{{Beggar}} Spawns a random Beggar",
    },
    ru = {
        "{{Beggar}} Создаёт случайного попрошайку",
    },
},
},
--------------------------------------------------------
--Trinkets
--------------------------------------------------------    
Trinket = {
EIDadd = function(...) EID:addTrinket(...) end,

[mod.Trinkets.BabyBlue] = {
    en_us = {
        "{{SoulHeart}} All Red Heart pickups turn into Soul Hearts",
        {
            function(descObj)
                return descObj.ObjSubType == mod.Trinkets.BabyBlue + TrinketType.TRINKET_GOLDEN_FLAG
            end,
            function()
                return "{{BlackHeart}} {{ColorGold}} 5% chance to turn them into Black Hearts"
            end
        }
    },
    ru = {
        "{{SoulHeart}} Все подбираемые Красные Сердца становятся Сердцами Душ",
        {
            function(descObj)
                return descObj.ObjSubType == mod.Trinkets.BabyBlue + TrinketType.TRINKET_GOLDEN_FLAG
            end,
            function()
                return "{{BlackHeart}} {{ColorGold}} 5% шанс превратить их в Чёрные Сердца"
            end
        }
    }
},
[mod.Trinkets.Gaga] = {
    en_us = {
        "Increase spawn-chance for golden pickups"
    },
    ru = {
        "Увеличенный шанс появления золотых подбираемых предметов"
    }
},
[mod.Trinkets.WonderOfYou] = {
    en_us = {
        function(descObj)
            local chance = mod.Utils.IsGoldTrinket(descObj.ObjSubType) and "{{ColorGold}}10%{{ColorReset}}" or "5%"
            return "Taking damage has a " .. chance .. " chance to kill all non-boss enemies"
        end
    },
    ru = {
        function(descObj)
            local chance = mod.Utils.IsGoldTrinket(descObj.ObjSubType) and "{{ColorGold}}10%{{ColorReset}}" or "5%"
            return "При получении урона " .. chance .. " шанс убить всех врагов не-боссов"
        end
    }
},
[mod.Trinkets.RottenFood] = {
    en_us = {
        "{{RottenHeart}} All Red Heart pickups turn into Rotten Hearts"
    },
    ru = {
        "{{RottenHeart}} Все Красные Сердца станут Гнилыми Сердцами"
    },
},
[mod.Trinkets.SecondBreakfast] = {
    en_us = {
        "Spawns a food item upon collecting a food item"
    },
    ru = {
        "Создает предмет-еду при подборе предмета-еды"
    },
},
[mod.Trinkets.Papercut] = {
    en_us = {
        "{{BleedingOut}} Using a card causes all enemies to bleed"
    },
    ru = {
        "{{BleedingOut}} При использовании карты накладывает кровотечение на врагов"
    },
},
[mod.Trinkets.TarotBattery] = {
    en_us = {
        "Using a card adds 1 charge to held active item"
    },
    ru = {
        "При использовании карты даёт 1 заряд к активному предмету"
    },
},
},
--------------------------------------------------------
--Cards/Runes
--------------------------------------------------------    
Card = {
EIDadd = function(...) EID:addCard(...) end,

[mod.Cards.Locacaca] = {
    en_us = {
        "{{HealingRed}} Full health",
        "{{BrokenHeart}} Heals all Broken hearts",
        "{{Warning}} stat decrease for each healed heart container",
        "{{Warning}} lose 1 passive item for each healed Broken heart"
    },
    ru = {
        "{{HealingRed}} Полное здоровье",
        "{{BrokenHeart}} Исцеляет все Разбитые Сердца",
        "{{Warning}} понижение характеристики за каждый вылеченный контейнер сердца",
        "{{Warning}} потеря 1 пассивного предмета за каждое исцелённое Разбитое Сердце"
    },
},
[mod.Cards.alpoh] = {
    en_us = {
        "{{AngelRoom}} Grants a random angel room item",
        "{{BrokenHeart}} Grants 2 Broken Hearts"
    },
    ru = {
        "{{AngelRoom}} Даёт случайный ангельский предмет",
        "{{BrokenHeart}} Даёт 2 разбитых сердца"
    },
},
[mod.Cards.StarShard] = {
    en_us = {
        "{{Planetarium}} Reroll one pedestal into a star item",
        "{{SoulHeart}} Grants 1 Soul Heart if there's no item in the room"
    },
    ru = {
        "{{Planetarium}} Меняет один артефакт на звёздный артефакт",
        "{{SoulHeart}} Даёт 1 Сердце Души если в комнате нет артефактов"
    },
},
[mod.Cards.EnergyDrink] = {
    en_us = {
        "{{Timer}} Receive for the room:",
        "↑ +0.5 speed",
        "↑ +0.5 damage",
        "↑ +0.5 fire rate",
        "↑ +0.5 range",
        "↑ +0.5 shot speed",
        "↑ +0.5 luck",
        "↓ -0.1 to all stats after 15 seconds"
    },
    ru = {
        "{{Timer}} Даёт на комнату:",
        "↑ +0.5 Скорости",
        "↑ +0.5 Урона",
        "↑ +0.5 Скорострельности",
        "↑ +0.5 Дальности",
        "↑ +0.5 Скорости Слезы",
        "↑ +0.5 Удачи",
        "↓ -0.1 всем характеристикам через 15 секунд"
    },
},
[mod.Cards.DadsLottoTicket] = {
    en_us = {
        "{{coin}} 75% chance to spawn coins",
        {
            function()
                return EID:PlayersHaveCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
            end,
            function()
                return "{{Collectible46}} Increased chance for rare coins"
            end
        }
    },
    ru = {
        "{{coin}} 75% шанс создать монеты",
        {
            function()
                return EID:PlayersHaveCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
            end,
            function()
                return "{{Collectible46}} Увеличенный шанс на редкие монеты"
            end
        }
    },
}
},
--------------------------------------------------------
--Pills
--------------------------------------------------------    
Pill = {
EIDadd = function(...) EID:addPill(...) end,

[mod.Pills.CURSED] = {
    en_us = {
        "Grants a curse"
    },
    ru = {
        "Даёт проклятие"
    },
},
[mod.Pills.BLESSED] = {
    en_us = {
        "Removes all curses"
    },
    ru = {
        "Убирает все проклятия"
    },
},
[mod.Pills.HEARTBREAK] = {
    en_us = {
        "{{BrokenHeart}} +1 Broken Heart"
    },
    ru = {
        "{{BrokenHeart}} +1 Разбитое Сердце"
    },
},
[mod.Pills.POWER_DRAIN] = {
    en_us = {
        "{{Timer}} Empties held active item"
    },
    ru = {
        "{{Timer}} Разряжает активный предмет"
    },
},
[mod.Pills.VOMIT] = {
    en_us = {
        "{{Trinket}} Spawns a random trinket"
    },
    ru = {
        "{{Trinket}} Создаёт случайный брелок"
    },
},
[mod.Pills.SOMETHING_CHANGED] = {
    en_us = {
        "{{Trinket}} Reroll held trinkets"
    },
    ru = {
        "{{Trinket}} Меняет имеющиеся брелки"
    },
},
[mod.Pills.EQUAL] = {
    en_us = {
        "Equalizes your coins, bombs and keys"
    },
    ru = {
        "Уравнивает монеты, бомбы и ключи"
    },
}
}
}
