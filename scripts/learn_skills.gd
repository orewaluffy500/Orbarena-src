extends Button

func _process(delta):
	visible = Player.data.tutorials.has("first_skill")
func _pressed() -> void:
	Screens.change_screen("skills")
