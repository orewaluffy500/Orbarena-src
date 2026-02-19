extends Panel
class_name WinDialog

@onready var showPos = Vector2(180, 132)
@onready var hidePos = Vector2(180, -365)

func _ready() -> void:
	position = hidePos

func show_dialog():
	var tween = create_tween()
	tween.tween_property(self, "position", showPos, 0.5)

func hide_dialog():
	var tween = create_tween()
	tween.tween_property(self, "position", hidePos, 0.5)
