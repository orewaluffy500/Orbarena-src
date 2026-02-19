extends ProgressBar
class_name CooldownBar

@onready var max_cooldown = get_parent().MAX_COOLDOWN
@onready var on_cooldown = false

func _process(_delta: float) -> void:
	max_value = max_cooldown * 100
	visible = on_cooldown
	if get_parent().cooldown > 0 and not on_cooldown:
		var tween = create_tween()
		value = max_value
		tween.tween_property(self, "value", 0, max_cooldown).finished.connect(func(): on_cooldown = false)
		on_cooldown = true
