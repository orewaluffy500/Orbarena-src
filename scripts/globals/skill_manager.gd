extends Node

@onready var skills = {
	"Poke": {
		"logic": Callable(self, "skill_poke"),
		"exceptions": ["Club", "HeroSword", "Hammer"]
	},
	"Dual": {
		"logic": Callable(self, "skill_dual"),
		"exceptions": ["Club", "Hammer"]
	},
	"Tornado": {
		"logic": Callable(self, "skill_tornado"),
		"exceptions": ["Scimitar"]
	},
}


@onready var keybinds = {
	KEY_Z: ["Poke", skills["Poke"]],
	KEY_X: ["Dual", skills["Dual"]],
	KEY_C: ["Tornado", skills["Tornado"]],
}

@onready var swordPivotTemplate = preload("res://templates/sword_pivot.tscn")

func skill_poke(ball: Ball, sword: Sword, swordPivot: SwordPivot):
	var tween = create_tween()
	var originalPos = sword.position

	tween.tween_property(sword, "position", sword.position - Vector2(0, 100), 0.5)
	tween.tween_property(sword, "position", originalPos, 0.5)

func skill_dual(ball: Ball, sword: Sword, swordPivot: SwordPivot):
	var newSwordPivot = swordPivotTemplate.instantiate()
	newSwordPivot.twin = true

	ball.add_child(newSwordPivot)
	newSwordPivot.position = swordPivot.position

	get_tree().create_timer(8).timeout.connect(func():
		if ball and newSwordPivot:
			newSwordPivot.queue_free()
	)

func skill_tornado(ball: Ball, sword: Sword, swordPivot: SwordPivot):
	swordPivot.rotationSpeed *= 3
	get_tree().create_timer(5).timeout.connect(func():
		if ball:
			ball.refresh_sword(ball.swordName) # make sure the speed is consistent
	)



func handle_execution(ball: Ball, sword: Sword, swordPivot: Node2D, event: InputEventKey):
	if not keybinds.has(event.keycode) or ball.swordName == null or ball.swordName == "": return
	var data = keybinds[event.keycode]
	var skill = data[1]
	var skillName = data[0]

	var abilityData = Player.data.getSkillData(skillName)
	if abilityData["deposited"] < abilityData["elixir"]: return
	
	if Player.data.is_cooldown_active(skillName): return


	if skill["exceptions"].has(ball.swordName): 
		Dialogs.show_error("Ability unusable on %s" % ball.swordName)
		return

	skill["logic"].call(ball, sword, swordPivot)
	Player.data.set_cooldown_entity(skillName, Player.data.abilities[skillName]["cooldown"])
