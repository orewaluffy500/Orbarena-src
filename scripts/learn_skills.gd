extends Button

func _process(delta):
	disabled = not Player.data.tutorials.has("first_skill")
	text = "LOCKED" if disabled else "Skills"

func _pressed() -> void:
	Screens.change_screen("skills")
