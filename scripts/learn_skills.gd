extends Button

func _process(delta):
	disabled = not Player.data.tutorials.has("first_skill")
	if disabled:
		modulate = Color.from_rgba8(100, 100, 100)
	else:
		modulate = Color.WHITE

func _pressed() -> void:
	Screens.change_screen("skills")
