extends Control

const LEVEL_BUTTON = preload("uid://cv3q0ojxxmjm3")
@onready var v_box_container: GridContainer = $VBoxContainer
@export var path: String


func _ready() -> void:
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
	get_tree().change_scene_to_node(game)
