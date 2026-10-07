extends Control

const LEVEL_BUTTON = preload("uid://cv3q0ojxxmjm3")
const GENERAL_POPUP = preload("uid://doyer7g4qd2mn")

@onready var v_box_container: GridContainer = $VBoxContainer
@export var path: String


func _ready() -> void:
	v_box_container.columns = 2

	var levels = GameData.level_progress[path]
	var previous_level = null

	for level in levels:
		var btn: Button = LEVEL_BUTTON.instantiate()
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		btn.text = level[-6]

		if levels[level]["finished"] == true:
			var style := btn.get_theme_stylebox("normal").duplicate()
			style.bg_color = Color.WEB_GREEN
			btn.add_theme_stylebox_override("normal", style)

			btn.pressed.connect(lunch_level.bind("res://Paths/" + path + "/" + level))
		else:
			if !previous_level or levels[previous_level]["finished"] == true:
				btn.pressed.connect(lunch_level.bind("res://Paths/" + path + "/" + level))
			else:
				btn.pressed.connect(show_level_locked_popup)

		previous_level = level
		v_box_container.add_child(btn)


func lunch_level(level_scene_path: String):
	var game: Node2D = load(level_scene_path).instantiate()
	get_tree().change_scene_to_node(game)


func create_general_popup(title: String, description: String):
	var popup: GeneralPopup = GENERAL_POPUP.instantiate()
	popup.title_text = title
	popup.description_text = description
	popup.position = (get_viewport_rect().size - popup.size) / 2
	add_child(popup)
	popup.show()


func show_level_locked_popup():
	var title := "Level Locked"
	var desc := "Before you can enter this level, finish previous levels"
	create_general_popup(title, desc)
