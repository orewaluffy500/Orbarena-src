extends Panel
class_name ShopPanel

@export var itemTemplate: PackedScene
@onready var list: VerticalList = $ScrollContainer/VerticalList
@onready var screenChecker: PropertyChangeDetector = PropertyChangeDetector.new(refresh, Screens.currentScreen)
@onready var items = {
}
@onready var itemsToCheck

func _ready():
	itemsToCheck = BallConfig.getFiltered(true)

func refresh(old, new):
	for itemName in itemsToCheck:

		if items.has(itemName):
			items[itemName].update()
			continue
		
		var clone = itemTemplate.instantiate()
		clone.configure_item(itemName)

		list.add_child(clone)
		items[itemName] = clone

func _process(delta: float) -> void:
	screenChecker.update(Screens.currentScreen)
