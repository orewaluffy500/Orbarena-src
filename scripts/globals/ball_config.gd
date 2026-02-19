extends Node

var Config = {
	"knight": {
		"health": 75,
		"speed": 300,
		"price": 400,
		"coinOutput": 250,
		"maxHealth": 150,
		"scale": 1,
		"damage": 2
	},
	"guy": {
		"health": 60,
		"speed": 300,
		"coinOutput": 100,
		"maxHealth": 150,
		"scale": 1,
		"damage": 2,
		"weaponless": true
	},
	"king": {
		"maxHealth": 200,
		"health": 100,
		"speed": 400,
		"summoner": true,
		"price": 900,
		"coinOutput": 500,
		"scale": 1,
		"damage": 2,
		"metas": ["summoned_pawn"]
	},
	"viking": {
		"maxHealth": 175,
		"health": 110,
		"speed": 250,
		"price": 1600,
		"coinOutput": 400,
		"scale": 1,
		"damage": 2
	},
	"fairy": {
		"maxHealth": 140,
		"health": 80,
		"speed": 400,
		"price": 1250,
		"coinOutput": 650,
		"scale": 1,
		"damage": 2
	},
	"pawn": {
		"maxHealth": 70,
		"secret": true,
		"health": 20,
		"speed": 250,
		"scale": 1,
		"damage": 2,
		"weapon": "Sword"
	},
	"slime": {
		"maxHealth": 350,
		"death": Sounds.SlimeDeath,
		"summoner": true,
		"health": 140,
		"speed": 120,
		"price": 2000,
		"coinOutput": 800,
		"scale": 1.2,
		"damage": 2,
		"metas": ["mitosis_count"]
	},
	"slime_minion": {
		"secret": true,
		"death": Sounds.SlimeDeath,
		"maxHealth": 350,
		"health": 30,
		"speed": 150,
		"scale": .8,
		"damage": 2,
		"weapon": "Hammer"
	},
	"poisonist": {
		"death": Sounds.Pop,
		"maxHealth": 350,
		"health": 90,
		"speed": 250,
		"price": 3000,
		"coinOutput": 1000,
		"scale": 1,
		"damage": 2,
		"metas": ["target"]	
	},
	"arsonist": {
		"death": Sounds.Pop,
		"maxHealth": 350,
		"health": 70,
		"speed": 250,
		"price": 4000,
		"coinOutput": 2000,
		"scale": 1,
		"damage": 2,
		"metas": ["target"]
	},
	"angel": {
		"death": Sounds.Pop,
		"maxHealth": 130,
		"health": 30,
		"speed": 250,
		"price": 6000,
		"coinOutput": 300,
		"scale": 1,
		"damage": 2
	},
	"ghost": {
		"death": Sounds.Pop,
		"maxHealth": 250,
		"health": 140,
		"speed": 300,
		"summoner": true,
		"price": 7500,
		"coinOutput": 3000,
		"scale": 1,
		"damage": 2
	},
	"spirit": {
		"secret": true,
		"death": Sounds.Pop,
		"maxHealth": 75,
		"health": 2,
		"speed": 350,
		"scale": .5,
		"damage": 2,
		"weapon": "Club"
	},
	"zombie": {
		"secret": true,
		"death": Sounds.Pop,
		"maxHealth": 100,
		"health": 40,
		"speed": 275,
		"scale": 1,
		"damage": 2,
		"weapon": "Club"
	},
	"super knight": {
		"death": Sounds.Pop,
		"maxHealth": 300,
		"health": 200,
		"speed": 150,
		"scale": 1.2,
		"coinOutput": 5000,
		"damage": 2,
		"metas": ["explosions"]	
	},
	"": {"price": 0, "speed": 0, "health": 0}
}

@onready var BALL_TEMP = preload("res://templates/ball.res")
@onready var BALL_SPAWN = Vector2(368, 787)

func get_current_balls():
	var located_balls = []
	
	for child in get_tree().current_scene.get_children():
		if child is Ball:
			located_balls.append(child)
	
	return located_balls
	
func summon_ball(form, spawner):
	var ball = BALL_TEMP.instantiate()
	ball.form = form
	ball.pawn = true
	ball.name = "Ball_Pawn"
	ball.spawner = spawner.get_instance_id()
	get_tree().current_scene.add_child.call_deferred(ball)
	ball.global_position = BALL_SPAWN
	return ball

func summon_ball_ex(form, position):
	var ball = BALL_TEMP.instantiate()
	ball.form = form

	get_tree().current_scene.add_child(ball)
	ball.global_position = position

	return ball

func configurate_ball(ball: Ball):
	var config: Dictionary = Config[ball.form]
	if not config: return
	
	ball.speed = config["speed"]
	ball.health = config["health"]
	ball.maxHealth = config["maxHealth"]
	

	if config.has("weapon"):
		ball.swordName = config["weapon"]
		ball.canTakeSword = false
	
	if ball.name == "Ball1":
		var upgrades: Dictionary = Player.data.unlockedBalls[ball.form]
		
		var speed = upgrades.get_or_add("speed", 0)
		var damage = upgrades.get_or_add("damage", 0)
		var health = upgrades.get_or_add("health", 0)
		
		ball.speed += 20 * speed
		ball.health += 5 * health
		ball.damage += 4 * damage
	

	if ball.health < 5:
		ball.get_node("HealthLabel").visible = false
	
	
	var ballSprite: Sprite2D = ball.get_node("Sprite2D")
	var col: CollisionShape2D = ball.get_node("CollisionShape2D")
	
	var configScale = config["scale"]
	ball.scaleModifier = configScale
		
	if config.has("metas"):
		for meta in config["metas"]:
			ball.set_meta(meta, null)
	
	if config.has("secret"):
		ball.pawn = true
		ball.shield = null
	
	if config.has("summoner"): ball.summoner = true
	if config.has("death"): ball.deathSound = config["death"]


func getFiltered(buyableOnly = false):
	var final = []

	for ball in Config.keys():
		var data = Config[ball]
		
		if data.has("secret"): continue
		if not data.has("price") and buyableOnly: continue

		final.append(ball)
	
	return final
