extends Button

@onready var parent = get_parent()
@onready var scene = parent.get_parent()
@onready var fighterSelection = parent.get_node("FighterSelection")
@onready var ballTemplate = BallConfig.BALL_TEMP
@onready var initialPos = BallConfig.BALL_SPAWN
@onready var timerLabel = get_viewport().get_camera_2d().get_node("TimerLabel")
@onready var arena: Arena = get_tree().current_scene.get_node("Arena")
@onready var modeSelection: OptionButton = get_parent().get_node("ModeSelection")
@onready var arenaSprite = arena.get_node("Sprite")
@onready var maps = arena.maps

func get_mode():
	return modeSelection.get_item_text(modeSelection.get_selected_id())

func _pressed() -> void:
	var mode = get_mode()

	if mode == "Brawl": startFight()
	elif mode == "Endless":
		if Player.data.level < 5: Dialogs.show_popup("Level 5 or more required for endless mode")
		else: startFight()

func startFight():
	Misc.hideAllMaps(arena)
	Misc.cleanUpArena()

	var idx = randi_range(0, maps.size() - 1)
	var mapName = maps[idx]

	Misc.setMapVisible(arena, mapName, true)

	await get_tree().process_frame

	var ball1 = ballTemplate.instantiate()
	ball1.name = "Ball1"
	ball1.position = initialPos
	ball1.form = fighterSelection.selected
	scene.add_child(ball1)
	
	var ball2 = ballTemplate.instantiate()
	ball2.name = "Ball2"
	ball2.position = initialPos
	ball2.form = get_random_form(ball1)
	
	if get_mode() == "Endless": ball2.set_meta("endless", true)
	
	scene.add_child(ball2)
	
	timerLabel.timeLeft = 100
	Screens.change_screen("arena")

func get_random_form(ball1: Ball):
	if ball1.form == "guy":
		var res = randi_range(0, 1)
		if res == 1: return "guy"
		if res == 0: return "knight"
	
	var keys = BallConfig.getFiltered(true)
	var selected = keys[randi_range(0, keys.size() - 1)]


	while selected == "":
		selected = keys[randi_range(0, keys.size() - 1)] 
	
	return selected
	
