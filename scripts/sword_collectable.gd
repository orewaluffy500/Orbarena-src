extends Collectable
class_name SwordCollectable

@export var spriteTex = "sword"
@onready var didRefresh = false

func refresh_sprite():
	$Sprite2D.texture = load("res://assets/weapons/%s.png" % spriteTex)

func _process(_delta: float) -> void:
	if not didRefresh:
		didRefresh = true
		refresh_sprite()

func enter_logic(ball: Ball):
	if not ball.canTakeSword: return false

	ball.refresh_sword(spriteTex)
	return true
