extends Label
class_name DamageLabel

func init(text_):
	text = text_

func _process(delta: float) -> void:
	if modulate.a <= 0:
		queue_free()
		return

	modulate.a -= 0.04
	position.y -= 50 * delta
