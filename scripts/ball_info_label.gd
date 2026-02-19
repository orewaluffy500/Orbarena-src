extends Label


func _process(delta):
	if not Screens.currentScreen == "arena": return
	
	var final = ""
	for child in get_tree().current_scene.get_children():
		if child is Ball:
			if child.pawn: continue
			final += child.form + " :: HP " + str(int(round(child.health))) + " | DMG " + str(round(child.damage * 10) / 10) + " x " + str(round(child.damage_mul * 10) / 10)
			final += "\n"

	text = final
