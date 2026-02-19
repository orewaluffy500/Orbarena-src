extends Label
func _process(delta):
	text = "lv. " + str(int(Player.data.level))
