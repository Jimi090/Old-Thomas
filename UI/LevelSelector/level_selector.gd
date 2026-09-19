extends Control

const LEVEL_BUTTON = preload("uid://cv3q0ojxxmjm3")
@onready var v_box_container: GridContainer = $VBoxContainer


func _ready() -> void:
	const path = "res://Paths/Path1/"
	var dir = DirAccess.open(path)
	v_box_container.columns = 2

	dir.list_dir_begin()

	var level_names := []
	var file_name = dir.get_next()

	while file_name != "":
		level_names.append(file_name)
		file_name = dir.get_next()

	level_names.sort()

	for name in level_names:
		var btn: Button = LEVEL_BUTTON.instantiate()
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		btn.text = name[-6]
		btn.pressed.connect(lunch_level.bind(path + name))
		v_box_container.add_child(btn)


func lunch_level(level_scene_path):
	var game: Node2D = load(level_scene_path).instantiate()
	var player = preload("res://characters/player/player.tscn").instantiate()
	player.position = Vector2(25, 0)
	game.add_child(player)
	var HUD = preload("res://UI/HUD/HUD.tscn").instantiate()
	HUD.player = player
	game.add_child(HUD)
	get_tree().change_scene_to_node(game)
