extends OptionButton

@onready var screenOld = "main"

func refresh():
	for ball in Player.data.unlockedBalls.keys():
		add_icon_item(load("res://assets/balls/" + ball + ".png"), ball)

func _process(delta: float) -> void:
	if Screens.currentScreen != screenOld:
		clear()
		refresh()
	
	screenOld = Screens.currentScreen
