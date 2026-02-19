extends BodyDetector

@onready var ball: Ball = get_parent()

func _input(event: InputEvent) -> void:
	if not ball.player: return

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_G:
			handle_gift()



func handle_gift():
	for body in touching:
		if body is Ball:
			if body.spawner != ball.get_instance_id(): continue

			if ball.swordName == null or ball.swordName == "": continue
			
			if body.swordName == null or body.swordName == "":
				body.refresh_sword(ball.swordName)
				Dialogs.show_popup("Gave away " + ball.swordName)
				ball.disable_sword()
				return
			else:
				var oldSword = ball.swordName
				var oldAllySword = body.swordName
				ball.refresh_sword(body.swordName)
				body.refresh_sword(oldSword)

				Dialogs.show_popup("Swapped " + oldSword + " for " + oldAllySword)
