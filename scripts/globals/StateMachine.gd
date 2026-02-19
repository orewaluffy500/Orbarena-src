extends Node
class_name StateMachine


const STATE_HEALTHY         = 0
const STATE_STRONG          = 1
const STATE_MILDLY_INJURED  = 2
const STATE_INJURED         = 3
const STATE_HEAVILY_INJURED = 4
const STATE_ONE_HP          = 5

const categories = {
	"Capable": [STATE_HEALTHY, STATE_STRONG],
	"Hurt": [STATE_INJURED, STATE_MILDLY_INJURED],
	"Deathrow": [STATE_HEAVILY_INJURED, STATE_ONE_HP]
}

@onready var state = -1
@onready var node: Ball
@onready var healthChecker: PropertyChangeDetector
@onready var originalHealth: int

func create(node_: Ball) -> void:
	node = node_
	originalHealth = node.health
	healthChecker = PropertyChangeDetector.new(recheck_state, originalHealth)

func check_state(desired):
	return state == desired

func check_state_category(category):
	return categories[category].has(state)

func check_state_categories(categories_):
	for category in categories_:
		if categories.has(category): return true

	return false

func recheck_state(oldHP: int, newHP: int):
	if newHP > originalHealth + 10:
		state = STATE_STRONG
	
	if newHP >= originalHealth - 10 and newHP < originalHealth + 10:
		state = STATE_HEALTHY
	
	if newHP < originalHealth - 10:
		state = STATE_MILDLY_INJURED
	
	if newHP < originalHealth - 30:
		state = STATE_INJURED
	
	if newHP < originalHealth - 50:
		state = STATE_HEAVILY_INJURED
	
	if newHP <= 5:
		state = STATE_ONE_HP


func _process(delta: float) -> void:
	if not node: return
	healthChecker.update(node.health)
