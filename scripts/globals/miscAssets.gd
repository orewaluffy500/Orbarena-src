extends Node

const Blood1 = preload("res://assets/misc/blood1.png")
const Blood2 = preload("res://assets/misc/blood2.png")
const Blood3 = preload("res://assets/misc/blood3.png")

func getRandomBlood():
	var blood = [Blood1, Blood2, Blood3]
	return blood[randi_range(0, blood.size() - 1)]
