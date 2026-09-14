extends CharacterBody2D

const SPEED := 200
const GRAVITY := 1000
const JUMP_FORCE := 320

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var basic_attack_range: Area2D = $BasicAttackRange

var direction : float

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	direction = Input.get_axis("left","right")
	if direction != 0:
		animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = direction < 0
	else:
		animated_sprite_2d.play("idle")
	velocity.x = move_toward(velocity.x,direction*SPEED,delta*1000)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_FORCE

	move_and_slide()
