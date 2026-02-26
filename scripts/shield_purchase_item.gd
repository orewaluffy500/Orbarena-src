extends AdvanceItem
class_name ShieldPurchaseItem

var shieldName = ""
var shieldData = {}
@export var buyButton: Button

func configure_item(shieldName_):
	print(shieldName_)
	var config = ShieldManager.ShieldData

	if not config.has(shieldName_): return

	var data = config[shieldName_]

	shieldName = shieldName_
	shieldData = data

	var texture = load("res://assets/shields/%s.png" % shieldName)

	var price = data["price"]
	var slowness = data["slowness"]
	var defense = data["reduction"]

	configure(texture, shieldName, "Defense: %d Slowness: %d" % [defense, slowness])
	buyButton.text = "%s$" % Misc.format_number(price)


func update():
	if Player.data.shields.has(shieldName):
		buyButton.disabled = true
		buyButton.text = "Bought"
	else:
		buyButton.text = "$" + Misc.format_number(shieldData["price"])
		buyButton.disabled = false


func _process(delta: float) -> void:
	update()
