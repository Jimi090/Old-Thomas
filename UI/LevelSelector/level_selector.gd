extends Control

const LEVEL_BUTTON = preload("uid://cv3q0ojxxmjm3")
@onready var v_box_container: GridContainer = $VBoxContainer


func _ready() -> void:
	const path = "Path1"
	v_box_container.columns = 2

	var levels = GameData.level_progress[path]
	for level in levels:
		var btn: Button = LEVEL_BUTTON.instantiate()
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		btn.text = level[-6]
		btn.pressed.connect(lunch_level.bind("res://Paths/" + path + "/" + level))

		if levels[level]["finished"] == true:
			var style := btn.get_theme_stylebox("normal").duplicate()
			style.bg_color = Color.WEB_GREEN
			btn.add_theme_stylebox_override("normal", style)

		v_box_container.add_child(btn)


func lunch_level(level_scene_path: String):
	var game: Node2D = load(level_scene_path).instantiate()
	var short_path = level_scene_path.substr(6)
	print(short_path)

	# add player
	var player = preload("res://characters/player/player.tscn").instantiate()
	player.position = Vector2(25, 0)
	game.add_child(player)

	# add HUD
	var HUD = preload("res://UI/HUD/HUD.tscn").instantiate()
	HUD.player = player
	game.add_child(HUD)

	# add Key(level end) mechanics
	var key: Key = game.get_node("Key")
	key.path_name = short_path.get_slice("/", 1)
	key.level_name = short_path.get_slice("/", 2)

	# don't add coins that had been collected
	var nodes := game.get_children()
	var coinCounter = 0

	var collectedCoins = GameData.level_progress[short_path.get_slice("/", 1)][short_path.get_slice("/", 2)]
	for node in nodes:
		if node is Coin:
			if coinCounter in collectedCoins:
				node.queue_free()
			else:
				node.coinNumber = coinCounter
				node.pathToItself = level_scene_path.substr(6)
			coinCounter += 1

	get_tree().change_scene_to_node(game)
