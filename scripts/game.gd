extends Node2D

@onready var BackgroundMusic: BGMusicPlayer = $Camera2D/BackgroundMusic
@onready var cam = $Camera2D

func _process(dt):
	if Screens.currentScreen == "arena":
		BackgroundMusic.currentPlaying = BackgroundMusic.bossMusic
	else:
		BackgroundMusic.currentPlaying = BackgroundMusic.bgMusic
