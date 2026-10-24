extends Panel
class_name Dialogue
@export var text: String
@onready var label: Label = $Label


func _ready() -> void:
	label.text = text
