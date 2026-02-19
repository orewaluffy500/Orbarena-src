extends Label
class_name ErrorLabel

@onready var timeLeft = 0

func showMessage(text_):
	var tween = create_tween()
	text = text_
	tween.tween_property(self, "modulate", Color.from_rgba8(255, 255, 255, 255), 0.1)
	timeLeft = 2

func hideMessage():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.from_rgba8(255, 255, 255, 0), 0.1)

func _process(delta: float) -> void:
	if timeLeft > 0:
		timeLeft -= delta
	
	elif timeLeft <= 0 and modulate.a > 0:
		hideMessage()
