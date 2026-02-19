extends Button


func _pressed() -> void:
	Dialogs.show_tutorial(
		["Welcome to Orbarena,\nLemme show you how to play\nBasically just click the Battle button and start fighting\nYou can block with B, and to actually fight You have to find swords and powerups that spawn on the map.",
		"If you win then you will get money, You can use the money to:\nBuy shields\nBuy stronger orbs\nBuy upgrades for a specific orb and more!"]
	)
