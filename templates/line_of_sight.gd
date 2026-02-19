extends Area2D
# @onready var nearbyBalls = []
# @onready var nearbyPowerUps = []
# @onready var nearbySwords = []
# @onready var timeSincePicked = 0
# @onready var ATTENTION_SPAN = 10
# @onready var target: Node2D = null
# @onready var parent: Ball = get_parent()

# const REACH_TIMEOUT = 7.0
# const REACH_THRESHOLD = 20.0
# var timeToReach = 0.0

# func nodeEntered(node: Node2D):
# 	if node is Ball:
# 		if node == parent: return
# 		if node.get_instance_id() == parent.spawner or node.spawner == parent.get_instance_id(): return
# 		nearbyBalls.append(node)
# 	elif node is Collectable:
# 		nearbySwords.append(node)
# 	elif node is PowerUp:
# 		nearbyPowerUps.append(node)

# func nodeLeft(node: Node2D):
# 	if nearbyBalls.has(node): nearbyBalls.erase(node)
# 	if nearbyPowerUps.has(node): nearbyPowerUps.erase(node)
# 	if nearbySwords.has(node): nearbySwords.erase(node)

# func _ready() -> void:
# 	body_entered.connect(nodeEntered)
# 	body_exited.connect(nodeLeft)

# func pick_enemy():
# 	var strongest = null
# 	for ball: Ball in nearbyBalls:
# 		if not strongest:
# 			strongest = ball
# 			continue
# 		if ball.health > strongest.health:
# 			strongest = ball
# 	target = strongest
# 	parent.targetDest = target.global_position
# 	timeSincePicked = ATTENTION_SPAN
# 	timeToReach = REACH_TIMEOUT

# func pick_item():
# 	var item = nearbyPowerUps[randi_range(0, nearbyPowerUps.size() - 1)]
# 	target = item
# 	parent.targetDest = target.global_position
# 	timeSincePicked = ATTENTION_SPAN
# 	timeToReach = REACH_TIMEOUT

# func pick_sword():
# 	var sword = nearbySwords[randi_range(0, nearbySwords.size() - 1)]
# 	target = sword
# 	parent.targetDest = target.global_position
# 	timeSincePicked = ATTENTION_SPAN
# 	timeToReach = REACH_TIMEOUT

# func needs_sword() -> bool:
# 	return parent.swordName == null or parent.swordName == ""
	
# func _process(delta: float) -> void:
# 	# Live track moving targets
# 	if target and is_instance_valid(target):
# 		parent.targetDest = target.global_position

# 	# Check if we've reached the destination
# 	if parent.global_position.distance_to(parent.targetDest) < REACH_THRESHOLD:
# 		timeToReach = 0.0
# 		timeSincePicked = 0.0

# 	# If we haven't reached it in time, force a recheck
# 	if timeToReach > 0.0:
# 		timeToReach -= delta
# 		if timeToReach <= 0.0:
# 			timeSincePicked = 0.0

# 	# Sword seeking bypasses all timers - always takes priority if unarmed
# 	if needs_sword():
# 		if nearbySwords.size() > 0:
# 			pick_sword()
# 		else:
# 			# Wander looking for one, but still respect timeToReach so it doesn't freeze
# 			if timeToReach <= 0.0:
# 				target = null
# 				parent.targetDest = parent.global_position + Vector2(randi_range(-200, 200), randi_range(-200, 200))
# 				timeToReach = REACH_TIMEOUT
# 		return  # always return early, skip rest of logic until armed

# 	timeSincePicked -= delta
# 	if timeSincePicked > 0: return

# 	if nearbyBalls.size() > 0:
# 		if parent.stateMachine.check_state_categories(["Hurt", "Capable"]):
# 			pick_enemy()
# 			return
# 		else:
# 			var choice = randi_range(1, 5)
# 			if choice == 1:
# 				pick_enemy()
# 				return

# 	if nearbyPowerUps.size() > 0:
# 		pick_item()
# 		return

# 	# Wander
# 	target = null
# 	parent.targetDest = parent.global_position + Vector2(randi_range(-200, 200), randi_range(-200, 200))
# 	timeSincePicked = ATTENTION_SPAN
# 	timeToReach = REACH_TIMEOUT
