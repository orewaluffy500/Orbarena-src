extends Area2D
class_name Collectable

func _enter(body):
	if not body is Ball: return

	if enter_logic(body):
		queue_free()

func enter_logic(ball: Ball):
	return true

func _ready() -> void:
	Misc.animatePopOut(self)
	body_entered.connect(_enter)
