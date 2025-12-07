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


local mod = DiesIraeMod

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
                "↑ +0.2 Слёз",
                "↑ +0.2 Скорости",
                "↑ +0.2 Дальности",
                "↑ +0.2 Удачи",
                "↑ +0.2 Скорости Слезы"
            },
		},
		[mod.Items.Muse] = {
			en_us = { 
                "Taking damage has a chance to spawn:",
                "{{Card}} a Tarot card (20%)",
                "{{Rune}} a Rune (10%)",
                "a random pickup (20%)",
                "an item from the current room pool (1%)"
            },
            ru = { 
                "При получении урона шанс создать данный ниже подбираемый предмет:",
                "{{Card}} 20% Карта Таро",
                "{{Rune}} 10% Руна",
                "20% случайный подбираемый предмет",
                "1% случайный предмет из пула данной комнаты"
            }
		},
		[mod.Items.TheBadTouch] = {
			en_us = { 
                "Kill non-boss enemies on contact",
                "{{Poison}} Poison bosses on contact"
            },
            ru = { 
                "При контакте мгновенно убивает врагов-не боссов",
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
                "После поглощения появятся лучи от Разверзшихся Небес за каждый снаряд"
            }
		},
		[mod.Items.RingOfFire] = {
			en_us = { 
                "Spawns 6 Center ring Fire Wisps",
                "{{Burning}} Fire Wisps burn enemies on contact",
				"Fire Wisps are unable to shoot",
                "Upon clearing a room, add 1 fire wisp",
            },
		},
		[mod.Items.MomsDress ] = {
			en_us = {
                "{{RottenHeart}} Spawns 2 Rotten Hearts",
				"{{HolyMantle}} 30% chance to grant a Holy Mantel shield for the room",
				"each additional copie increases the chance by 10%"
            },
            ru = {
                "{{RottenHeart}} Создаёт 2 Гнилых Сердца при подборе",
                "{{HolyMantle}} 30% шанс дать эффект Святой Мантии в незачищенных комнатах",
                "!!! Outdated description."
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
                "{{Luck}} За каждую отрицательную Удачу даёт:",
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
                "Все пассивные предметы/предметы спутников рандомизируются при зачистке комнаты"
            }
		},
		[mod.Items.Echo] = {
            en_us = { 
                "{{Planetarium}} +25% Planetarium chance",
				"+10% after womb" --per floor? gives +25 pre womb and only +10 after?
            },
            ru = { 
                "{{Planetarium}} +25% шанс Планетария",
				"+10% в Матке и последующих этажах"
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
                "↑ Устанавливает скорость на 2 когда все враги мертвы",
                "Создаёт случайную маленькую лужу мочи во время битвы"
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
                "Стоя неподвижно создаёт увеличивающуюся лужу",
                "Лужа растёт каждый кадр"
            }
        },
        [mod.Items.ProteinPowder] = {
            en_us = { -- not done
                "↑ +1 Damage",
                "Future copies will grant +1 damage for each collected copy",
				"This effect stops after the fourth copy"
            },
            ru = { 
                "↑ +1 Урон при первом подборе, +2 при втором, до +4",
                "Последующие подборы всегда дают +1 Урон"
            }
        },
        [mod.Items.Hysteria] = {
            en_us = { 
                "Taking damage twice doubles damage for the room",
                "{{BrokenHeart}} Taking damage an additional time in the room removes the effect and grants a Broken Heart",
                "{{BrokenHeart}} Taking damage an additional time in the room grants a Broken Heart and doubles the Tear Rate for the room",
            },
            ru = { 
                "Получение урона дважды за комнату удваивает урон на комнату"
            }
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
                "Враги отражают получаемый урон на ближайших врагов",
                "Отражается только чистый урон"
            }
        },
        [mod.Items.GoldenDay] = {
            en_us = { 
                "Spawns a golden pickup",
                "{{SecretRoom}} 50% chance to spawn a golden pickup in the secret room"
            },
            ru = { 
                "Даёт случайный золотой подбираемый предмет",
                "{{SecretRoom}} На каждом этаже есть 50% шанс создать золотой подбираемый предмет в Секретной Комнате"
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
                "После 0.2 секунд устремляются к ближайшему врагу, оставляя огненный след",
                "{{Burning}} Слёзы накладывают горение на врагов"
            }
        },
        [mod.Items.Psychosocial] = {
            en_us = { 
                "↓ -0.5 Tears per enemy in the room"
            },
            ru = { 
                "↓ -0.5 Задержки Выстрела за каждого врага в комнате"
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
                "Имеет шанс открыть красную комнату рядом при зачистке комнаты"
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
                "Зачистка комнаты на половине сердца даёт случайное повышение характеристики ниже:",
                "↑ +0.3 Урона",
                "↑ +0.1 Скорости",
                "↓ -0.3 Задержки Выстрела"
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
                "При зачистке комнаты даёт случайное меленькое повышение характеристики",
                "При получении урона убирает все повышения характеристик и может добавить {{BrokenHeart}}Разбитое Сердце"
            }
        },
        [mod.Items.BeggarsTear] = {
            en_us = { 
                "Tears collect pickups",
				"Tears push consumables towards isaac"
            },
            ru = { 
                "Слёзы могут подбирать предметы",
                "Расходники притягиваются к Исааку, в то время как остальные предметы подбираются мгновенно"
            }
        },
        [mod.Items.KoRn] = {
            en_us = { 
                "10% chance to shoot a colored tear",
				"Colored tears create status effects inflicting mist"
            },
            ru = { 
                "10% шанс выстрелить случайной цветной слезой",
                "Цветные слёзы создают соответствующие облака при попадании, накладывающие эффекты"
            }
        },
        [mod.Items.BackInAnger] = {
            en_us = { 
                "Tears are fired from your bag (based on moving)",
                "↑ +4 Damage"
            },
            ru = { 
                "Стрельба сзади",
                "↑ +4 Урона"
            }
        },
        [mod.Items.BigKahunaBurger] = {
            en_us = { 
                "↑ +1 to 3 Health"
            },
            ru = { 
                "↑ +1-3 полных Контейнеров Красных Сердец"
            }
        },
        [mod.Items.DadsEmptyWallet] = {
            en_us = { 
                "↑ +1 Tears",
                "↓ -0.02 Tears for every {{coin}} coin Isaac has stopping at -1 Tears"
            },
            ru = { 
                "↑ +1 Слёзы если у Исаака нет монет",
                "↓ -0.02 Слёз за каждую монету"
            },
        },
        [mod.Items.FiendDeal] = {
            en_us = { 
                "Spawns a fiend beggar in the first room on every floor who leaves if the player leaves the room",
				"Interacting with the beggar spawns two devil items on the next floor",
				"{{Warning}} Interacting with the beggar results in Isaac dying in one hit for the floor"
            },
            ru = { 
                "Создаёт Попрошайку-Изверга в первой комнате каждого этажа",
                "При выходе из комнаты Попрошайка исчезнет",
                "Совершая сделку с Попрошайкой, гарантирует 2 Дьявольских предмета на выбор на следующем этаже",
                "{{Warning}} Исаак умирает от любого удара на этаже, где была совершена сделка"
            },
        },
        [mod.Items.Bloodline] = {
            en_us = {
				"Enemies mirror damage to enemies of the same type"
            },
            ru = { 
                "Любой урон, нанесённый врагу, распространяется на всех врагов этого же типа в комнате"
            },
        },
        [mod.Items.BetrayalHeart] = {
            en_us = { 
                "{{BrokenHeart}} +1 Broken Heart",
                "↑ +1 damage up for every {{BrokenHeart}} Broken Heart"
            },
            ru = { 
                "+1 {{BrokenHeart}} при подборе",
                "↑ +1 Урон за каждое {{BrokenHeart}} разбитое сердце"
            },
        },
        [mod.Items.StillStanding] = {
            en_us = { 
                "↑ While standing still damage keeps increasing",
				"Caps at +4 damage"
            },
            ru = { 
                "↑ Урон пока Исаак стоит на месте",
            },
        },
        [mod.Items.BossCompass] = {
            en_us = { 
                "Reveals the location of all Boss {{BossRoom}} and {{MiniBoss}} Mini-boss rooms",
                "↑ Increases Damage for all Bosses defeated" --how much???
            },
            ru = { 
                "{{BossRoom}} Показывает комнаты Босса и Мини-босса на карте",
                "↑ Урон за каждого убитого босса и мини-босса"
            },
        },
        [mod.Items.DevilsMap] = {
            en_us = { 
				"Reveales the location of all {{SacrificeRoom}} Sacrifice and {{CursedRoom}} Curse rooms",
				"↑ Increases Tears for all Sacrivice, Curse and Devil deal rooms"
            },
            ru = { 
                "Показывает комнату {{SacrificeRoom}} Жертвоприношения и {{CursedRoom}} Проклятую комнату на карте",
                "↑ Слёзы за посещение этих комнат и комнаты Сделки с Дьяволом"
            },
        },
        [mod.Items.BorrowedStrength] = {
            en_us = { 
                "↑ +2 Damage",
                "{{Warning}} Lose half your health upon entering a new floor"
            },
            ru = { 
                "↑ +2 Урона",
                "{{Warning}} Исаак теряет половину своих сердец при переходе на новый этаж"
            },
        },
        [mod.Items.SymphonyOfDestruction] = {
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
                "{{BossRoom}} Только в комнате Босса: +0.2 слёз за каждую смерть от этого босса"
            },
        },
        [mod.Items.FloweringSkull] = {
            en_us = { 
				"Revives Isaac with 2 heart containers in the same room dealing 40 damage to all enemies and rerolling all passive items"
            },
            ru = { 
                "Возрождает Исаака при смерти",
                "{{Heart}} ­ Возрождает с 2 контейнерами красных сердец (или 2 {{SoulHeart}} сердцами душ)",
                "{{ArrowUp}} ­ Наносит 40 урона всем врагам в комнате при возрождении",
                "{{Warning}} ­ Также заменяет все пассивные предметы на новые случайные пассивные предметы"
            },
        },
        [mod.Items.RewrappingPaper] = {
            en_us = { 
				"{{TreasureRoom}} All Treasure Room items are replaced with {{Collectible515}} Mystery gift"
            },
            ru = { 
                "{{TreasureRoom}} Все пьедесталы в Сокровищнице станут {{Collectible515}} Загадочным Подарком",
            },
        },
        [mod.Items.FilthyRich] = {
            en_us = { 
				"{{Poison}} Chance to shoot poison tears and to spawn poison mist",
				"{{coin}} Holding coins increases the chance"
            },
            ru = { 
                "{{Poison}} Чем больше {{Coin}} монет есть у Исаака, тем больше шанс на отравляющие слёзы и создание отравляющих облаков",
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
                "{{WoodenChest}} 15% шанс заменить сундук на Деревянный Сундук",
            },
        },
        [mod.Items.Grudge] = {
            en_us = { 
				"{{DeathMark}} Taking damage markes the responsible enemy type",
				"Marked enemies take double damage"
            },
            ru = { 
                "{{DeathMark}} При получении урона от врага, этот тип врагов помечается",
                "Враги этого типа получают двойной урон весь забег"
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
                "↑ +0.15 Урона и +0.15 Слёз за каждый предмет из модов"
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
                "{{HolyMantle}} Защищает от 1 попадания в комнате",
                "↑ +0.1 скорости",
                "↑ +3 удачи",
                "↑ x1.5 множитель урона",
                "{{Warning}} При потере щита x1.5 множитель урона пропадёт",
                "{{Warning}} Получение урона после потери щита:",
                "↓ x0.3 множитель урона",
                "↓ -5 удачи",
                "{{BrokenHeart}} Даёт 2 разбитых сердца",
                "Множитель урона будет сброшен до x1.5 при заходе в новую комнату"
            }
        },
--------------------------------------------------------
--Familiars
--------------------------------------------------------    
		[mod.Items.ParanoidAndroid] = {
            en_us = { 
                "Shoots a static laser around itself",
            },
            ru = { 
                "Создаёт лазерное кольцо вокруг себя",
            }
        },
        [mod.Items.KillerQueen] = {
			en_us = { 
				"Fires rockets at enemies"
            },
            ru = { 
                "Стреляет ракетами во врагов, похожими на ракеты от Эпичного Зародыша"
            }
		},
        [mod.Items.RedBum] = {
			en_us = { 
                "{{Key}} Picks up nearby Keys",
				"{{Collectible580}} has a low chance to spawn Red Key"
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
                "Один раз за этаж рандомизирует один случайный пассивный или предмет спутника"
            }
		},
		[mod.Items.ArmyOfLovers] = {
			en_us = {   
                "Spawns 2 Minisaacs"
            },
            ru = {   
                "Создаёт 2 Мини-Исааков"
            }
		},
		[mod.Items.SlingShot] = {
			en_us = {
                "Shoots a large piercing tear which destroys rocks",
                "Tear explodes on wall impact",
            },
            ru = {
                "Выстреливает огромную медленную пронзающую слезу, уничтожающую камни и открывающую проходы в секретную комнату",
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
                "{{Collectible483}} Вызывает эффект Мама Мега!",
                "{{BrokenHeart}} +1 Разбитое Сердце",
                "Только один раз за этаж",
            }
        },
    
        [mod.Items.HypaHypa] = {
            en_us = {
				"{{Warning}} SINGLE USE {{Warning}}",
                "{{Quality4}} 30% chance to spawn a Quality 4",
                "{{Collectible36}} 70% chance to spawn The Poop",
            },
            ru = {
                "{{Warning}} Одноразовый {{Warning}}",
                "{{Quality4}} 30% шанс создать предмет качества",
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
				"{{BlendedHeart}} Converts all Red Hearts into Soul Hearts for the room"
            },
            ru = {
                "{{BlendedHeart}} Превращает все Красные Сердца на полу в Сердца Душ"
            }
        },

        [mod.Items.DevilsHeart] = {
            en_us = {
				"Grants either +1 Health or +1 Broken Heart"
				"All items cost hearts for the floor"
            },
            ru = {
                "{{Heart}} 50% шанс на Контейнер Красного Сердца",
                "{{BrokenHeart}} 50% шанс на Разбитое Сердце",
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
                "Заряжается от получения урона"
            }
        },
    
        [mod.Items.LittleLies] = {
            en_us = {
				"Size down for the room"
                "↑ +2 Tears for the room"
            },
            ru = {
                "Уменьшает Исаака на комнату",
                "↑ +2 Слёз на комнату"
            }
        },
        [mod.Items.KingsHeart] = {
            en_us = {
                "{{Timer}} Pay 10 {{Coin}} coins to receive a {{UnknownHeart}} random heart"
            },
            ru = {
                "Дает Исааку случайное {{UnknownHeart}} сердце",
                "{{Timer}} Стоит 10 {{Coin}} монет"
            }
        },
        [mod.Items.BreakStuff] = {
            en_us = {
                "Deals 100 damage to all enemies in the room",
				"Can open secret rooms and break rocks"
            },
            ru = {
                "Наносит 100 урона всем врагам в комнате",
                "Открывает все двери",
                "Разрушает все камни в комнате"
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
				"{{SoulHeart}} All Read Heart pickups turn into Soul Hearts"
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
                "Все подбираемые {{Heart}}Красные Сердца становятся {{SoulHeart}}Сердцами Душ",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.BabyBlue + TrinketType.TRINKET_GOLDEN_FLAG
                    end,
                    function()
                        return "{{BlackHeart}} {{ColorGold}} 5% шанс для Красных Сердец стать Чёрными Сердцами"
                    end
                }
            }
		},
        [mod.Trinkets.Gaga] = {
            en_us = {
				"Increase spawn-chance for golden pickups"
            },
            ru = {
                "Увеличенный шанс превратить обычные Бомбы, Ключи и Монеты в их золотые вариации"
            }
        },
        [mod.Trinkets.WonderOfYou] = {
            en_us = {
                "Taking damage has a 5% chance to kill all non-boss enemies",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.WonderOfYou + TrinketType.TRINKET_GOLDEN_FLAG
                    end,
                    function()
                        return "Taking damage has a {{ColorGold}}10%{{ColorReset}} chance to kill all non-boss enemies"
                    end
                }
            },
            ru = {
                "При получении урона 5% шанс мгновенно убить всех врагов не боссов в комнате",
                {
                    function(descObj)
                        return descObj.ObjSubType == mod.Trinkets.WonderOfYou + TrinketType.TRINKET_GOLDEN_FLAG
                    end,
                    function()
                        return "При получении урона {{ColorGold}}10%{{CR}} шанс мгновенно убить всех врагов не боссов в комнате"
                    end
                }
            }
        },
        [mod.Trinkets.RottenFood] = {
            en_us = {
				"{{RottenHeart}} All Read Heart pickups turn into Rotten Hearts"
            },
            ru = {
                "{{RottenHeart}} Все сердца будут гнилыми сердцами"
            },
        },
        [mod.Trinkets.SecondBreakfast] = {
            en_us = {
				"Spawns a food item upon collecting a food item"
            },
            ru = {
                "При получении предмета еды создаёт ещё один"
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
                "При использовании карты даёт +1 заряд к активному предмету"
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
				"{{BrokenHeart}} Heals all Broken hearts"
                "{{Warning}} stat decrease for each healed heart container",
                "{{Warning}} lose 1 passive item for each healed Broken heart"
            },
            ru = {
                "{{HealingRed}} Лечит красные сердца",
                "{{BrokenHeart}} Если есть разбитые сердца, это также излечит их",
                "{{Warning}}Лечение контейнера сердца стоит понижение характеристик",
                "{{Warning}}Лечение разбитых сердец стоит предметы"
            },
        },
        [mod.Cards.alpoh] = {
            en_us = {
                "{{AngelRoom}} Grants a random angel room item",
                "{{BrokenHeart}} Grands 2 Broken Hearts"
            },
            ru = {
                "{{AngelRoom}} Даёт случайный ангельский предмет",
                "{{BrokenHeart}} Стоит 2 разбитых сердца"
            },
        },
        [mod.Cards.StarShard] = {
            en_us = {
				"{{Planetarium}} Reroll one pedestal into a star item"
				"{{SoulHeart}} Grants 1 Soul Heart if there's no item in the room"
            },
            ru = {
                "{{Planetarium}} Меняет предмет на предмет из Планетария",
                "{{SoulHeart}} Если предметов нет, даст 1 сердца души"
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
                "↑ Даёт +0.5 ко всем характеристикам на комнату",
                "↓ После 15 секунд Исаак получает штрафное -0.1 к характеристикам на комнату"
            },
        },
        [mod.Cards.DadsLottoTicket] = {
            en_us = { ---which chance gets decreased by 1% with lucky foot????? -missing
				--- unknown if works correctly
                "Spawns: ",
                "Nothing (25%)",
                "{{Coin}} (60%)",
                "{{Coin}} {{Coin}} (9%)",
                "{{Nickel}} (5%)",
                {
                	EID:PlayersHaveCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
					EID:ReplaceVariableStr("0.2%", 2, "{{ColorYellow}}0.4%{{CR}}")
                },
                "{{Dime}} ({2})",
                "{{Crafting26}} ({2})",
                {
                	EID:PlayersHaveCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
					EID:ReplaceVariableStr("0.1%", 3, "{{ColorYellow}}0.2%{{CR}}")
                },
                "{{Crafting11}} ({3})",
                "3 {{Nickel}} ({3})",
                {
                	EID:PlayersHaveCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
					EID:ReplaceVariableStr("0.05%", 4, "{{ColorYellow}}0.1%{{CR}}")
                },
                "10 {{Coin}} ({4})",
                "10 {{Nickel}} ({4})",
                "{{Dime}} {{Crafting11}} {{Crafting26}} ({4})",
                "2 {{Dime}} 2 {{Crafting11}} 2 {{Crafting26}} ({4})",
                {
                	EID:PlayersHaveCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
					EID:ReplaceVariableStr("0.04%", 5, "{{ColorYellow}}0.08%{{CR}}")
                },
                "6 {{Dime}} ({5})",
                "4 {{Crafting26}} ({5})",
                {
                	EID:PlayersHaveCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
					EID:ReplaceVariableStr("0.03%", 6, "{{ColorYellow}}0.06%{{CR}}")
                },
                "2 {{Dime}} 5 {{Crafting26}} ({6})",
                "3 {{Crafting11}} 2 {{Coin}} {{Nickel}} {{Dime}} ({6})",
                {
                	EID:PlayersHaveCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
					EID:ReplaceVariableStr("0.02%", 7, "{{ColorYellow}}0.04%{{CR}}")
                },
                "5 {{Crafting11}} ({7})",
                "2 {{Crafting26}} 3{{Crafting11}} ({7})",
                "6 {{Nickel}} 6 {{Nickel}} ({7})"
            },
            ru = {
                "Шанс создать Монету, Пятак или Гривенник",
                "Есть шанс не создать ничего",
                "!!! Outdated description.",
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
                "Applies a random curse"
            },
            ru = {
                "Даёт случайное проклятие"
            },
		},
        [mod.Pills.BLESSED] = {
			en_us = {
                "Removes current curses"
            },
            ru = {
                "Убирает текущие проклятия"
            },
		},
        [mod.Pills.HEARTBREAK] = {
			en_us = {
                "Adds a {{BrokenHeart}}Broken Heart"
            },
            ru = {
                "Даёт {{BrokenHeart}}разбитое сердце"
            },
		},
        [mod.Pills.POWER_DRAIN] = {
			en_us = {
                "Empties active item charge"
            },
            ru = {
                "Опустошает заряд активного предмета"
            },
		},
        [mod.Pills.VOMIT] = {
			en_us = {
                "Spawn a random {{Trinket}} trinket"
            },
		},
        [mod.Pills.SOMETHING_CHANGED] = {
			en_us = {
                "Change held {{Trinket}} trinket(s)"
            },
		},
        [mod.Pills.EQUAL] = {
			en_us = {
                "Equalizes your coins, bombs and keys"
            },
            ru = {
                "Приравнивает монеты, бомбы и ключи"
            },
		}
	}
u
