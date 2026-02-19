extends RigidBody2D
class_name Sword

var cooldown = 0.0
const MAX_COOLDOWN = .5

@onready var parent: Ball = self.get_parent().get_parent()
@onready var critLabel: Label = parent.get_node("CriticalHitLabel")
@onready var winDialog = get_tree().current_scene.get_node("WinDialog")
@onready var hitCounter = 0
@onready var area2D = $Area
@onready var CRITICAL_HIT_COUNT = randi_range(3, 6)
@onready var bloodTemplate = preload("res://templates/blood.tscn")
@onready var shieldSystem = ShieldManager
@onready var damageLabel = preload("res://templates/damage_label.tscn")


func produce_dmgLabel(damage):
	var posX = randf_range(global_position.x - 50, global_position.x + 50)
	var posY = randf_range(global_position.y - 50, global_position.y + 50)

	var pos = Vector2(posX, posY)

	var clone: DamageLabel = damageLabel.instantiate()

	clone.init(str(damage))
	get_tree().current_scene.add_child(clone)

	clone.global_position = pos

func _process(delta: float) -> void:
	if parent.swordName == null or parent.swordName == "": return
	
	if parent.cooldown > 0:
		parent.cooldown -= delta
		return
	
	for body in area2D.get_overlapping_bodies():

		if body is Ball:
			var selfSpawner = parent.spawner
			var selfID = parent.get_instance_id()
				
			if body.get_node("CollisionShape2D").disabled == true: return
			
			var otherSpawner = body.spawner
			var otherID = body.get_instance_id()
			
			if otherSpawner == selfSpawner or otherID == selfSpawner or selfID == otherSpawner: return
			
			hitCounter += 1
			
			var damageOffset = randf_range(0.8, 1.3) + parent.damage_mul
			var damage = parent.damage
			
			if hitCounter >= 5:
				hitCounter = 0
				if body.shielded:
					body.shielded = false
					body.canShield = false
					Sounds.play_sound(Sounds.ShieldBreak)
			
			if body.shielded and (body.shield != null and body.shield != ""):
				damage /= shieldSystem.ShieldData[body.shield]["reduction"]
			
			body.health -= damage * damageOffset
			body.health = int(body.health)
			body.tookDamage = true
			parent.hitBody = null if randi_range(1, 2) == 1 and body.shielded else body
			spawn_blood(body.position)
			produce_dmgLabel(round(damage * damageOffset))
			
			parent.cooldown = parent.MAX_COOLDOWN
			
			if not body.shielded:
				Sounds.play_sound(Sounds.Slash, randf_range(0.75, 1.25))
			else:
				Sounds.play_sound_batch("shield")
			
			$Sprite2D.flip_h = not $Sprite2D.flip_h
			get_parent().rotationNormal *= -1

func spawn_blood(pos):
	var blood = bloodTemplate.instantiate()
	get_tree().current_scene.add_child(blood)
	blood.global_position = pos
