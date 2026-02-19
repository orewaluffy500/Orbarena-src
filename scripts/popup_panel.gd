extends Panel
class_name PopupPanelClass

@onready var showPos = Vector2(9, 518)
@onready var hidePos = Vector2(11, 623)

@onready var timeLeft = 0
@onready var shown = false

func show_message(text):
	$Label.text = text

	var tween = create_tween()
	tween.tween_property(self, "position", showPos, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	timeLeft = 1
	shown = true


func _process(delta: float) -> void:
	if timeLeft > 0:
		timeLeft -= delta
	else:
		if not shown: return

		shown = false
		var tween = create_tween()
		tween.tween_property(self, "position", hidePos, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	
