extends Node

@export var selected = "guy"

@onready var sprite = $Sprite2D
@onready var leftBtn = $Left
@onready var rightBtn = $Right
@onready var label = $Label
@onready var textures = {}
@export var index = 0

func _ready():
	leftBtn.pressed.connect(moveLeft)
	rightBtn.pressed.connect(moveRight)

func _process(delta: float) -> void:
	selected = Player.data.unlockedBalls.keys()[index]

	if not textures.has(selected):
		var tex = load("res://assets/balls/" + selected + ".png")
		sprite.texture = tex
		textures[selected] = tex
	else:
		sprite.texture = textures[selected]

	var data = BallConfig.Config[selected]

	var price = data["price"] if data.has("price") else 0

	label.text = selected + " [" + str(round(price)) + "$]"
	

func moveSelection(normal):
	var size = Player.data.unlockedBalls.size()
	
	index += normal
	if index < 0: index = size - 1
	if index >= size: index = 0

func moveLeft():
	moveSelection(1)

func moveRight():
	moveSelection(-1)
