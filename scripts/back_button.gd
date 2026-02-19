extends Button


func _pressed() -> void:
	Misc.cleanUpArena()
	Screens.change_screen("main")
