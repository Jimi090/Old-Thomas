extends Node

const SAVE_PATH := "user://save.json"
signal gold_changed(new_amount)
signal upgrades_changed


# Variables to save
var gold: int = 0:
	set(value):
		gold = value
		gold_changed.emit(gold)

var level_progress := { }

const default_upgrades := {
	"Attack_upgrade": { "level": 0, "maxLevel": 5 },
	"Health_upgrade": { "level": 0, "maxLevel": 5 },
	"Speed_upgrade": { "level": 0, "maxLevel": 5 },
	"Revival_upgrade": { "level": 0, "maxLevel": 5 },
}

@onready var upgrades := default_upgrades:
	set(value):
		upgrades = value
		upgrades_changed.emit()

var quests := { }

var active_quests := { }

var displaied_quests := { }
###


func save_data():
	var data = {
		"gold": gold,
		"level_progress": level_progress,
		"upgrades": upgrades,
		"quests": quests,
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))


func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		default_quests()
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())

	if data == null:
		default_quests()
		return

	gold = data.get("gold", 0)
	level_progress = data.get("level_progress")
	if data.get("upgrades"):
		upgrades = data.get("upgrades")

	if data.get("quests"):
		quests = change_string_keys_to_int(data.get("quests"))
	else:
		default_quests()


func change_string_keys_to_int(dic: Dictionary):
	var result = { }
	for key in dic:
		result[int(key)] = dic[key]
	return result


func _ready() -> void:
	load_data()
	if level_progress == { }:
		get_empty_level_progress()

	get_active_quests()
	get_displaied_quests()


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
			level_progress[path] = { }
		for level in levels:
			level_progress[path][level] = get_default_level_progress() # Call the function here!


func clear_save():
	gold = 0
	upgrades = default_upgrades
	get_empty_level_progress()
	default_quests()

	save_data()
	get_tree().quit()


func default_quests():
	# kill x monsters
	# finish x path
	# collect x coins
	quests = { }
	for i in 15:
		if i < 5:
			quests[i] = {
				"description": "Kill " + str(i * 2 + 2) + " shadows.",
				"goal": i * 2 + 2,
				"reward": i + 1,
				"completed": false,
				"progress": 0,
				"collected": false,
			}
		elif i < 10:
			var ii := i - 4
			quests[i] = {
				"description": "Finish Path " + str(ii) + ".",
				"goal": 4,
				"reward": ii * 4,
				"completed": false,
				"progress": 0,
				"collected": false,
				"levels_beaten": [],
			}
		elif i < 15:
			var ii := i - 9
			quests[i] = {
				"description": "Collect " + str(ii * 4 + 2) + " coins.",
				"goal": ii * 4 + 2,
				"reward": ii * 2,
				"completed": false,
				"progress": 0,
				"collected": false,
			}


func get_active_quests():
	active_quests["kill"] = null
	active_quests["path"] = null
	active_quests["collect"] = null
	for i in 5:
		if quests[i]["completed"] == false:
			active_quests["kill"] = i
			break
	for i in 5:
		i += 5
		if quests[i]["completed"] == false:
			active_quests["path"] = i
			break

	for i in 5:
		i += 10
		if quests[i]["completed"] == false:
			active_quests["collect"] = i
			break


func get_displaied_quests():
	displaied_quests["kill"] = null
	displaied_quests["path"] = null
	displaied_quests["collect"] = null
	for i in 5:
		if quests[i]["collected"] == false:
			displaied_quests["kill"] = i
			break

	for i in 5:
		i += 5
		if quests[i]["collected"] == false:
			displaied_quests["path"] = i
			break
	for i in 5:
		i += 10
		if quests[i]["collected"] == false:
			displaied_quests["collect"] = i
			break


func get_default_level_progress() -> Dictionary:
	return { "finished": false, "coinsCollected": [], "chestsCollected": [] }
