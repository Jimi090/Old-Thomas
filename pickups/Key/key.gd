class_name Key
extends Area2D

@export var path_name: String
@export var level_name: String

var destination := "_go_to_main_menu"


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node2D) -> void:
	GameData.level_progress[path_name][level_name]["finished"] = true
	Events.level_completed.emit(path_name, level_name)
	GameData.save_data()
	call_deferred(destination)


func _go_to_main_menu():
	get_tree().change_scene_to_file("uid://dt8lkmju64ybm")


func play_dog_cutscene():
	get_tree().change_scene_to_file("uid://6y8esihxcfby")
