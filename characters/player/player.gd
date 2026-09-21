class_name Player
extends Character

signal health_changed(new_health)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var basic_attack_range: Area2D = $BasicAttackRange

@export var SPEED := 200
@export var GRAVITY := 1000
@export var JUMP_FORCE := 320
@export var attack_multi := 1.0
@export var speed_multi := 1.0

var basic_attack_damage := 10

var direction: float


func _ready() -> void:
	max_health = 100
	super()


func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# walking
	direction = Input.get_axis("left", "right")
	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0
		if direction < 0:
			basic_attack_range.rotation = PI
		else:
			basic_attack_range.rotation = 0
	velocity.x = move_toward(velocity.x, direction * SPEED, delta * 1000)

	# animations
	if state != State.BASIC_ATTACK and state != State.TAKE_DAMAGE and state != State.JUMP:
		if direction != 0:
			state = State.RUN
		else:
			state = State.IDLE
	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_FORCE
		state = State.JUMP

	# basic attack
	if Input.is_action_just_pressed("Basic Attack"):
		basic_attack(basic_attack_range, basic_attack_damage)

	# die when out of map
	if position.y > 300:
		take_damage(10)

	update_animation(animated_sprite_2d)

	move_and_slide()


func _on_animation_finished() -> void:
	if state == State.BASIC_ATTACK or state == State.TAKE_DAMAGE or state == State.JUMP:
		state = State.IDLE


func _on_health_changed():
	health_changed.emit(health)


func heal(amount: int) -> void:
	health = min(max_health, health + amount)
	health_changed.emit(health)


func die():
	# temporary solution
	position = Vector2(25, 0)
	health = max_health


func boost_attack(multiplier: float) -> void:
	basic_attack_damage = int(basic_attack_damage * multiplier)


func boost_speed(multiplier: float) -> void:
	SPEED = int(SPEED * multiplier)
