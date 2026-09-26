extends Node

const SAVE_PATH := "user://save.json"
signal gold_changed(new_amount)
signal upgrades_changed
const default_level_progress = { "finished": false, "coinsCollected": [], "chestsCollected": [] }

# Variables to save
var gold: int = 0:
	set(value):
		gold = value
		gold_changed.emit(gold)

var level_progress := { }

var upgrades := {
	"Attack_upgrade": { "level": 0, "maxLevel": 5 },
	"Health_upgrade": { "level": 0, "maxLevel": 5 },
}:
	set(value):
		upgrades = value
		upgrades_changed.emit()

###


func save_data():
	var data = { "gold": gold, "level_progress": level_progress, "upgrades": upgrades }

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
	level_progress = data.get("level_progress")
	if data.get("upgrades"):
		upgrades = data.get("upgrades")


func _ready() -> void:
	load_data()
	if level_progress == { }:
		get_empty_level_progress()


func get_empty_level_progress():
	var paths_dir := DirAccess.open("res://Paths/")
	paths_dir.list_dir_begin()
	var paths := []
	var pathFileName := paths_dir.get_next()

	while pathFileName != "":
		paths.append(pathFileName)

		pathFileName = paths_dir.get_next()
	paths.sort()

	for path in paths:
		var path_dir := DirAccess.open("res://Paths/" + path)
		path_dir.list_dir_begin()
		var levels := []
		var levelFileName := path_dir.get_next()

		while levelFileName != "":
			levels.append(levelFileName)

			levelFileName = path_dir.get_next()
		levels.sort()

		level_progress[path] = { }
		for level in levels:
			level_progress[path][level] = default_level_progress


func clear_save():
	gold = 0
	upgrades = {
		"Attack_upgrade": { "level": 0, "maxLevel": 5 },
		"Health_upgrade": { "level": 0, "maxLevel": 5 },
	}
	get_empty_level_progress()
	save_data()
	get_tree().quit()
