extends Button

@export var paused = false

func set_paused(isPaused):
	paused = isPaused
	
	for child in get_tree().current_scene.get_children() :
		if child is Ball:
			child.freeze = isPaused
			
			if isPaused:
				child.get_node("SwordPivot").rotationNormal = 0
			else:
				child.get_node("SwordPivot").rotationNormal = 1

func _pressed():
	if paused:
		text = "Pause"
		set_paused(false)
	else:
		text = "Resume"
		set_paused(true)
