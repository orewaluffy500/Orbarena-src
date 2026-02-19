
extends MeshInstance2D
@export var expandTime: float = 2
@export var fadeTime: float = 1.5

func _ready():
	var tween = create_tween()
	var tween2 = create_tween()
	
	tween.tween_property(self, "scale", Vector2(400, 400), expandTime)
	tween2.tween_property(self, "modulate", Color.from_rgba8(255, 255, 255, 0), fadeTime)
