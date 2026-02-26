extends Sprite2D

@onready var autosaveCooldown = 5 * 60
@onready var timeLeft = autosaveCooldown

func _process(delta):
	timeLeft -= delta
	if timeLeft <= 0:
		timeLeft = autosaveCooldown
		SaveData.new().save()
