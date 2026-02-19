extends Node2D
class_name SwordPivot
@export var rotationNormal = 1
@export var rotationSpeed = 5

@export var twin = false
@export var bro = null

func _ready() -> void:
	if twin:
		bro =  get_parent().get_node("SwordPivot")
		name = "TwinPivot"
		rotation = -bro.rotation
		return
	
	if randi_range(-1, 2) < 1:
		rotationNormal = -1

func _physics_process(_delta: float) -> void:
	if get_parent().swordName == "" and twin: queue_free()
	if twin:
		rotation = -bro.rotation
		$Sword/Sprite2D.texture = bro.get_node("Sword").get_node("Sprite2D").texture

	$Sword/Sprite2D.flip_h = true if rotationNormal == 1 else false

	if not twin:
		rotate(deg_to_rad(rotationNormal * rotationSpeed))	

func _input(event: InputEvent) -> void:
	if twin: return
	if not get_parent().player: return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: rotationNormal = -1
		elif event.button_index == MOUSE_BUTTON_RIGHT: rotationNormal = 1
