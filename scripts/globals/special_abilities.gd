extends Node

@onready var lavaFloor = preload("res://templates/lava_floor.tscn")
@onready var fireBullet = preload("res://templates/fire_bullet.tscn")
@onready var explosionTemp = preload("res://templates/explosion_basic.res")
@onready var abilities = {
	"fairy": ability_fairy,
	"angel": ability_angel,
	"king": ability_king,
	"viking": ability_viking,
	"knight": ability_knight,
	"slime": ability_slime,
	"poisonist": ability_poisonist,
	"arsonist": ability_arsonist,
	"ghost": ability_ghost,
	"super knight": ability_super_knight
}

@onready var upTime = 0
@onready var upTimeI = 0

func enable_ability(ball: Ball, delta: float):
	if abilities.has(ball.form):
		abilities[ball.form].call(ball, delta)

func _process(delta: float) -> void:
	upTime += delta
	upTimeI = int(round(upTime))







func ability_knight(ball: Ball, delta: float):
	var sword = ball.get_node("SwordPivot").get_node("Sword")
	
	if ball.health < 40:
		sword.scale = Vector2(2, 2)







func ability_king(ball: Ball, delta: float):
	if ball.health < 80 and not ball.get_meta("spawned_pawn"):
		ball.set_meta("spawned_pawn", true)
		for i in range(2):
			Sounds.play_sound(Sounds.Deploy, 50)
		
			BallConfig.summon_ball("pawn", ball)







func ability_slime(ball: Ball, delta: float):
	var count = ball.get_meta("mitosis_count")
	if ball.tookDamage and ball.get_meta("mitosis_count", 0) < 4:
		if randi_range(1, 2) == 1:	
			ball.set_meta("mitosis_count", count + 1)
			BallConfig.summon_ball("slime_minion", ball)
			Sounds.play_sound(Sounds.SlimeMitotis)







func ability_viking(ball: Ball, delta: float):
	var result = randi_range(1, 100)
	
	if ball.damage_mul > 1.5: ball.damage_mul = 1.5
	if ball.damage_mul < 0.75: ball.damage_mul = 0.75
	if result == 1:
		ball.damage_mul += randf_range(-.1, .3)







func ability_fairy(ball: Ball, delta: float):
	var result = randi_range(1, 100)
	
	if result == 1 and ball.health > 60:
		Sounds.play_sound(Sounds.Heal)
		ball.health += 2







func ability_angel(ball: Ball, delta: float):
	var result = randi_range(1, 225)
	
	if result == 1 and ball.health > 10:
		Sounds.play_sound(Sounds.Heal)
		ball.health += 15







func ability_poisonist(ball: Ball, delta: float):
	if not ball: return
	
	var target = ball.get_meta("target")
	
	if ball.hitBody:
		if not ball: return
		ball.set_meta("target", ball.hitBody)
		get_tree().create_timer(7.5).timeout.connect(func():
			if not ball: return
			ball.set_meta("target", null)	
		)
		
	if target:
		target.health -= 5 * delta
		return
	








func ability_arsonist(ball: Ball, delta: float):
	if not ball: return
	
	if randi_range(1, 80) == 1:
		var floor = lavaFloor.instantiate()
		get_tree().current_scene.add_child(floor)
		floor.global_position = ball.global_position
	
	var target = ball.get_meta("target")
	
	if ball.hitBody:
		if not ball: return
		ball.set_meta("target", ball.hitBody)
		get_tree().create_timer(7.5).timeout.connect(func():
			if not ball: return
			ball.set_meta("target", null)	
		)
		
	if target:
		target.health -= 5 * delta
		return







func ability_ghost(ball: Ball, delta: float):
	if not ball: return
	if not ball.has_meta("second_life"): ball.set_meta("second_life", false)
	
	if ball.health <= 0 and not ball.get_meta("second_life"):
		ball.health = BallConfig.Config[ball.form]["health"]
		ball.set_meta("second_life", true)
		ball.get_node("Sprite2D").modulate.r = 0.3
	
	if randi_range(1, 100) == 1:
		var spirit = BallConfig.summon_ball("spirit", ball)
		
		get_tree().create_timer(5).timeout.connect(func():
			if not spirit or not ball: return	
			
			spirit.queue_free()
		)



func ability_super_knight(ball: Ball, delta: float):
	if not ball: return

	if not ball.has_meta("explosions"):
		ball.set_meta("explosions", 2)
	if ball.get_meta("explosions") <= 0: return

	if ball.player and Input.is_action_just_pressed("ball_ability_1"):
		summon_explosion(ball)
	
	elif not ball.player and randi_range(1, 200) == 1:
		summon_explosion(ball)








func add_explosion_regen(ball: Ball):
	get_tree().create_timer(3).timeout.connect(func():
		if not ball: return
		ball.set_meta("explosions", ball.get_meta("explosions", 0) + 1)
		if ball.get_meta("explosions") < 2:
			add_explosion_regen(ball)
	)



func summon_explosion(ball: Ball):
	var clone = explosionTemp.instantiate()

	get_tree().current_scene.add_child(clone)
	clone.global_position = ball.global_position
	clone.explosionMaker = ball.get_instance_id()

	ball.set_meta("explosions", ball.get_meta("explosions") - 1)
	
	add_explosion_regen(ball)

	Sounds.play_sound(Sounds.GroundSlam)	
