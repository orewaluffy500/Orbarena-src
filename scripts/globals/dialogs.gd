extends Node

var winDialog = null
var popupDialog = null
var errorPopup = null
var tutorialPanel = null

func _ready():
	get_tree().scene_changed.connect(_scene_changed)

func _scene_changed():
	winDialog = get_tree().current_scene.get_node("WinDialog")
	popupDialog = get_viewport().get_camera_2d().get_node("PopupPanel")
	errorPopup = get_viewport().get_camera_2d().get_node("ErrorLabel")
	tutorialPanel = get_viewport().get_camera_2d().get_node("TutorialPanel")

func show_win_dialog(message):
	winDialog.show()
	winDialog.get_node("Label").text = message

func show_popup(message):
	popupDialog.show_message(message)

func show_error(message):
	errorPopup.showMessage(message)

func show_tutorial(messages):
	tutorialPanel.lines = messages
	tutorialPanel.visible = true
