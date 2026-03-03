extends Label
func _process(delta):
	text = "Level. %d" % Player.data.level
