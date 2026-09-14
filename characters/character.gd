class_name Character
extends CharacterBody2D

@export var max_health : int

var health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health

func take_damage(damage: int):
	health -= damage

	if health <= 0:
		die()

func is_moving():
	return velocity.x != 0

func die():
	queue_free()
