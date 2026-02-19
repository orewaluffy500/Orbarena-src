extends Button

@onready var panel = get_parent()
@onready var list: ItemList = panel.get_node("ItemList")
@onready var selector = get_tree().current_scene.get_node("MatchSelection").get_node("FighterSelection")

func _pressed():
	
	if list.get_selected_items().size() < 1: return
	
	var item = list.get_item_text(list.get_selected_items()[0]).split(" ")
	
	var form = item[0]
	var price = int(item[1].replace("[", "").replace("]", "").replace("c", ""))
	
	if Player.data.coins < price:
		Dialogs.show_popup("Not enough coins, Required " + str(price) + "c")
		return
	
	if Player.data.unlockedBalls.has(form):
		Dialogs.show_popup("You already have " + form + "!")
		return
	
	Player.data.coins -= price
	Player.data.unlockedBalls[form] = {}
	Sounds.play_sound(Sounds.Buy)
	Dialogs.show_popup("Bought " + form + "!")
	
