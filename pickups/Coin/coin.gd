class_name Coin
extends Area2D

@export var value := 1
@export var coinNumber: int
@export var pathToItself: String


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameData.gold += value

		# mark as collected
		GameData.level_progress[pathToItself.get_slice("/", 1)][pathToItself.get_slice("/", 2)][
			"coinsCollected"
		].append(coinNumber)

		queue_free()
