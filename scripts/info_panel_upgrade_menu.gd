extends Panel
class_name InfoPanelUpgradeMenu

@export var heading: Label
@export var desc: Label
@export var sprite: Sprite2D
@export var list: VerticalList
@onready var buttons = {}

func clearList():
	for child in list.get_children():
		child.queue_free()

func hard_refresh(selected):

	var data = BallConfig.Config[selected]

	sprite.texture = load("res://assets/balls/%s.png" % selected)
	heading.text = selected
	desc.text = "Speed %s HP %s" % [data["speed"], data["health"]]

	refresh(selected)
	
func refresh(selected):
	clearList()
	buttons.clear()

	Misc.addUpgrades(selected)

	var data = Player.data.unlockedBalls[selected]

	for upgradeName in data.keys():
		var count = data[upgradeName]

		var defaultData = Misc.upgrades[upgradeName]

		var button = Button.new()
		button.text = "%s [%d$] [%d/%d]" % [upgradeName, defaultData["price"], count, defaultData["max"]]

		button.pressed.connect(func():
			if Player.data.coins < defaultData["price"]:
				Dialogs.show_popup("You're broke!")
				return
			

			if count >= defaultData["max"]:
				Dialogs.show_popup("Reached limit!")
				return
			
			Player.data.coins -= defaultData["price"]
			Sounds.play_sound(Sounds.Buy)
			data[upgradeName] += 1
		)

		buttons[button] = upgradeName
		list.add_child(button)


func _process(_delta):
	for button: Button in buttons.keys():
		var upgradeName = buttons[button]

		var data = Player.data.unlockedBalls[get_parent().selected]
		var defaultData = Misc.upgrades[upgradeName]

		var count = data[upgradeName]

		if data[upgradeName] >= defaultData["max"]:
			button.text = "%s: %d/%d" % [upgradeName, defaultData["max"], defaultData["max"]]
			button.disabled = true
			return
		
		button.text = "%s [%s$] [%s/%s]" % [upgradeName, defaultData["price"], count, defaultData["max"]]
