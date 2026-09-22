class_name Coin
extends Area2D

@export var value := 1
@export var coinNumber: int
@export var pathToItself: String


func _ready() -> void:
	var path_folder = pathToItself.get_slice("/", 1)
	var current_level = get_tree().current_scene.scene_file_path.get_file()
	if GameData.level_progress.has(path_folder) and GameData.level_progress[path_folder].has(
			current_level
		):
		if GameData.level_progress[path_folder][current_level].has(coinNumber):
			queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameData.gold += value

		# mark as collected
		GameData.level_progress[pathToItself.get_slice("/", 1)][
			get_tree().current_scene.scene_file_path.get_file()
		][coinNumber] = true

		queue_free()
