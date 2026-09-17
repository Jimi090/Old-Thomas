extends Character

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_range: Area2D = $AttackRange
@onready var floor_check: RayCast2D = $FloorCheck
@onready var wall_check: RayCast2D = $WallCheck

@export var SPEED := 100
@export var GRAVITY := 1000
@export var JUMP_FORCE := 200

var damage := 20

var direction: float


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if not floor_check.is_colliding():
		direction *= -1
		floor_check.target_position.x *= -1
		wall_check.target_position.x *= -1

	if wall_check.is_colliding() and is_on_floor():
		velocity.y = -JUMP_FORCE

	velocity.x = direction * SPEED

	animated_sprite_2d.flip_h = direction < 0

	update_animation(animated_sprite_2d)

	move_and_slide()


func _ready() -> void:
	direction = 1
	state = State.RUN
