extends Node

const SAVE_PATH := "user://savegame.dat"

signal gold_changed(new_amount)
signal upgrades_changed

const default_upgrades := {
	"Attack_upgrade": { "level": 0, "maxLevel": 5 },
	"Health_upgrade": { "level": 0, "maxLevel": 5 },
	"Speed_upgrade": { "level": 0, "maxLevel": 5 },
	"Revival_upgrade": { "level": 0, "maxLevel": 5 },
}

var active_quests := { }

var displaied_quests := { }

# Variables to save
var gold: int = 0:
	set(value):
		gold = value
		gold_changed.emit(gold)

var level_progress := { }

@onready var upgrades := default_upgrades:
	set(value):
		upgrades = value
		upgrades_changed.emit()

var quests := { }

var game_settings := { }

var variables_to_save := ["gold", "level_progress", "upgrades", "quests", "game_settings"]
###


func save_data():
	var save = {
		"gold": gold,
		"level_progress": level_progress,
		"upgrades": upgrades,
		"quests": quests,
		"game_settings": game_settings,
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(save)


func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var save = file.get_var()

	if save == { }:
		return

	for i in variables_to_save:
		if !save.has(i):
			return

	for variable in save:
		if typeof(save[variable]) == TYPE_DICTIONARY:
			if save[variable] == { }:
				return
		elif typeof(save[variable]) == TYPE_INT:
			if save[variable] == 0:
				return

	gold = save["gold"]
	level_progress = save["level_progress"]
	upgrades = save["upgrades"]
	quests = save["quests"]
	game_settings = save["game_settings"]

	return OK


func clear_save():
	gold = 0
	upgrades = default_upgrades
	get_empty_levels_progress()
	get_default_quests()
	get_default_game_settings()

	save_data()
	load_data()


func get_default_quests():
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
	if len(quests) < 5:
		return
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
	return OK


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


func get_empty_levels_progress():
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
			if levelFileName.ends_with(".remap"):
				levelFileName = levelFileName.left(-6)
			levels.append(levelFileName)

			levelFileName = path_dir.get_next()
		levels.sort()

		level_progress[path] = { }
		for level in levels:
			level_progress[path] = { }
		for level in levels:
			level_progress[path][level] = get_default_level_progress() # Call the function here!


func get_default_level_progress() -> Dictionary:
	return { "finished": false, "coinsCollected": [], "chestsCollected": [] }


func get_default_game_settings():
	game_settings = { "Audio": { "GeneralVolume": 50, "MusicVolume": 50, "SFXVolume": 50 } }


func apply_game_settings():
	change_bus_volume_to("Master", game_settings["Audio"]["GeneralVolume"])
	change_bus_volume_to("Music", game_settings["Audio"]["MusicVolume"])
	change_bus_volume_to("SFX", game_settings["Audio"]["SFXVolume"])


func change_bus_volume_to(bus: String, value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(value / 100.0))


func _ready() -> void:
	var status = load_data()
	if status != OK:
		clear_save()

	apply_game_settings()

	get_active_quests()
	get_displaied_quests()
