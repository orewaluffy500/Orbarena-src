extends Area2D
class_name BodyDetector
@onready var touching = []

func _body_detected(body):
	if not touching.has(body): touching.append(body)


func _body_left(body):
	if touching.has(body): touching.remove_at(touching.find(body))

func _ready() -> void:
	body_entered.connect(_body_detected)
	body_exited.connect(_body_left)
