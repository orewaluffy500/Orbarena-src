extends Area2D
class_name Cactus

@onready var touching = []
@onready var timeSinceDamage = 0

func _body_entered(body: Node2D):
	if not touching.has(body): touching.append(body)

func _body_exited(body: Node2D):
	if touching.has(body): touching.remove_at(touching.find(body))

func _ready() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)

func _process(delta: float) -> void:
	timeSinceDamage += delta

	if not timeSinceDamage > 0.25: return

	timeSinceDamage = 0

	for body in touching:
		if body is Ball:
			body.health -= 2
