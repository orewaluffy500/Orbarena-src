extends Label

@export var timeLeft = 0
@export var started = false
@onready var coinOutput = 25
@onready var BackgroundMusic: BGMusicPlayer = get_viewport().get_camera_2d().get_node("BackgroundMusic")

func _process(delta: float) -> void:
	if Screens.currentScreen != "arena":
		visible = false
		return
	
	visible = true
	
	if started: check_end()
	
	if timeLeft > 0 and not started: started = true
	if timeLeft <= 0 and started: started = false
	
	
	if timeLeft > 0:
		timeLeft -= delta
	
	var ball2 = get_tree().current_scene.get_node("Ball2")
	if ball2:
		coinOutput = BallConfig.Config[ball2.form].coinOutput
	
	text = str(int(round(timeLeft))) + "s"

func check_end() -> void:
	var message := ""
	var won := false
	var youWon := false

	# Collect non-pawn balls
	var player_ok := false
	var player = null

	var balls := []
	for ball in BallConfig.get_current_balls():
		if ball.player:
			player_ok = true
			player = ball
			continue

		if not ball.pawn and not ball.player:
			balls.append(ball)

	# --- TIME IS UP ---
	if timeLeft <= 0:
		won = true

		if player_ok and balls.size() > 0:
			message = "Nobody won."
		elif not player_ok and balls.size() <= 0:
			message = "It's a draw."
		elif balls.size() <= 0:
			message = "You won!"
			youWon = true
		else:
			message = "You lost."

	# --- BEFORE TIME IS UP (sudden death) ---
	elif not player_ok:
		won = true
		message = "You lost."
	
	elif balls.size() == 0:
		won = true
		youWon = true
		message = "You won!"

	if won:
		Misc.hideAllMaps(get_tree().current_scene.get_node("Arena"))
		
		Screens.change_screen("main")
		for child in get_tree().current_scene.get_children():
			if child is Ball or child is PowerUp or child is LavaFloor:
				child.queue_free()
		
		if BackgroundMusic.currentPlaying != BackgroundMusic.bgMusic:
			BackgroundMusic.currentPlaying = BackgroundMusic.bgMusic
		
		started = false
		timeLeft = 0

		if youWon:
			if Player.data.wins.has(player.form):
				Player.data.wins[player.form] += 1
			else:
				Player.data.wins[player.form] = 1
			
			Player.data.coins += coinOutput
			Player.data.elixir += randi_range(120, 200) + (Player.data.level * 10)
			Player.data.experience += randi_range(Player.data.maxExp - 60, Player.data.maxExp + 60)

		Dialogs.show_win_dialog(message)
