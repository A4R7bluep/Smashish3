extends Node

const attack_lookup = {
	"Xeaus": {
		"5L": {
			"AttackLvl": "light",
			"Damage": 5,
			"Blockstun": 3,
			"KnockbackX": 50,
			"KnockbackY": -700,
		},
		"5M": {
			"AttackLvl": "light",
			"Damage": 7,
			"Blockstun": 5,
			"KnockbackX": 500,
			"KnockbackY": -500,
		},
		"6M": {
			"AttackLvl": "medium",
			"Damage": 13,
			"Blockstun": 5,
			"KnockbackX": 100,
			"KnockbackY": -500,
		},
		"ForwardThrow": {
			"AttackLvl": "throw",
			"Damage": 0,
			"KnockbackX": 1000,
			"KnockbackY": -500,
		},
		"BackThrow": {
			"AttackLvl": "backthrow",
			"Damage": 0,
			"KnockbackX": 1000,
			"KnockbackY": -500,
		},
		"XeausFireball": {
			"AttackLvl": "effect",
			"Damage": 0,
			"KnockbackX": 0,
			"KnockbackY": 0,
		},
		"XeausStainExplode": {
			"AttackLvl": "light",
			"Damage": 6,
			"KnockbackX": 70,
			"KnockbackY": -800,
		},
	},
}
