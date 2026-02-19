extends Node

const Bounce := preload("res://assets/audio/bounce.mp3")
const Clash := preload("res://assets/audio/clash4.mp3")
const Slash := preload("res://assets/audio/Cut.mp3")
const Pop := preload("res://assets/audio/Pop.mp3")
const AbilityStart := preload("res://assets/audio/Ability.mp3")
const Heal := preload("res://assets/audio/Heal.mp3")
const Deploy := preload("res://assets/audio/Deploy.mp3")
const SlimeDeath := preload("res://assets/audio/SlimeDeath.mp3")
const SlimeMitotis := preload("res://assets/audio/SlimeMitotis.mp3")
const LevelUp := preload("res://assets/audio/LevelUp.mp3")
const ShieldBreak := preload("res://assets/audio/ShieldBreak.mp3")
const PowerUpSound := preload("res://assets/audio/PowerUp.mp3")
const Buy := preload("res://assets/audio/Buy.mp3")
const Lava := preload("res://assets/audio/Lava.mp3")
const ShieldImpact1 := preload("res://assets/audio/ShieldImpact1.mp3")
const ShieldImpact2 := preload("res://assets/audio/ShieldImpact2.mp3")
const ShieldImpact3 := preload("res://assets/audio/ShieldImpact3.mp3")
const ShieldImpact4 := preload("res://assets/audio/ShieldImpact4.mp3")
const Tornado := preload("res://assets/audio/Tornado.mp3")
const ElixirUsed := preload("res://assets/audio/ElixirUsed.mp3")
const GroundSlam := preload("res://assets/audio/GroundSlam.mp3")

const soundBatches = {
	"shield": [ShieldImpact1, ShieldImpact2, ShieldImpact3, ShieldImpact4]
}

var player: AudioStreamPlayer2D
var players := []

func _ready() -> void:
	get_tree().scene_changed.connect(scene_changed)

func scene_changed():
	for i in range(20):
		var p = AudioStreamPlayer2D.new()
		get_viewport().get_camera_2d().add_child(p)
		players.append(p)

func play_sound(sound: AudioStream, pitch: float = 1.0, pos = null):
	for p: AudioStreamPlayer2D in players:
		if not p.playing:
			p.stream = sound
			p.pitch_scale = pitch
			p.global_position = get_viewport().get_camera_2d().global_position if not pos else pos
			p.play()
			return

func play_sound_batch(soundName,  pos = null):
	if not soundBatches.has(soundName): return
	
	var batch = soundBatches[soundName]
	var idx = randi_range(0, batch.size() - 1)
	var sound = batch[idx]
	
	play_sound(sound, 1, pos)
