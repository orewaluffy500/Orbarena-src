extends Label

func _process(delta):
	modulate.a -= 0.02
	if modulate.a <= 0: free()
