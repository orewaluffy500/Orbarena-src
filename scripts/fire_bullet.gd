extends RigidBody2D

@export var creator = 0
@onready var lifespan = 10

func body_entered_hitbox(body: Node2D):
	if body is Ball:
		if body.get_instance_id() == creator: return
		
		body.health -= randi_range(3, 5)
		queue_free()


func _ready() -> void:
	$Area2D.body_entered.connect(body_entered_hitbox)

func _process(delta):
	linear_velocity = transform.x * 200
	if lifespan < 0:
		queue_free()
	
	lifespan -= delta
