extends RigidBody2D
class_name Projectile

@export var team = ""
@export var lifespan = 10
var didDamage = false
@export var speed = 200
@export var damage = [0, 0]

func body_entered_hitbox(body: Node2D):
	if body is Ball:
		if Misc.check_teams(body.get_meta('team', null), team) or didDamage:
			queue_free()
			return

		body.damageTaken = randi_range(damage[0], damage[1])
		didDamage = true
	
	queue_free()


func _ready():
	$Area2D.body_entered.connect(body_entered_hitbox)

func _physics_process(delta):
	linear_velocity = transform.x * speed
	lifespan -= delta
	if lifespan <= 0:
		queue_free()
		
