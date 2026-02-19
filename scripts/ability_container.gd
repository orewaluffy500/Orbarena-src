extends GridContainer

@onready var abilityBox = preload("res://templates/ability_box.res")
@onready var timeLeft = 0

func _process(delta: float) -> void:
	
	if Screens.currentScreen != "arena": return

	if timeLeft > 0:
		timeLeft -= delta
		return
	
	for child in get_children():
		child.queue_free()

	for key in Player.data.abilities.keys():
		var data = Player.data.abilities[key]
		var cooldown = data["cooldown"]
		var energy = data["energy"]

		var inst = abilityBox.instantiate()
		inst.get_node("Label").text = key
		inst.get_node("ProgressBar").max_value = cooldown
		inst.disabled = energy > 0

		add_child(inst)
	
	timeLeft = 2
