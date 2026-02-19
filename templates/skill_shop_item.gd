extends AdvanceItem
class_name SkillItem


@export var abilityName = "Poke"
@export var learnButton: Button
@onready var timeLeft = 0
@onready var elixirChecker = PropertyChangeDetector.new(refresh, -1)

func refresh(_o, _n):
	var data = Player.data.getSkillData(abilityName)
	learnButton.text = "%s/%s" % [Misc.format_number(data["deposited"]), Misc.format_number(data["elixir"])]
	if data["deposited"] >= data["elixir"]:
		learnButton.text = "Learned"
		learnButton.disabled = true
	
	desc.text = data["desc"]
	heading.text = abilityName
	imageBox.texture = load("res://assets/ability_buttons/%s.png" % data["texture"])

func learnApplied():
	var abilityData = Player.data.getSkillData(abilityName)

	if abilityData["elixir"] >= Player.data.elixir:
		abilityData["deposited"] += Player.data.elixir
		Player.data.elixir = 0
		refresh(null, null)
	elif abilityData["elixir"] < Player.data.elixir:
		abilityData["deposited"] += Player.data.elixir
		Player.data.elixir -= abilityData["elixir"]
		refresh(null, null)

func configure_item():
	refresh(null, null)

func _process(delta: float) -> void:
	timeLeft -= delta

	if timeLeft < 0:
		timeLeft = 1
		refresh(null, null)
	elixirChecker.update(Player.data.getSkillData(abilityName)["deposited"])
	
func _ready() -> void:
	learnButton.pressed.connect(learnApplied)
