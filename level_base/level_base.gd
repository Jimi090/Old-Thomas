extends Node2D

@onready var key: Key = $Key
@onready var player: Player = $Player
@onready var hud: HUD = $HUD
@onready var dog: CharacterBody2D = $Dog


func _ready() -> void:
	var file_path = scene_file_path.substr(6)
	var path = file_path.get_slice("/", 1)
	var level = file_path.get_slice("/", 2)

	if path[-1] == "1":
		if dog:
			dog.queue_free()
		player.ability1_used = true
		hud.get_child(0).get_node("Ability1CooldownBar").hide()
	elif path[-1] == "2":
		player.ability1_used = true
		hud.get_child(0).get_node("Ability1CooldownBar").hide()

	if (
		int(level[-6]) != len(GameData.level_progress[path])
		or not FileAccess.file_exists(
			"res://Paths/BossArena" + path[-1] + "/boss_arena_" + path[-1] + ".tscn"
		)
	):
		# normal level
		key.path_name = path
		key.level_name = level
	else:
		# last level (tp to boss fight)
		key.body_entered.disconnect(key._on_body_entered)
		key.body_entered.connect(change_scene_to_boss_arena.bind(path))

	var nodes := get_children()
	var coinCounter := 0
	var chestCounter := 0
	var cinnamonCounter := 0

	var collectedCoins = GameData.level_progress[path][level]["coinsCollected"]
	var collectedChests = GameData.level_progress[path][level]["chestsCollected"]
	var collectedCinnamons = GameData.level_progress[path][level]["cinnamonsCollected"]

	for node in nodes:
		if node is Coin:
			if coinCounter in collectedCoins:
				node.queue_free()
			else:
				node.coinNumber = coinCounter
				node.path = path
				node.level = level
			coinCounter += 1
		if node is Chest:
			if chestCounter in collectedChests:
				node.opened = true
				node.animated_sprite_2d.play("opened")
			else:
				node.chest_number = chestCounter
				node.path = path
				node.level = level
			chestCounter += 1
		if node is Cinnamon:
			if cinnamonCounter in collectedCinnamons:
				node.queue_free()
			else:
				node.cinnamonNumber = cinnamonCounter
				node.path = path
				node.level = level
			cinnamonCounter += 1

	player.player_died.connect(_on_player_death)


func _on_player_death():
	call_deferred("reload_level")


func reload_level():
	get_tree().reload_current_scene()


func change_scene_to_boss_arena(_body, path):
	var file_path = "res://Paths/BossArena" + path[-1] + "/boss_arena_" + path[-1] + ".tscn"

	if FileAccess.file_exists(file_path):
		call_deferred("change_scene", file_path)
	else:
		print('xd')


func change_scene(file_path):
	get_tree().change_scene_to_file(file_path)
