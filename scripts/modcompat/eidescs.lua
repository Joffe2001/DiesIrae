local mod = DiesIraeMod

mod.EIDescs = {
	Collectible = { --types
		EIDadd = function(...) EID:addCollectible(...) end, --function which will add a description

		[mod.Items.AnotherMedium] = { --items
			en_us = { --languages
				--description
				"Once per floor, swaps one random passive or familiar with a completely random one from any item pool"
			}
		},
		[mod.Items.ArmyOfLovers] = {
			en_us = {
				"Spawns 2 Mini Isaacs"
			}
		},
		[mod.Items.BigShot] = {
			en_us = {
				"Fires a massive, slow, piercing tear that destroys rocks and opens secret room doors. Explodes on wall impact",
				"4s cooldown"
			}
		},
		
	},
	Trinket = {
		EIDadd = function(...) EID:addTrinket(...) end,

		[mod.Trinkets.BabyBlue] = {
			"All red heart drops become Soul Hearts",
			"Golden: 5% of them become Black Hearts"
		},
	},
	Card = {
		EIDadd = function(...) EID:addCard(...) end,

		
	},
	Pill = {
		EIDadd = function(...) EID:addPill(...) end,

		[mod.Pills.CURSED] = {
			en_us = {
				"Applies a random curse"
			}
		},
	}
}
