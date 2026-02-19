extends Panel

@export var disabled = false


func _process(delta: float) -> void:
	if disabled:
		$Label.self_modulate.a = 100
