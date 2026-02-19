extends Panel
class_name TutorialPanel


@onready var lines = []
@onready var idx = 0
@onready var writeSpeed = 0.03
@onready var cooldown = 0

func _process(delta: float) -> void:
	if not visible: $Label.visible_characters = 0
	if lines.size() < 1: return

	if cooldown > 0:
		cooldown -= delta
		return
	
	$Label.text = lines[idx]
	if $Label.visible_characters < lines[idx].length() - 1:
		$NextButton.disabled = true
		$Label.visible_characters += 1
		cooldown = writeSpeed
	else:
		$NextButton.disabled = false

func next_line():
	$Label.visible_characters = 0
	if idx + 1 >= lines.size():
		idx = 0
		lines.clear()
		visible = false
		return
		
	idx += 1

func _ready() -> void:
	$NextButton.pressed.connect(next_line)
	$CloseButton.pressed.connect(func():
		visible = false
	)
