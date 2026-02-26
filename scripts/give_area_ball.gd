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
			var team2 = body.get_meta("team", null)
			var team1 = ball.get_meta("team", null)

			if not team1 or not team2: return
			if team1 != team2: return
			
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
