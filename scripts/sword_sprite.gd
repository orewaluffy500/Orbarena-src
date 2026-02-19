extends Sprite2D

func _process(delta):
	rotation = -45 if not flip_h else 45
