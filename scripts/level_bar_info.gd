extends Label

func _process(delta):
	text = str(int(Player.data.experience)) + "/" + str(int(Player.data.maxExp)) 
