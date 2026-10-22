extends CharacterBody2D

var target_body: Enemy
var SPEED := 5000
var DAMAGE := 50


func _ready() -> void:
	if not is_instance_valid(target_body):
		queue_free()
		return

	global_position = target_body.global_position + Vector2(-60, -200)


func _process(delta: float) -> void:
	if not is_instance_valid(target_body):
		queue_free()
		return

	velocity = global_position.direction_to(target_body.global_position) * SPEED * delta
	if global_position.distance_to(target_body.global_position) <= 40:
		target_body.take_damage(DAMAGE)
		queue_free()
	move_and_slide()
