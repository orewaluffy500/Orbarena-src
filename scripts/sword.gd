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
@onready var shieldSystem = ShieldManager



func _process(delta: float) -> void:
	if parent.swordName == null or parent.swordName == "": return
	
	if parent.cooldown > 0:
		parent.cooldown -= delta
		return
	
	for body in area2D.get_overlapping_bodies():

		if body is Ball:
			var res = Misc.handleHit(parent, body, global_position)
			if res != 1:
				$Sprite2D.flip_h = not $Sprite2D.flip_h
				get_parent().rotationNormal *= -1
		
