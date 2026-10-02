class_name Coin
extends Area2D

const FLOATING_TEXT = preload("res://UI/FloatingText.tscn")

@export var value := 1
@export var coinNumber: int
@export var path: String
@export var level: String


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameData.gold += value

		# mark as collected
		if path and level:
			GameData.level_progress[path][level]["coinsCollected"].append(coinNumber)
		Events.coin_collected.emit()
		SoundManager.play_coin_sound()
		
		var text_instance = FLOATING_TEXT.instantiate()
		text_instance.global_position = global_position
		get_tree().current_scene.add_child(text_instance)
		text_instance.setup(1)
		
		queue_free()
