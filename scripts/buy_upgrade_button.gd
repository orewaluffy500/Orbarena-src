extends Button

@onready var selectionBox: OptionButton = get_parent().get_node("BallSelection")
@onready var upgradeList: ItemList = get_parent().get_node("ItemList")

@onready var upgrades = {
	"speed": {"price": 80, "limit": 8},
	"damage": {"price": 110, "limit": 4},
	"health": {"price": 100, "limit": 10},
	"heal": {"price": 200, "limit": 1}
}

func _ready():
	var list = get_parent().get_node("ItemList")
	for upgrade in upgrades:
		list.add_item(upgrade + " [" + str(upgrades[upgrade]["price"]) + "$]")

func _pressed():
	var upgradeName = upgradeList.get_item_text(upgradeList.get_selected_items()[0]).split(" ")[0]
	var price = upgrades[upgradeName]["price"]
	var limit = upgrades[upgradeName]["limit"]
	
	var ballName = selectionBox.get_item_text(selectionBox.get_selected_id())
	
	var playerUpgrades = Player.data.unlockedBalls[ballName]
	
	if not playerUpgrades.has(upgradeName): playerUpgrades[upgradeName] = 0
	
	if playerUpgrades[upgradeName] >= limit:
		Dialogs.show_popup("Reached upgrade limit on " + ballName + "." + upgradeName + " (" + limit + ")")
		return
	
	if Player.data.coins < price:
		Dialogs.show_popup("Not enough coins!")
		return
	
	
	playerUpgrades[upgradeName] += 1
	Player.data.coins -= price
	Sounds.play_sound(Sounds.Buy)
	Dialogs.show_popup("Bought " + upgradeName + " for " + ballName + "(" + str(playerUpgrades[upgradeName]) + "/" + str(limit) + ")")
