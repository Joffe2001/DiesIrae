--------------------------------------------------------
----Syntax----
---
---try using only up to one icon per line; it schould be at the start of the line replacing the bullet point
---
---Basic stat changes:
---!make sure to know the difference between Tears up and Fire rate up!
---!don't use functions in descriptions (e.g. change the damage number of a familiar if isaac has bff)!
--{{ArrowUp}} +[change_amount > 1] [stat(Health/Speed/Tears/Fire rate/Damage/Range/Shot speed/Luck)]
--{{ArrowDown}} -[change_amount < 1] [stat]
--{{ArrowUp}} x[multiplier_amount > 0] [stat]
--{{ArrowDown}} x[multiplier_amount < 0] [stat]
--
--{{[pickup]}} [pickup related effect]
--{{HealingRed}} full health
--
---Luck based effects:
--{{[fitting Icon]}} [effect]
--{{Luck}} [change of effect]
--
---stay with often used phrases like "When taking damage, receive..." or "Taking damage has a chance to..."
---look at the descriptions found in the folders of the External Item Description mod!
--------------------------------------------------------


local mod = DiesIraeMod
mod.EIDescs = {


----COLLECTIBLES----
	Collectible = {
		EIDadd = function(...) EID:addCollectible(...) end,
--Passive items
		[mod.Items.example] = {
			en_us = { 
                "{{ArrowUp}} +0.2 Damage",
            },
            ru = { 
                "{{ArrowUp}} +0.2 [insert russian text]",
            },
		},

--Familiars


--Active items

	},


----PICKUPS----
--Trinkets
	Trinket = {
		EIDadd = function(...) EID:addTrinket(...) end,

		[mod.Trinkets.example] = {
			en_us = {
            },
		},
	},

--Cards/Runes
	Card = {
		EIDadd = function(...) EID:addCard(...) end,

        [mod.Cards.example] = {
            en_us = {
            },
        },
	},

--Pills
	Pill = {
		EIDadd = function(...) EID:addPill(...) end,

		[mod.Pills.example] = {
			en_us = {
            },
		},
	}
}
