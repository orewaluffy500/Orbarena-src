extends Node

const ShieldData = {
	"Wooden": {"price": 50, "reduction": 1.5, "slowness": 2},
	"Stone": {"price": 125, "reduction": 3, "slowness": 3.25},
	"Steel": {"price": 375, "reduction": 4, "slowness": 3},
	"Iron": {"price": 600, "reduction": 8, "slowness": 4},
	"": {"price": 0, "reduction": 0, "slowness": 0}
}

func getFiltered(buyable = false):
	var final = []

	for shield in ShieldData.keys():
		var data = ShieldData[shield]

		if buyable and data.has("secret"): continue

		final.append(shield)
	
	
	return final
