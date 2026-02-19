extends OptionButton

@onready var balls = []
@onready var oldUnlockedSize = 0

func refresh():
	if not Player.data: return
	
	for key in BallConfig.Config:
		if not Player.data.unlockedBalls.has(key) or balls.has(key): continue
		
		var data: Dictionary = BallConfig.Config[key]
		if not data.has("secret"):
			balls.append(key)
	
	clear()	
	for ball in balls:
		var icon_ = load("res://assets/balls/" + ball + ".png")
		add_icon_item(icon_, ball)

func _ready():
	
	refresh()

func _process(delta: float) -> void:
	if oldUnlockedSize < Player.data.unlockedBalls.size():
		refresh()
	
	oldUnlockedSize = Player.data.unlockedBalls.size()
	
