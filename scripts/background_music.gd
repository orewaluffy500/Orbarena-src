extends AudioStreamPlayer2D
class_name BGMusicPlayer

@export var bossMusic = preload("res://assets/audio/BossMusic.mp3")
@export var bgMusic = preload("res://assets/audio/BGMusic.mp3")

@export var currentPlaying: AudioStream = bgMusic:
	set(value):
		if currentPlaying == value:
			return
		currentPlaying = value
		_play_current()

func _ready():
	_play_current()

func _play_current():
	if currentPlaying == null:
		return

	stream = currentPlaying

	# Ensure looping
	if stream is AudioStream:
		stream.loop = true

	play()
