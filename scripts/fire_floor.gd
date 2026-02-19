extends Area2D
class_name LavaFloor

@onready var timeLeft = 10
@onready var touching = []
func _ready():
	Sounds.play_sound(Sounds.Lava)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Ball):
	if not body is Ball: return
	if body.form == "arsonist": return
	touching.append(body)
	
func _on_body_exited(body: Ball):
	if not body is Ball: return
	if touching.has(body):
		touching.remove_at(touching.find(body))

func _process(delta):
	for body: Ball in touching:
		body.health -= 5 * delta
	
	timeLeft -= delta
	if timeLeft < 0: queue_free()
