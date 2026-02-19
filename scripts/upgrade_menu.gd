extends Panel
class_name UpgradeMenu

@export var selected = "guy"

@onready var template = preload("res://templates/upgrade_menu_item.tscn")
@onready var ballList = $Balls/VerticalList
@onready var infoPanel = $InfoPanel
@onready var screenChecker = PropertyChangeDetector.new(onScreenChange, Screens.currentScreen)
@onready var items = []

func onScreenChange(_old, _new):
	for ballName in Player.data.unlockedBalls.keys():
		if items.has(ballName): continue

		var data = BallConfig.Config[ballName]

		var clone: UpgradeMenuItem = template.instantiate()
		clone.configure_item(ballName, data)
		clone.seeButton.pressed.connect(func():
			selected = ballName
			infoPanel.hard_refresh(selected)
		)

		ballList.add_child(clone)
		items.append(ballName)
	
func _process(delta: float) -> void:
	screenChecker.update(Screens.currentScreen)
