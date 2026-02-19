extends Node

@export var selected = "guy"

@onready var sprite = $Sprite2D
@onready var leftBtn = $Left
@onready var rightBtn = $Right
@onready var label = $Label
@export var index = 0

func _ready():
	leftBtn.pressed.connect(moveLeft)
	rightBtn.pressed.connect(moveRight)

func _process(delta: float) -> void:
	selected = BallConfig.Config.keys()[index]
	sprite.texture = load("res://assets/balls/" + selected + ".png")
	label.text = selected + " [" + str(round(BallConfig.Config[selected]["price"])) + "$]"

func moveSelection(normal):
	var size = BallConfig.Config.size()
	
	index += normal
	if index < 0: index = size - 1
	if index >= size: index = 0

func moveLeft():
	moveSelection(1)

func moveRight():
	moveSelection(-1)
