class_name Enemy
extends Character

var animated_sprite_2d: AnimatedSprite2D
var attack_range: Area2D
var floor_check: RayCast2D
var wall_check: RayCast2D

var GRAVITY := 1000
var JUMP_FORCE := 200

var SPEED: int
var DAMAGE: int
var ATTACK_COOLDOWN: float

var PROJECTILE = preload("uid://cymdi8bpgwy1w")

var direction: float = 1


func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	attack_range.body_entered.connect(_on_attack_range_body_entered)
	super()


func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if state != State.BASIC_ATTACK:
		# rotate
		if not floor_check.is_colliding():
			direction *= -1
			floor_check.target_position.x *= -1
			wall_check.target_position.x *= -1

		# jump
		if wall_check.is_colliding() and is_on_floor():
			velocity.y = -JUMP_FORCE

		# walk
		velocity.x = direction * SPEED

	animated_sprite_2d.flip_h = direction < 0

	update_animation(animated_sprite_2d)

	move_and_slide()


func _on_attack_range_body_entered(body: Character) -> void:
	state = State.IDLE
	while body.health > 0 and attack_range.overlaps_body(body):
		if body.position.x > position.x:
			direction = 1
		else:
			direction = -1
		call_deferred("attack", body)
		await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	state = State.RUN


func attack(body: CharacterBody2D):
	pass


func die():
	Events.enemy_died.emit()
	super()
