extends Enemy

@onready var weapon: Area2D = $Weapon
@onready var meteor_shower_timer: Timer = $MeteorShowerTimer

@export var player: Player

const FIRE_PROJECTILE = preload("uid://cymdi8bpgwy1w")

enum Boss_State {
	IDLE,
	RUN,
	TAKE_DAMAGE,
	JUMP,
}

var METEOR_DAMAGE := 30
var METEOR_SHOWER_COOLDOWN := 2.0


func _ready() -> void:
	animated_sprite_2d = $AnimatedSprite2D
	attack_range = $AttackRange
	floor_check = $FloorCheck
	wall_check = $WallCheck
	collision_shape_2d = $CollisionShape2D
	SPEED = GB.boss2.speed
	DAMAGE = GB.boss2.damage
	ATTACK_COOLDOWN = GB.boss2.attack_cooldown
	MAX_HEALTH = GB.boss2.health
	JUMP_FORCE = GB.boss2.jump_force

	meteor_shower_timer.wait_time = METEOR_SHOWER_COOLDOWN
	meteor_shower_timer.start()
	super()


func _physics_process(delta: float) -> void:
	if state != Boss_State.JUMP:
		if player:
			direction = -1 * global_position.direction_to(player.global_position).x
		else:
			direction = 0

		var bodies = attack_range.get_overlapping_bodies()

		if bodies.is_empty() and not floor_check.is_colliding():
			direction = 0
		elif not bodies.is_empty() and not floor_check.is_colliding():
			state = Boss_State.JUMP
			change_direction_to(direction * -1)
			velocity.y = -JUMP_FORCE
	else:
		if is_on_floor():
			state = State.RUN

	velocity.x = direction * GB.boss2.speed * delta * 100

	# gravity
	if not is_on_floor():
		velocity.y += GB.GRAVITY * delta

	update_animation(animated_sprite_2d)

	move_and_slide()


func meteor_shower():
	var offset := randi_range(0, -80)
	for i in 10:
		var meteor := FIRE_PROJECTILE.instantiate()
		meteor.scale = Vector2(4, 4)
		meteor.global_position = Vector2(i * 80 + offset, 0)
		meteor.target_position = Vector2(i * 80 + offset, 256)
		meteor.damage = METEOR_DAMAGE
		get_tree().current_scene.add_child(meteor)


func _on_meteor_shower_timer_timeout() -> void:
	meteor_shower()


func attack(_body: Character) -> void:
	pass
