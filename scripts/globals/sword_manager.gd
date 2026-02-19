extends Node

const data = {
	"Sword": {
		"speed": 4,
		"damage": 5,
		"chance": 40
	},
	"Spear": {
		"speed": 6,
		"damage": 8,
		"chance": 10
	},
	"Hammer": {
		"speed": 2,
		"damage": 10,
		"chance": 25
	},
	"HeroSword": {
		"speed": 5,
		"damage": 15,
		"chance": 5
	},
	"Scimitar": {
		"speed": 10,
		"damage": 2,
		"chance": 15
	},
	"Battleaxe": {
		"speed": 4,
		"damage": 18,
		"chance": 12
	},
	"Club": {
		"speed": 3,
		"damage": 8,
		"chance": 32
	},
}



func getWeightedList():
	var chanceOnly = {}

	for sword in data.keys():
		var chance = data[sword]["chance"]

		chanceOnly[sword] = chance
	
	return Misc.getWeightedList(chanceOnly)
