extends Control

@onready var play_btn: Button = $PlayBtn


func _ready() -> void:
	play_btn.pressed.connect(new_game)


func new_game():
	var game = preload("res://MainScene.tscn").instantiate()
	get_tree().change_scene_to_node(game)
