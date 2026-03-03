extends Button

var mode = false
var t = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _pressed():
	var twn = create_tween()
	twn.tween_property(self, "position", position + Vector2(0, 1000), 1).set_trans(Tween.TRANS_BACK)

	Misc.isGameFrozen = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Screens.currentScreen != "arena":
		position = Vector2(328, 354)
		modulate.a = 0
		return
	
	modulate.a = 1
