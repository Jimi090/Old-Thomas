extends CharacterBody2D

@export var player: Player
const GRAVITY := 1000


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()
