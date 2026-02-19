extends Sprite2D

func _ready():
	texture = MiscAssets.getRandomBlood()

func _process(delta):
	modulate.a -= 1 * delta
	if modulate.a <= 0: queue_free()
