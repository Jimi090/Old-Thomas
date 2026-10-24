extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.when_in_range_of_button(get_parent())


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.when_out_range_of_button(get_parent())
