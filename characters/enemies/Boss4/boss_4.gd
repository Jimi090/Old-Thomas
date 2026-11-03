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


func change_direction_to(new_direction: float):
	if direction == new_direction:
		return
	direction = new_direction
	floor_check.target_position.x *= -1
	wall_check.target_position.x *= -1
	animated_sprite_2d.flip_h = direction > 0
	if direction > 0:
		animated_sprite_2d.offset.x = -23
		collision_shape_2d.position.x = abs(collision_shape_2d.position.x)
		weapon_hitbox.position.x = abs(weapon_hitbox.position.x)
		weapon_hitbox.scale.x = -1 * abs(weapon_hitbox.scale.x)
	else:
		animated_sprite_2d.offset.x = 0
		collision_shape_2d.position.x = -1 * abs(collision_shape_2d.position.x)
		weapon_hitbox.position.x = -1 * abs(weapon_hitbox.position.x)
		weapon_hitbox.scale.x = abs(weapon_hitbox.scale.x)
