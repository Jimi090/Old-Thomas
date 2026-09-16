extends Control

@onready var path_1: Button = $Path1


func _ready() -> void:
	path_1.pressed.connect(_on_click_path1)


func _on_click_path1():
	var game = preload("res://MainScene.tscn").instantiate()
	get_tree().change_scene_to_node(game)
