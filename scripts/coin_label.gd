extends Label
func _process(delta):
	text = Misc.format_number(Player.data.coins) + "$"
