extends OptionButton

var last_shield_count := -1


func refresh():
	clear()
	for shield in Player.data.shields:
		add_item(shield)


func _process(delta):
	var current_count = Player.data.shields.size()
	
	# Only refresh when shields list changes
	if current_count != last_shield_count:
		last_shield_count = current_count
		refresh()
	
	visible = item_count > 0
	if not visible:
		return
	
	Player.data.currentShield = get_item_text(get_selected_id())
