extends Node2D

@onready var key: Key = $Key
@onready var player: Player = $Player


func _ready() -> void:
	var file_path = scene_file_path.substr(6)
	var path = file_path.get_slice("/", 1)
	var level = file_path.get_slice("/", 2)
	key.path_name = path
	key.level_name = level

	var nodes := get_children()
	var coinCounter := 0
	var chestCounter := 0

	var collectedCoins = GameData.level_progress[path][level]["coinsCollected"]
	var collectedChests = GameData.level_progress[path][level]["chestsCollected"]
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
	player.player_died.connect(_on_player_death)


func _on_player_death():
	get_tree().reload_current_scene()
