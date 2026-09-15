extends Area2D

@export var value := 1

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameData.gold += value
		queue_free()
