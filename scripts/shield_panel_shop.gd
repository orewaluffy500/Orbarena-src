extends ShopPanel

func _ready() -> void:
	itemsToCheck = ShieldManager.getFiltered(true)
