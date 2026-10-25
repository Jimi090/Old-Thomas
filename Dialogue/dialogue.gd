extends Panel
class_name Dialogue
@export var text: String
@onready var label: Label = $Label


func _ready() -> void:
	label.text = text


func change_sharp_corner_to(corner: Corner):
	var dialogue_theme := get_theme_stylebox("panel")
	dialogue_theme.set_corner_radius_all(4)
	dialogue_theme.set_corner_radius(corner, 0)
