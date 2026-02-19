extends StaticBody2D
class_name Arena

@onready var template = preload("res://templates/power_up.tscn")
@onready var swordCollectableTemplate = preload("res://templates/sword_collectable.tscn")
@onready var timeSinceSpawn = 0
@onready var timeSinceSwordSpawn = 0
@onready var formsNonWeighted = {
	"heal": 35,
	"speed": 20,
	"damage": 10,
	"clone": 5,
	"invincibility": 3
}

@onready var forms = Misc.getWeightedList(formsNonWeighted)

@onready var sprite = $Sprite
@onready var timerLabel = get_parent().get_node("TimerLabel")

@export var maps = [
	"FourColumnMap",
	"OneWallMap",
	"DesertMap",
	"PlainsMap",
	"CaveMap",
	"StoneMap",
	"RoomMap"
]

@export var mapShowPos = Vector2(0, 0)
@export var mapDefaultPos = Vector2(1156, 0)

func handle_powerup_spawn(delta):
	timeSinceSpawn += delta
	if not timeSinceSpawn > 7.5: return
	timeSinceSpawn = 0

	spawn_powerup()
	
func spawn_powerup():
	var form = forms[randi_range(0, forms.size() - 1)]
	
	var pos = Vector2(
		randf_range($PowerUpMin.global_position.x, $PowerUpMax.global_position.x),
		randf_range($PowerUpMin.global_position.y, $PowerUpMax.global_position.y)
	)

	var clone = template.instantiate()
	clone.form = form
	get_parent().add_child(clone)
	clone.global_position = pos

func handle_sword_spawn(delta):
	timeSinceSwordSpawn += delta
	if not timeSinceSwordSpawn > 5: return
	
	timeSinceSwordSpawn = 0

	spawn_sword()

func spawn_sword():
	var swordNames = SwordManager.getWeightedList()
	var spriteTex = swordNames[randi_range(0, swordNames.size() - 1)]
	
	var pos = Vector2(
		randf_range($PowerUpMin.global_position.x, $PowerUpMax.global_position.x),
		randf_range($PowerUpMin.global_position.y, $PowerUpMax.global_position.y)
	)

	var clone = swordCollectableTemplate.instantiate()
	clone.spriteTex = spriteTex
	get_parent().add_child(clone)
	clone.global_position = pos

func _process(delta):
	handle_powerup_spawn(delta)
	handle_sword_spawn(delta)
