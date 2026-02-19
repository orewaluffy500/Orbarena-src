extends RigidBody2D
class_name Ball

@export var speed := 350.0
@export var health = 100
@export var damage = 5
@export var form = "knight"
@export var damage_mul = 1
@export var tookDamage = false
@export var pawn = false
@export var hitBody = null
@export var summoner = false
@export var deathSound = Sounds.Pop
@export var maxHealth: int = 0
@export var spawner = ResourceUID.create_id()
@export var shielded = false
@export var shield = null
@export var canShield = true
@export var cooldown = 0
@export var MAX_COOLDOWN = 0.4
@export var canTakeSword = true 


@onready var tookDamageCounter = 0
@onready var swordPivot = $SwordPivot
@onready var sprite: Sprite2D = $Sprite2D	
@onready var timer: Timer = Timer.new()
@onready var healthLabel: Label = $HealthLabel	
@onready var player = false
@onready var shieldSystem = ShieldManager
@onready var timeSinceCouldntShield = 0
@onready var swordName = ""
@onready var timeSinceHasSword = 0
@onready var swordSprite = $SwordPivot/Sword/Sprite2D
@onready var originalScale = Vector2(3, 3)
@onready var originalScaleCol = Vector2(1.36, 1.36)
@onready var originalScaleShield = Vector2(2.5, 2.5)
@onready var scaleModifier = 0
@onready var stateMachine = StateMachine.new()

func handle_sword_despawn(dt):
	if not swordSprite.visible: return

	timeSinceHasSword += dt
	if timeSinceHasSword > 10:
		timeSinceHasSword = 0
		disable_sword()

func refresh_shield():
	if shield != null and shield != "":
		$Shield.texture = load("res://assets/shields/" + shield + ".png")
	else:
		if pawn: return		
		shield = "Wooden"
		$Shield.texture = load("res://assets/shields/" + shield + ".png")

func refresh_sword(newName):
	if newName == "": return
	if not swordSprite.visible: swordSprite.visible = true
	
	swordName = newName
	var texture = load("res://assets/weapons/%s.png" % swordName)

	swordSprite.texture = texture

	var data = SwordManager.data[swordName]

	damage = data["damage"]
	$SwordPivot.rotationSpeed = data["speed"]

	timeSinceHasSword = 0

func disable_sword():
	swordSprite.visible = false
	swordName = ""

func _ready() -> void:

	
	# Initialize
	if name == "Ball1": player = true
	
	if player:
		$YouLabel.visible = true
		shield = Player.data.currentShield
	else:
		swordName = "Sword"
	
	
	damage_mul = 1
	
	# Randomzie shield for enemies
	if not player and Player.data.level > 5:
		var shields = shieldSystem.ShieldData.keys()

		var usableShields = Misc.getByLevel({
			0: ["Wooden"],
			5: ["Wooden", "Stone"],
			10: ["Stone", "Steel"],
			20: ["Stone", "Iron", "Steel"],
			30: shields
		})
		
		shield = usableShields[randi_range(0, usableShields.size() - 1)]
	
	# Configuration
	BallConfig.configurate_ball(self)
	stateMachine.create(self)
	
	if player and not form == "guy":
		damage /= 1.5
	else:
		if not form == "guy":
			health += 15
			maxHealth += 15
	
	# Check if ally
	if not player:
		var scene := get_tree().current_scene
		var ball1 := scene.get_node_or_null("Ball1")

		if ball1 != null and ball1.get_instance_id() == spawner:
			$YouLabel.text = "Ally"
			$YouLabel.visible = true
			swordName = ""

	var path = "res://assets/balls/%s.png" % form

	refresh_shield()
	refresh_sword(swordName)

	sprite.texture = load(path)
	position += Vector2(randi_range(-75, 75), randi_range(-75, 75))
	
	if player: return
	gravity_scale = 0
	linear_velocity = Vector2(1, 1).normalized() * speed


func getTotalSpeed():
	if shield == null or shield == "": return speed
	return speed / shieldSystem.ShieldData[shield]["slowness"] if shielded else speed



func handle_shield_break():
	if shielded and tookDamageCounter > 3:
		Sounds.play_sound(Sounds.ShieldBreak)
	elif not shielded:
		tookDamageCounter = 0


func _physics_process(delta: float) -> void:
	if tookDamage:
		get_tree().create_timer(.03).timeout.connect(func():
			if self:
				tookDamage = false
				if shielded: tookDamageCounter += 1
		)
	
	if hitBody:
		get_tree().create_timer(.03).timeout.connect(func():
			if self: hitBody = null
		)
	
	health = min(health, maxHealth)
	
	if not player: linear_velocity = linear_velocity.normalized() * getTotalSpeed()
	# if not player: handle_enemy_movement()
	else: handle_movement()
	
	healthLabel.text = str(int(health))
	
	SpecialAbilities.enable_ability(self, delta)
	
	if health <= 0:
		if has_meta("endless"):
			Player.data.coins += randi_range(35, 80)
			
			var balls = Player.data.unlockedBalls
			form = balls.keys()[randi_range(0, balls.size() - 1)]
			BallConfig.configurate_ball(self)
			var path = "res://assets/balls/" + form + ".png"
			sprite.texture = load(path)
			return
		
		Sounds.play_sound(Sounds.Pop)
		queue_free()

func _process(delta: float) -> void:
	sprite.scale = originalScale * scaleModifier
	$CollisionShape2D.scale = originalScaleCol * scaleModifier
	$Shield.scale = originalScaleShield * scaleModifier
	handle_sword_despawn(delta)

	if not canShield:
		timeSinceCouldntShield += delta
		if timeSinceCouldntShield > 4:
			canShield = true
			timeSinceCouldntShield = 0
	
	shielded = $Shield.visible
	
	if not player: return
	
	var upgrades =  Player.data.unlockedBalls[form]
	if upgrades.has("heal") and upgrades["heal"] > 0:
		var res = randi_range(1, 250)
		if res == 1:
			health += 10
			Sounds.play_sound(Sounds.Heal)
	
	if $CollisionShape2D.disabled == true:
		sprite.modulate.a = 0.5
	else:
		sprite.modulate.a = 1


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not player: return
		SkillManager.handle_execution(self, $SwordPivot/Sword, $SwordPivot, event)


func handle_movement():
	linear_velocity = Vector2.ZERO
	
	if Input.is_key_pressed(KEY_W):
		linear_velocity.y = -1
	if Input.is_key_pressed(KEY_S):
		linear_velocity.y = 1
	if Input.is_key_pressed(KEY_A):
		linear_velocity.x = -1
	if Input.is_key_pressed(KEY_D):
		linear_velocity.x = 1
	
	freeze = linear_velocity == Vector2.ZERO
	linear_velocity = linear_velocity.normalized() * getTotalSpeed()

	
