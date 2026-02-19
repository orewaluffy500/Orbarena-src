extends Area2D

@export var damage = 10


@onready var damaged = []

func body_enter(body: Ball):
	if body.get_instance_id() == get_parent().explosionMaker: return
	if not body is Ball or damaged.has(body.get_instance_id()): return

	body.health = max(4, body.health - damage)
	damaged.append(body.get_instance_id())


func _ready() -> void:
	body_entered.connect(body_enter)
