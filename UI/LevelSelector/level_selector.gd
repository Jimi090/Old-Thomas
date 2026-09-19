extends Control

const LEVEL_BUTTON = preload("uid://cv3q0ojxxmjm3")
@onready var v_box_container: GridContainer = $VBoxContainer


func _ready() -> void:
	const path = "res://Paths/Path1/"
	var dir = DirAccess.open(path)
	v_box_container.columns = 2

	dir.list_dir_begin()

	var name = dir.get_next()
	while name != "":
		var btn = LEVEL_BUTTON.instantiate()
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		btn.text = name[-6]
		btn.pressed.connect(lunch_level.bind(path + name))
		v_box_container.add_child(btn)
		name = dir.get_next()


func lunch_level(level_path):
	var game = load(level_path).instantiate()
	get_tree().change_scene_to_node(game)
