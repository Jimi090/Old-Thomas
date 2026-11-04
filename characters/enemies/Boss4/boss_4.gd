extends Enemy

@export var player: Player
@onready var weapon_hitbox: Area2D = $WeaponHitbox

enum BossState {
	IDLE,
	RUN,
	BASIC_ATTACK,
	TAKE_DAMAGE,
	THRUST,
}
const THRUST_DAMAGE := 20
var has_thrust_hit := false


func _ready() -> void:
	animated_sprite_2d = $AnimatedSprite2D
	attack_range = $AttackRange
	floor_check = $FloorCheck
	wall_check = $WallCheck
	collision_shape_2d = $CollisionShape2D
	SPEED = GB.boss4.speed
	DAMAGE = GB.boss4.damage
	ATTACK_COOLDOWN = GB.boss4.attack_cooldown
	MAX_HEALTH = GB.boss4.health
	JUMP_FORCE = GB.boss4.jump_force
	super()
	change_direction_to(-1)

	get_tree().current_scene.get_child(6).queue_free()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GB.GRAVITY * delta

	if not floor_check.is_colliding():
		change_direction_to(-1 * direction)
		velocity.x = direction * SPEED * delta * 100
		move_and_slide()
		return

	if state == BossState.THRUST:
		var weapon_bodies := weapon_hitbox.get_overlapping_bodies()
		if not weapon_bodies.is_empty() and not has_thrust_hit:
			weapon_bodies[0].take_damage(THRUST_DAMAGE)
			weapon_bodies[0].velocity.x = direction * 250
			has_thrust_hit = true

		move_and_slide()
		return
	else:
		has_thrust_hit = false

	var bodies = attack_range.get_overlapping_bodies()

	'if can_attack and not bodies.is_empty():
		attack(bodies[0])'

	if bodies.is_empty():
		if global_position.x - player.global_position.x >= 0:
			change_direction_to(-1)
		else:
			change_direction_to(1)

		velocity.x = direction * SPEED * delta * 100

	update_animation(animated_sprite_2d)
	move_and_slide()


@warning_ignore("shadowed_variable_base_class")
func update_animation(animated_sprite_2d):
	match state:
		State.IDLE:
			animated_sprite_2d.play("idle")
		State.RUN:
			animated_sprite_2d.play("run")
		State.BASIC_ATTACK:
			animated_sprite_2d.play("basic_attack")
		State.TAKE_DAMAGE:
			animated_sprite_2d.play("take_damage")
		BossState.TAKE_DAMAGE:
			animated_sprite_2d.play("take_damage")
		BossState.THRUST:
			animated_sprite_2d.play("thrust_attack")


func _on_thrust_timer_timeout() -> void:
	sword_thrust()


func sword_thrust():
	state = BossState.THRUST
	update_animation(animated_sprite_2d)
	velocity.x = direction * 400


func change_direction_to(new_direction: float):
	if direction == new_direction:
		return
	direction = new_direction
	floor_check.target_position.x *= -1
	wall_check.target_position.x *= -1
	animated_sprite_2d.flip_h = direction > 0
	if direction > 0:
		animated_sprite_2d.offset.x = 22
		collision_shape_2d.scale.x = -1 * abs(collision_shape_2d.scale.x)
		weapon_hitbox.position.x = abs(weapon_hitbox.position.x) - 3
		weapon_hitbox.scale.x = -1 * abs(weapon_hitbox.scale.x)
	else:
		animated_sprite_2d.offset.x = 0
		collision_shape_2d.scale.x = abs(collision_shape_2d.scale.x)
		weapon_hitbox.position.x = -12.667
		weapon_hitbox.scale.x = abs(weapon_hitbox.scale.x)


func _on_animation_finished() -> void:
	if state == State.BASIC_ATTACK or state == State.TAKE_DAMAGE or state == BossState.THRUST:
		state = State.RUN
