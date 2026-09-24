class_name Coin
extends Area2D

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

		queue_free()
