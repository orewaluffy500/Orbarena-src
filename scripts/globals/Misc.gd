extends Node


func cleanUpArena():
	for child in get_tree().current_scene.get_children():
		if child is Ball or child is PowerUp or child is LavaFloor or child is Rock or child is Collectable:
			child.queue_free()
	
func setMapVisible(arena: Arena, map_name: String, visible: bool):
	var mapDefaultPos = arena.mapDefaultPos
	var mapShowPos = arena.mapShowPos

	var maps = arena.maps
	if not maps.has(map_name): return

	var child = arena.get_node_or_null(map_name)
	if not child: return

	if visible:
		child.visible = true
		child.position = mapShowPos
	else:
		child.position = mapDefaultPos
		child.visible = false

func animatePopOut(body: Node2D):
	var original_scale = body.scale

	body.scale = Vector2.ZERO

	var tween = create_tween()
	tween.tween_property(body, "scale", original_scale, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func hideAllMaps(arena: Arena):
	var mapDefaultPos = arena.mapDefaultPos

	for child in arena.get_children():
		if not child is Map: continue

		if not child.visible: continue

		child.visible = false
		child.position = mapDefaultPos
	
func getByLevel(selectors: Dictionary):
	var array = []
	for selector in selectors:
		if Player.data.level >= selector:
			array = selectors[selector]
	
	return array


const upgrades = {
	"speed": {"price": 1, "max": 8},
	"health": {"price": 130, "max": 5},
	"damage": {"price": 150, "max": 10},
	"heal": {"price": 300, "max": 1}
}

func addUpgrades(ballName):
	var data = Player.data.unlockedBalls[ballName]

	for upgrade in upgrades.keys():
		var upgradeData = upgrades[upgrade]
		var max = upgradeData["max"]

		if data.has(upgrade):
			data[upgrade] = data[upgrade] if data[upgrade] < max else max
		else:
			data[upgrade] = 0


func getWeightedList(items):
	var list = []

	for item in items.keys():
		var chance = items[item]

		for i in range(chance):
			list.append(item)
	
	return list


func moveTowards(node: RigidBody2D, target: Vector2, speed):
	var vel = Vector2.ZERO

	if node.position.x < target.x: vel.x = speed
	if node.position.x > target.x: vel.x = -speed
	if node.position.y < target.y: vel.y = speed
	if node.position.y > target.y: vel.y = -speed

	node.linear_velocity = vel

func format_number(n: float) -> String:
	if n >= 1_000_000_000:
		return "%.2fB" % (n / 1_000_000_000.0)
	elif n >= 1_000_000:
		return "%.2fM" % (n / 1_000_000.0)
	elif n >= 1_000:
		return "%.2fK" % (n / 1_000.0)
	else:
		return str(int(n))
