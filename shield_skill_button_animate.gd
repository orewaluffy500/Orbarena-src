extends Panel

func _process(delta):
	if Input.is_key_pressed(KEY_B):
		$Sprite2D.region_rect.position.x = 16
	else:
		$Sprite2D.region_rect.position.x = 0
