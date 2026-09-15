extends Node

const SAVE_PATH := "user://save.json"

signal gold_changed(new_amount)
var gold: int = 0:
	set(value):
		gold = value
		gold_changed.emit(gold)


func save_data():
	var data = { "gold": gold }

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))


func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())

	if data == null:
		return

	gold = data.get("gold", 0)


func _ready() -> void:
	load_data()
