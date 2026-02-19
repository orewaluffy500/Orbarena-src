extends Button

@onready var parent: ShieldPurchaseItem = get_parent()

func _pressed() -> void:
	var shieldName = parent.shieldName
	var shieldData = parent.shieldData

	if Player.data.shields.has(shieldName):
		Dialogs.show_popup("You already have this shield!")
		return

	if Player.data.coins < shieldData["price"]:
		Dialogs.show_popup("You're broke!")
		return

	Player.data.coins -= shieldData["price"]
	Player.data.shields.append(shieldName)
	Player.data.currentShield = shieldName
	Sounds.play_sound(Sounds.Buy)
	
