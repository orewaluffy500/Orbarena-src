extends Panel

@export var abilityName = "Poke"
@onready var timeLeft = 0.0

func _process(delta: float) -> void:
	var data = Player.data.getSkillData(abilityName)

	if data["deposited"] < data["elixir"]:
		$Label2.text = "LOCKED"
		$Label.text = ""
		$Label.visible = true
		return

	$Label2.text = abilityName
	timeLeft = Player.data.cooldowns.get_or_add(abilityName, 0)
	if timeLeft > 0:
		$Label.visible = true
		$Label.text = str(round(timeLeft / 0.1) * 0.1)
	else:
		$Label.visible = false
