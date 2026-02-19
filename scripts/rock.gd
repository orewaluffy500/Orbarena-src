extends StaticBody2D
class_name Rock

@export var num = 1

@onready var sprite = load("res://assets/misc/rock" + str(num) + ".png")

func _ready():
	$Sprite2D.texture = sprite
	
	if randi_range(1, 5) == 1:
		$Sprite2D.flip_h = true
	
	var randScale = randf_range(0.75, 1)
	scale = Vector2(randScale, randScale)
