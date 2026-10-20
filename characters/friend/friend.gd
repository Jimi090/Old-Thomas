extends CharacterBody2D

var target_body: Enemy


func _ready() -> void:
	global_position = target_body.global_position + Vector2(-60, -200)
