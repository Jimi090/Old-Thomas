class_name Cinnamon
extends Area2D

const FLOATING_TEXT = preload("res://UI/FloatingText/FloatingText.tscn")

@export var value := 3
@export var cinnamonNumber: int
@export var path: String
@export var level: String


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameData.gold += value

		# mark as collected
		if path and level:
			GameData.level_progress[path][level]["cinnamonsCollected"].append(cinnamonNumber)

		var text_instance = FLOATING_TEXT.instantiate()
		text_instance.global_position = global_position
		get_tree().current_scene.add_child(text_instance)
		text_instance.setup(value)

		queue_free()
