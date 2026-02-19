extends Camera2D

@onready var uiElements = [$BallInfo1, $TimerLabel, $PokeAbility, $DualAbility, $TornadoAbility]

@onready var viewPos := Vector2.ZERO
@onready var viewPortSize := get_viewport_rect().size

@onready var maxView := Vector2(0, 0)
@onready var minView := Vector2(-viewPortSize.x, 0)

func _process(delta: float) -> void:
	for element in uiElements:
		element.visible = Screens.currentScreen == "arena"

	if Screens.currentScreen != "arena":
		viewPos = Vector2.ZERO
		global_position = Screens.screens[Screens.currentScreen]
		return

	var ball := get_tree().current_scene.get_node_or_null("Ball1")
	if not ball:
		return

	update_camera_to_ball(ball.global_position)

	var dest = Screens.screens["arena"] + viewPos

	if global_position.is_equal_approx(dest): return

	var tween = create_tween()
	tween.tween_property(self, "global_position", dest, 0.25)

func update_camera_to_ball(ball_pos: Vector2) -> void:
	# Current camera rect in world space
	var cam_origin = Screens.screens["arena"] + viewPos
	var cam_rect := Rect2(cam_origin, viewPortSize)

	var new_view_pos := viewPos

	# Horizontal check
	if ball_pos.x < cam_rect.position.x:
		new_view_pos.x -= viewPortSize.x
	elif ball_pos.x > cam_rect.position.x + cam_rect.size.x:
		new_view_pos.x += viewPortSize.x

	# Vertical check
	if ball_pos.y < cam_rect.position.y:
		new_view_pos.y -= viewPortSize.y
	elif ball_pos.y > cam_rect.position.y + cam_rect.size.y:
		new_view_pos.y += viewPortSize.y

	# Clamp to limits
	new_view_pos.x = clamp(new_view_pos.x, minView.x, maxView.x)
	new_view_pos.y = clamp(new_view_pos.y, minView.y, maxView.y)

	viewPos = new_view_pos
