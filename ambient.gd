extends CanvasModulate

@onready var default = Color.from_rgba8(255, 255, 255, 255)
@onready var arenaMode = Color.from_rgba8(100, 100, 100, 255)

func _process(delta):
	color = default if not Screens.currentScreen == "arena" else arenaMode
