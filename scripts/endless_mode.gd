extends CheckButton

func _process(d):
	if Player.data.level < 5: disabled = true
	else: disabled = false
