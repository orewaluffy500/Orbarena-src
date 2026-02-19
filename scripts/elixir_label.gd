extends Label

func _process(delta: float) -> void:
	visible = Player.data.tutorials.has("first_skill")
	text = Misc.format_number(Player.data.elixir)
