extends Area2D

@onready var sword = get_parent().get_node("SwordPivot").get_node("Sword")


func body_enter(body):
	sword.handle_hit(body)

func _ready() -> void:
	if not get_parent().weaponless: return

	body_entered.connect(body_enter)
