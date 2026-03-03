extends Panel

@export var abilityName = "Poke"
@export var keycode: Key
@onready var timeLeft = 0.0
@onready var disabledColor = Color.from_rgba8(80, 80, 80)

func _process(delta: float) -> void:
	if  Input.is_key_pressed(keycode) and $Sprite2D.modulate != disabledColor:
		$Sprite2D.region_rect.position.x = 16
	else:
		$Sprite2D.region_rect.position.x = 0
	var data = Player.data.getSkillData(abilityName)

	if data["deposited"] < data["elixir"]:
		$Label2.text = "LOCKED"
		$Label.text = ""
		$Sprite2D.modulate = disabledColor
		return

	$Label2.text = abilityName
	timeLeft = Player.data.cooldowns.get_or_add(abilityName, 0)
	if timeLeft > 0:
		$Label.visible = true
		$Label.text = "%.1f" % timeLeft
		$Sprite2D.modulate = disabledColor
	else:
		$Sprite2D.modulate = Color.WHITE
		$Label.visible = false
