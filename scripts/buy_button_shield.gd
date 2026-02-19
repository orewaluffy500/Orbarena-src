extends Button

@onready var list: ItemList = get_parent().get_node("ItemList")

func _pressed():
	var item = list.get_item_text(list.get_selected_items()[0]).split(" ")
	
	var form = item[0]
	var price = int(item[1].replace("[", "").replace("]", "").replace("c", ""))
	
	if Player.data.shields.has(form):
		Dialogs.show_popup("You already have the " + form + " shield!")
		return
	
	if Player.data.coins < price:
		Dialogs.show_popup("Not enough coins")
		return
	
	Player.data.coins -= price
	Sounds.play_sound(Sounds.Buy)
	Player.data.shields.append(form)
	Player.data.currentShield = form
	
