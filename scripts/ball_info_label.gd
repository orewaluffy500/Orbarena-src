extends Label


func _process(delta):
	if not Screens.currentScreen == "arena": return
	
	var final = ""
	for child in get_tree().current_scene.get_children():
		if child is Ball:
			if child.pawn: continue
			final += "Health: %d " % child.health
			for meta in child.get_meta_list():
				if meta == "ball" or meta == "target": continue

				var val = child.get_meta(meta)
				final += "%s: %s " % [meta.replace("_", " "), val]
			
			final += "\n"

	text = final
