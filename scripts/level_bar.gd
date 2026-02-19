extends ProgressBar

func _process(delta):
	if not max_value == Player.data.maxExp:
		max_value = Player.data.maxExp
		
	if not value == Player.data.experience:
		value = Player.data.experience
