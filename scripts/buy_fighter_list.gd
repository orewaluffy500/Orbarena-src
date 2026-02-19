extends ItemList

func _ready():
	for key in BallConfig.Config.keys():
		var data = BallConfig.Config[key]
		if not data.has("price") or data.has("secret") or key == "guy": continue
		
		var icon = load("res://assets/balls/" + key + ".png")
		
		add_item(key + " [" + str(data["price"]) + "$]", icon)
