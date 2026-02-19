extends Node

var data: PlayerNode = null

func _ready():
	get_tree().scene_changed.connect(_scene_changed)

func _scene_changed():
	data = get_tree().current_scene.get_node("PlayerNode")
