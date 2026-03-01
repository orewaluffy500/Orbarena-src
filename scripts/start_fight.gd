extends Button

@onready var parent = get_parent()
@onready var scene = parent.get_parent()
@onready var fighterSelection = parent.get_node("FighterSelection")
@onready var ballTemplate = BallConfig.BALL_TEMP
@onready var initialPos = BallConfig.BALL_SPAWN
@onready var timerLabel = get_viewport().get_camera_2d().get_node("TimerLabel")
@onready var arena: Arena = get_tree().current_scene.get_node("Arena")
@onready var arenaSprite = arena.get_node("Sprite")
@onready var maps = arena.maps

@export var mode = "Brawl"

@onready var require = {
	"Brawl": 0,
	"Endless": 5,
	"2v2": 12
}
@onready var originalText = text

func _pressed() -> void:
	if mode == "Brawl": startFight()
	
	elif mode == "Endless":
		if Player.data.level < require[mode]:
			Dialogs.show_popup("Level %d or more required for endless mode" % require[mode])
			return
		
		startFight()
	elif mode == "2v2":
		if Player.data.level < require[mode]:
			Dialogs.show_popup("Level %d or more required for 2 vs 2 mode" % require[mode])
			return
		
		start_fight_2v2()
	

func fightInit(map = true):
	Misc.hideAllMaps(arena)
	Misc.cleanUpArena()

	var idx = randi_range(0, maps.size() - 1)
	var mapName = maps[idx]

	if map: Misc.setMapVisible(arena, mapName, true)

	await get_tree().process_frame

func createBall(name, team, form):
	var ball = ballTemplate.instantiate()

	ball.name = name
	ball.set_meta("team", team)
	ball.form = form

	return ball

func startFight():
	arena.toggle_big_mode(false)
	fightInit()
	Misc.gamemode = mode
	
	var ball1 = createBall("Ball1", "RED", fighterSelection.selected)
	var ball2 = createBall("Ball2", "BLUE", get_random_form(ball1))
	
	if mode == "Endless": ball2.set_meta("endless", true)
	
	fightFinalize(120, [ball1, ball2])


func fightFinalize(time, balls):
	for ball in balls:
		scene.add_child(ball)

		if ball.name == "Ball1":
			ball.global_position = BallConfig.BALL_SPAWNS[1]
			continue
		
		ball.global_position = BallConfig.get_random_spawn()

	timerLabel.timeLeft = time
	Screens.change_screen("arena")



func start_fight_2v2():
	arena.toggle_big_mode(true)
	fightInit(false)
	Misc.gamemode = mode

	var bigMap = arena.get_node("BigMap")
	bigMap.position = Vector2.ZERO
	bigMap.visible = true
	
	var ball1 = createBall("Ball1", "RED", fighterSelection.selected)
	var ball2 = createBall("Ball2", "RED", get_random_form(ball1))
	var ball3 = createBall("Ball3", "BLUE", get_random_form(ball1))
	var ball4 = createBall("Ball4", "BLUE", get_random_form(ball1))
	
	fightFinalize(200, [ball1, ball2, ball3, ball4])



func get_random_form(ball1: Ball):
	
	var keys = BallConfig.getFiltered(true)

	var finalKeys = Misc.basedOutput({
		["guy"]: ["knight", "guy"],
		["knight"]: ["viking", "guy", "knight"],
		["viking", "fairy"]: ["viking", "fairy", "king"],
		["king", "slime"]: ["viking", "posionist", "fairy"],
		["poisonist", "arsonist", "angel"]: ["king", "arsonist", "poisonist", "slime"],
		["ghost", "super knight"]: keys,
	}, ball1.form)	

	var selected = finalKeys[randi_range(0, finalKeys.size() - 1)]


	while selected == "":
		selected = finalKeys[randi_range(0, finalKeys.size() - 1)] 
	
	return selected
	
	
func _process(delta: float) -> void:
	if Player.data.level < require[mode]:
		disabled = true
		text = "LOCKED (lv. %d)" % require[mode]
	else:
		disabled = false
		text = originalText
