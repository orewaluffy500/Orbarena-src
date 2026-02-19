extends Map

@onready var timeSinceSpawn = 0
@onready var ZOMBIE_SPAWN_COOLDOWN = 10

func _process(delta: float) -> void:
	if not visible: return

	timeSinceSpawn += delta
	if not timeSinceSpawn > ZOMBIE_SPAWN_COOLDOWN: return

	timeSinceSpawn = 0

	BallConfig.summon_ball("zombie", get_tree().current_scene)
