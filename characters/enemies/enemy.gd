class_name Enemy
extends Character

var animated_sprite_2d: AnimatedSprite2D
var attack_range: Area2D
var floor_check: RayCast2D
var wall_check: RayCast2D

var SPEED: int
var DAMAGE: int
var ATTACK_COOLDOWN: float
var JUMP_FORCE: int

var direction: int = 1
var can_attack := true
var previous_position := Vector2(0, 0)


func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	super()


func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += GB.GRAVITY * delta

	# turn around
	if not floor_check.is_colliding():
		change_direction_to(direction * -1)

	var bodies = attack_range.get_overlapping_bodies()

	# attack
	if can_attack and not bodies.is_empty():
		state = State.BASIC_ATTACK
		attack(attack_range.get_overlapping_bodies()[0])

	# is the player in range
	if bodies.is_empty():
		# is there an obstacle in the way
		if wall_check.is_colliding() and is_on_floor():
			if round(previous_position.x) == round(position.x):
				# turn around if wall is too tall
				change_direction_to(direction * -1)
			else:
				# jump
				velocity.y = -JUMP_FORCE

		# walk
		velocity.x = direction * SPEED

	previous_position = position

	update_animation(animated_sprite_2d)

	move_and_slide()


func attack(body: Character) -> void:
	state = State.BASIC_ATTACK
	can_attack = false
	velocity.x = 0

	if body.position.x > position.x:
		change_direction_to(1)
	else:
		change_direction_to(-1)

	call_deferred("create_projectile", body)

	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true


func change_direction_to(new_direction: int):
	if direction == new_direction:
		return
	direction = new_direction
	floor_check.target_position.x *= -1
	wall_check.target_position.x *= -1
	animated_sprite_2d.flip_h = direction < 0


func create_projectile(_body: Player):
	pass


func die():
	Events.enemy_died.emit()
	super()
