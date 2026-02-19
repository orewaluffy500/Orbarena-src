extends Node


@onready var screens = {
	"main": Vector2(0, 0),
	"arena": Vector2(0, 600),
	"shop": Vector2(1024, 0),
	"upgrades": Vector2(1024, 600),
	"shields": Vector2(2048, 0),
	"skills": Vector2(2048, 600)
}

@onready var currentScreen = "main"

func change_screen(screenName):
	if not screens.has(screenName): return
	
	var pos = screens[screenName]
	get_viewport().get_camera_2d().position = pos
	currentScreen = screenName
