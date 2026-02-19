extends Node
class_name PlayerNode

@export var maxExp = 100
@export var coins = 0
@export var level = 1
@export var experience = 0
@export var shields = ["Wooden"]
@export var currentShield = "Wooden"
@export var unlockedBalls = {"guy": {}}
@export var showedMessageFor = []
@export var cooldowns = {}
@export var abilities = {}
@export var wins = {}
@export var elixir = 0
@export var tutorials = []

@onready var oldCoins = coins
@onready var popupLabel = preload("res://templates/popup_label.tscn")
@onready var popupPos = Vector2(6, 535)

#func _ready():
	#for key in BallConfig.Config.keys():
		#unlockedBalls[key] = {}

func setDepositedElixirs(deposits):
	for deposit in deposits.keys():
		if not abilities.has(deposit): continue

		abilities[deposit]["deposited"] = deposits[deposit]


func getDepositedElixirs():
	var final = {}

	for ability in abilities.keys():
		var data = abilities[ability]
		var deposited = data["deposited"]

		final[ability] = deposited
	
	return final

func addAbility(name, elixirCost, cooldown, textureName, desc):
	abilities[name] = {
		"elixir": elixirCost,
		"deposited": 0,
		"cooldown": cooldown,
		"texture": textureName,
		"desc": desc
	}


func getSkillData(skillName):
	return abilities[skillName] if abilities.has(skillName) else {}

func _ready() -> void:
	addAbility("Poke", 1000, 3, "Z", "This skill makes your sword poke out")
	addAbility("Dual", 6000, 15, "X", "This skill gives you dual swords")
	addAbility("Tornado", 4500, 10, "C", "This skill makes your sword super-fast")
	addAbility("Tornado", 4500, 10, "C", "This skill makes your sword super-fast")
	addAbility("Tornado", 4500, 10, "C", "This skill makes your sword super-fast")

func _process(delta):

	if elixir >= 1000 and not tutorials.has("first_skill"):
		tutorials.append("first_skill")
		Dialogs.show_tutorial([
			"You now have %d elixir!" % elixir,
			"Click on the `Skills` button to open up the Skills tab ",
			"In there you can deposit elixir to learn new skills!"
		])

	if not unlockedBalls.has("super knight") and wins.get_or_add("knight", 0) >= 10:
		Dialogs.show_error("You obtained super knight")
		unlockedBalls["super knight"] = {}


	if experience < 0: experience = 0
	
	if oldCoins != coins:
		var clone = popupLabel.instantiate()
		
		var diff = round(coins - oldCoins)
		
		clone.text = str(int(diff)) if diff < 0 else "+" + str(int(diff)) + "$"
		get_viewport().get_camera_2d().add_child(clone)
		clone.position = popupPos
	
	oldCoins = coins
	
	if experience >= maxExp:
		var oldLvl = level

		level += 1
		maxExp += randi_range(30, 50)
		experience -= maxExp
		Dialogs.show_popup("Level up %d -> %d" % [oldLvl, level])
		Sounds.play_sound(Sounds.LevelUp)
	
	for key in cooldowns.keys():
		var val = cooldowns[key]
		if val > 0:
			cooldowns[key] -= delta
		elif val < 0:
			cooldowns.erase(key)



func set_cooldown_entity(cooldownName, duration):
	cooldowns[cooldownName] = duration

func is_cooldown_active(cooldownName):
	return cooldowns.has(cooldownName) and cooldowns[cooldownName] > 0
