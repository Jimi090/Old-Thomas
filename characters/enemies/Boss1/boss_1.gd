extends Enemy

const AXE_PROJECTILE = preload("uid://hd1swkxvd3qt")

@onready var weapon: Area2D = $Weapon
@onready var charge_timer: Timer = $ChargeTimer

enum Boss_State {
	IDLE,
	RUN,
	BASIC_ATTACK,
	TAKE_DAMAGE,
	JUMP,
	CHARGE,
}

const CHARGE_SPEED := 300
const CHARGE_DAMAGE := 20
const CHARGE_PUSH_FORCE := 700
const CHARGE_COOLDOWN = 6.0


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

		var bodies_in_weapon_range = weapon.get_overlapping_bodies()

		if not bodies_in_weapon_range.is_empty():
			bodies_in_weapon_range[0].take_damage(CHARGE_DAMAGE)
			bodies_in_weapon_range[0].velocity.x = direction * CHARGE_PUSH_FORCE
			state = Boss_State.RUN
			velocity.x = 0

		if not floor_check.is_colliding():
			velocity.x = 0
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
	if can_attack and not bodies.is_empty() and state != Boss_State.CHARGE:
		state = State.BASIC_ATTACK
		attack(attack_range.get_overlapping_bodies()[0])

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
	var axe1: Axe_Projectile = AXE_PROJECTILE.instantiate()
	var axe2: Axe_Projectile = AXE_PROJECTILE.instantiate()
	var axe3: Axe_Projectile = AXE_PROJECTILE.instantiate()

	axe1.global_position = global_position
	axe2.global_position = global_position
	axe3.global_position = global_position

	axe1.damage = DAMAGE
	axe2.damage = DAMAGE
	axe3.damage = DAMAGE

	axe1.target_position = _body.global_position
	axe2.target_position = _body.global_position + Vector2(0, 50)
	axe3.target_position = _body.global_position + Vector2(0, -50)

	get_tree().current_scene.add_child(axe1)
	get_tree().current_scene.add_child(axe2)
	get_tree().current_scene.add_child(axe3)


@warning_ignore("shadowed_variable_base_class")
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
	update_animation(animated_sprite_2d)
	change_direction_to(direction)


func change_direction_to(new_direction: int):
	direction = new_direction
	if direction > 0:
		floor_check.target_position.x = abs(floor_check.target_position.x)
		wall_check.target_position.x = abs(wall_check.target_position.x)
		collision_shape_2d.position.x = -1 * abs(collision_shape_2d.position.x)
		weapon.scale.x = abs(weapon.scale.x)
		animated_sprite_2d.flip_h = false
	else:
		floor_check.target_position.x = -1 * abs(floor_check.target_position.x)
		wall_check.target_position.x = -1 * abs(wall_check.target_position.x)
		collision_shape_2d.position.x = abs(collision_shape_2d.position.x)
		weapon.scale.x = -1 * abs(weapon.scale.x)
		animated_sprite_2d.flip_h = true


func _on_charge_timer_timeout() -> void:
	for node in get_parent().get_children():
		if node is Player:
			if state != Boss_State.CHARGE:
				charge(node)
	charge_timer.wait_time = CHARGE_COOLDOWN
