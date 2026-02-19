extends Button

@onready var ballName = get_parent().ballName
@onready var ballData = get_parent().ballData

func _pressed() -> void:
	if Player.data.unlockedBalls.has(ballName): return

	if Player.data.coins < ballData["price"]:
		Dialogs.show_popup("Too little money")
		return
	
	Player.data.coins -= ballData["price"]
	Player.data.unlockedBalls[ballName] = {}
	disabled = true
	text = "Bought"
	Sounds.play_sound(Sounds.Buy)
