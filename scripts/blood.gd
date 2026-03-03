extends Sprite2D

func _ready():
	texture = MiscAssets.getRandomBlood()
	
	var shade = randf_range(240, 255)
	modulate = Color.from_rgba8(shade, shade, shade)

func _process(delta):
	modulate.a -= 0.25 * delta
	if modulate.a <= 0: queue_free()
