extends Area2D

@onready var parent = get_parent()
@onready var shield = parent.get_node("Shield")
@onready var disabled = false

func _body_entered(body):
	if body is Ball:
		if randi_range(1, 10) == 1:
			shield.visible = true

func _body_exited(body):
	if body is Ball:
		shield.visible = false

func _ready():
	
	if parent.player: return
	
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)

func _process(delta):
	if not parent.player: return
	
	if Input.is_key_pressed(KEY_B) and parent.canShield:
		shield.visible = true
		return
	
	shield.visible = false
