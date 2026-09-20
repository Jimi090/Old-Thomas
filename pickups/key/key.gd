class_name Key
extends Area2D

@export var path_name: String
@export var level_name: String


func _on_body_entered(_body: Node2D) -> void:
	GameData.level_progress[path_name][level_name]["finished"] = true
	call_deferred("_go_to_main_menu")


func _go_to_main_menu():
	GameData.save_data()
	var MainMenu = load("res://UI/MainMenu/MainMenu.tscn").instantiate()
	get_tree().change_scene_to_node(MainMenu)
