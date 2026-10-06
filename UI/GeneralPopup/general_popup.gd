extends Panel
class_name GeneralPopup
@onready var label: Label = $Label

@export var text: String


func _ready() -> void:
	label.text = text


func _on_button_pressed() -> void:
	queue_free()
