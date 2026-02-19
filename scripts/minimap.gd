extends Node2D

@onready var scene = get_tree().current_scene
@onready var pointers = {}

func create_pointer(ball: Ball):
	var staticBody = StaticBody2D.new()
	
	var sprite = Sprite2D.new()
	sprite.name = "Sprite"
	sprite.texture = ball.get_node("Sprite2D").texture

	staticBody.add_child(sprite)
	add_child(staticBody)

func _process(delta: float) -> void:
	if Screens.currentScreen != "arena": return

	for child: Ball in scene.getchildren():
		if not child is Ball: return
		if pointers.has(child): continue

		pointers[child] = 
	

	for pointer: Ball in pointers:
		var mapSize = Vector2(2048, 1200)
		var miniMapSize = Vector2(256, 256)
		var ballPos = pointer.global_position

		var finalPos = Vector2(
			(ballPos.x - mapSize.x) * miniMapSize.x,
			(ballPos.y - mapSize.y) * miniMapSize.y
		)
