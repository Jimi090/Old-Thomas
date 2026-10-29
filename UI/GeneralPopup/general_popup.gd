extends Panel
class_name GeneralPopup

@onready var title_label: Label = $Title
@onready var description_label: Label = $Description

@export var title_text: String
@export var description_text: String


func _ready() -> void:
	title_label.text = title_text
	description_label.text = description_text
	get_tree().paused = true


func _on_button_pressed() -> void:
	queue_free()
	get_tree().paused = false
	await get_tree().process_frame


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_on_button_pressed()
