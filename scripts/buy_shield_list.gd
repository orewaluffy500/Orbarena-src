extends ItemList

@onready var shieldSystem = ShieldSystem.new()

func _ready():
	for key in shieldSystem.ShieldData:
		var data = shieldSystem.ShieldData[key]
		add_item(key + " [" + str(round(data["price"])) + "$]")
