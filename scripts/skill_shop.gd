extends Panel


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	var temp = preload("res://templates/skill_shop_item.tscn")

	var abilities = Player.data.abilities.keys()
	abilities.append(abilities[abilities.size() - 1])

	for ability in abilities:
		var clone: SkillItem = temp.instantiate()

		clone.abilityName = ability
		clone.configure_item()
		$ScrollContainer/VerticalList.add_child(clone)
