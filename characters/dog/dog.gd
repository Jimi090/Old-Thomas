extends CharacterBody2D

@export var player: Player
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_check: RayCast2D = $FloorCheck
@onready var wall_check: RayCast2D = $WallCheck
const GRAVITY := 1000
const JUMP_FORCE := 320
var direction := Vector2.ZERO
var speed := 100
enum STATES {
	IDLE,
	RUN,
}
var state: STATES:
	set(value):
		state = value
		play_animation(state)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	direction = global_position.direction_to(player.global_position)
	animated_sprite_2d.flip_h = direction.x < 0
	if direction.x < 0:
		wall_check.scale.x = -1
		floor_check.scale.x = -1
	else:
		wall_check.scale.x = 1
		floor_check.scale.x = 1

	if global_position.distance_to(player.global_position) >= 50:
		state = STATES.RUN
		velocity.x = move_toward(velocity.x, direction.x * speed, delta * 1000)
	else:
		state = STATES.IDLE
		velocity.x = 0

	if is_on_floor() and not floor_check.is_colliding():
		velocity.y = -JUMP_FORCE

	if is_on_floor() and wall_check.is_colliding():
		velocity.y = -JUMP_FORCE

	if global_position.distance_to(player.global_position) >= 200:
		global_position = Vector2(player.global_position.x - 30, player.global_position.y - 10)
		velocity = Vector2.ZERO

	move_and_slide()


func play_animation(state):
	match state:
		STATES.IDLE:
			animated_sprite_2d.play("idle")
		STATES.RUN:
			animated_sprite_2d.play("run")
