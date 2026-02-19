extends AdvanceItem
class_name UpgradeMenuItem

@onready var parent: UpgradeMenu = get_parent().get_parent().get_parent()
@export var seeButton: Button

func configure_item(ballName, data):
	configure(load("res://assets/balls/%s.png" % ballName), ballName, "")
