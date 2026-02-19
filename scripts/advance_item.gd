extends Panel
class_name AdvanceItem

@export var heading: Label
@export var desc: Label
@export var imageBox: Sprite2D


func configure(texture: Texture, heading_: String, description: String):
	heading.text = heading_
	desc.text = description
	imageBox.texture = texture
