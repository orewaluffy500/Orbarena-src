extends AdvanceItem
class_name FighterPurchaseItem

@onready var ballName = ""
@onready var ballData = {}
@export var buyButton: Button

func configure_item(fighterName: String):
	var config = BallConfig.Config

	if not config.has(fighterName): return

	var data = config[fighterName]

	ballName = fighterName
	ballData = data

	var texture = load("res://assets/balls/%s.png" % fighterName)

	var price = data.get_or_add("price", 0)
	var speed = data["speed"]
	var health = data["health"]

	configure(texture, fighterName, "HP: %d Speed: %d" % [health, speed])
	buyButton.text = "%s$" % Misc.format_number(price)

func update():
	if Player.data.unlockedBalls.has(ballName):
		buyButton.disabled = true
		buyButton.text = "Bought"


func _process(delta: float) -> void:
	update()
