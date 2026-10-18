extends Enemy

const FIRE_PROJECTILE = preload("uid://cymdi8bpgwy1w")

@onready var weapon: Area2D = $Weapon

enum Boss_State {
	IDLE,
	RUN,
	BASIC_ATTACK,
	TAKE_DAMAGE,
	JUMP,
	CHARGE,
}

const CHARGE_SPEED := 100
const CHARGE_DAMAGE := 10
const CHARGE_PUSH_FORCE := 500


func _ready() -> void:
	animated_sprite_2d = $AnimatedSprite2D
	attack_range = $AttackRange
	floor_check = $FloorCheck
	wall_check = $WallCheck
	collision_shape_2d = $CollisionShape2D
	SPEED = GB.boss1.speed
	DAMAGE = GB.boss1.damage
	ATTACK_COOLDOWN = GB.boss1.attack_cooldown
	MAX_HEALTH = GB.boss1.health
	JUMP_FORCE = GB.boss1.jump_force

	super()


func _physics_process(delta: float) -> void:
	# charge
	if state == Boss_State.CHARGE:
		velocity.x = direction * CHARGE_SPEED
		var bodies = weapon.get_overlapping_bodies()
		if not bodies.is_empty():
			bodies[0].take_damage(CHARGE_DAMAGE)
			bodies[0].velocity.x = direction * CHARGE_PUSH_FORCE
			state = Boss_State.RUN
		if not floor_check.is_colliding():
			state = Boss_State.RUN

		move_and_slide()
		return
	# gravity
	if not is_on_floor():
		velocity.y += GB.GRAVITY * delta

	# turn around
	if not floor_check.is_colliding():
		change_direction_to(direction * -1)

	var bodies = attack_range.get_overlapping_bodies()

	# attack
	if can_attack and not bodies.is_empty():
		'state = State.BASIC_ATTACK
		attack(attack_range.get_overlapping_bodies()[0])'
		#tmp
		if state != Boss_State.RUN:
			charge(bodies[0])

	# if player not in range
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


func create_projectile(_body: Player):
	var fire: Fire_Projectile = FIRE_PROJECTILE.instantiate()

	fire.global_position = global_position
	fire.damage = DAMAGE
	fire.target_position = _body.global_position
	fire.speed = 250

	get_tree().current_scene.add_child(fire)


func update_animation(animated_sprite_2d):
	match state:
		Boss_State.IDLE:
			animated_sprite_2d.play("idle")
		Boss_State.RUN:
			animated_sprite_2d.play("run")
		Boss_State.BASIC_ATTACK:
			animated_sprite_2d.play("basic_attack")
		Boss_State.TAKE_DAMAGE:
			animated_sprite_2d.play("take_damage")
		Boss_State.JUMP:
			animated_sprite_2d.play("jump")
		Boss_State.CHARGE:
			animated_sprite_2d.play("charge")


func charge(player: Character):
	state = Boss_State.CHARGE

	var new_direction: int = global_position.x - player.global_position.x < 0

	if new_direction == 0:
		new_direction = -1

	direction = new_direction
	change_direction_to(direction)


func change_direction_to(new_direction: int):
	if direction == new_direction:
		return
	direction = new_direction
	floor_check.target_position.x *= -1
	wall_check.target_position.x *= -1
	collision_shape_2d.position.x *= -1
	weapon.scale.x *= -1
	animated_sprite_2d.flip_h = direction < 0
