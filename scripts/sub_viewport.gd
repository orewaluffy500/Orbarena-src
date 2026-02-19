extends SubViewport

@onready var camera = $Camera2D

func _physics_process(delta: float) -> void:
	var ball = get_tree().current_scene.get_node_or_null("Ball1")
	if ball:
		camera.position = ball.global_position
