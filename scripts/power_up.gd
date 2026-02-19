extends Area2D
class_name PowerUp
@export var form = "speed"

@onready var Sprite = $Sprite2D

@onready var logic = {
	"heal": heal_logic,
	"damage": damage_logic,
	"speed": speed_logic,
	"clone": clone_logic,
	"invincibility": invincibility_logic,
}

func _ready() -> void:
	Sprite.texture = load("res://assets/powerups/" + form + ".png")
	
	Misc.animatePopOut(self)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Ball):
	if not (body is Ball): return
	
	Sounds.play_sound(Sounds.PowerUpSound)
	logic[form].call(body)
	self.queue_free()

func heal_logic(body: Ball):
	body.health += 20

func speed_logic(body: Ball):
	body.speed *= 2
	get_tree().create_timer(5).timeout.connect(func():
		if not body: return
		body.speed /= 2
	)

func damage_logic(body: Ball):
	body.damage *= 2
	get_tree().create_timer(5).timeout.connect(func():
		if not body: return
		body.damage /= 2
	)

func clone_logic(body: Ball):
	if body.summoner or body.pawn: return
	
	BallConfig.summon_ball(body.form, body)

func invincibility_logic(body: Ball):
	body.get_node("CollisionShape2D").disabled = true
	body.modulate.a = 0.5
	
	get_tree().create_timer(5).timeout.connect(func():
		if not body: return
		body.modulate.a = 1
		body.get_node("CollisionShape2D").disabled = false
	)
