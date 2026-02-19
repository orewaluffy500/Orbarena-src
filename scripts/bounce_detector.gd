extends Area2D

func bounced(body):
	Sounds.play_sound(Sounds.Bounce)


func _ready() -> void:
	body_entered.connect(bounced)
