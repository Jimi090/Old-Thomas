extends Node2D

@onready var key: Key = $Key


func _ready() -> void:
	var file_path = scene_file_path.substr(6)
	var path = file_path.get_slice("/", 1)
	var level = file_path.get_slice("/", 2)
	key.path_name = path
	key.level_name = level

	var nodes := get_children()
	var coinCounter = 0

	var collectedCoins = GameData.level_progress[path][level]["coinsCollected"]
	for node in nodes:
		if node is Coin:
			if coinCounter in collectedCoins:
				node.queue_free()
			else:
				node.coinNumber = coinCounter
				node.path = path
				node.level = level
			coinCounter += 1
