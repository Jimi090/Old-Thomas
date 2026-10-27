extends Panel
class_name Dialogue
@onready var label: Label = $Label
var text: String:
	set(value):
		text = value
		if text == "":
			queue_free()
		else:
			change_text()


func _ready() -> void:
	change_text()


func change_text():
	if label != null:
		label.text = text
		label.reset_size()
		await get_tree().process_frame
		size = label.get_minimum_size() + Vector2(24, 12)


func change_sharp_corner_to(corner: Corner):
	var dialogue_theme := get_theme_stylebox("panel")
	dialogue_theme.set_corner_radius_all(4)
	dialogue_theme.set_corner_radius(corner, 0)
