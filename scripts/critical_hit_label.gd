extends Label

@onready var oldVisibility = false

func popOut():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.5)
	
func popIn():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.5)
	tween.tween_callback(func(): visible = false)

func _process(delta):
	if visible != oldVisibility:
		match visible:
			true:
				popOut()
			false:
				popIn()
	
	oldVisibility = visible
