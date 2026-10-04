class_name GhostEnemy
extends Enemy

@export var float_speed := 80.0

func _ready() -> void:
	direction = 1
	state = State.RUN
	max_health = 30 
	super()

func _physics_process(delta: float) -> void:

	if state != State.BASIC_ATTACK:
		if wall_check.is_colliding():
			direction *= -1
			floor_check.target_position.x *= -1
			wall_check.target_position.x *= -1

		velocity.x = direction * float_speed
		velocity.y = 0 

	animated_sprite_2d.flip_h = direction < 0

	update_animation(animated_sprite_2d)

	move_and_slide()
