extends Enemy

@export var player: Player

const BEAM_PROJECTILE = preload("uid://b8d8jn6cosfs")


func _ready() -> void:
	animated_sprite_2d = $AnimatedSprite2D
	attack_range = $AttackRange
	floor_check = $FloorCheck
	wall_check = $WallCheck
	collision_shape_2d = $CollisionShape2D
	SPEED = GB.boss3.speed
	DAMAGE = GB.boss3.damage
	ATTACK_COOLDOWN = GB.boss3.attack_cooldown
	MAX_HEALTH = GB.boss3.health
	JUMP_FORCE = GB.boss3.jump_force


'func _physics_process(delta: float) -> void:
	print(health)
	if not is_on_floor():
		velocity.y += GB.GRAVITY * delta

	if global_position.x - player.global_position.x < 0:
		direction = 1
	else:
		direction = -1

	velocity.x = direction * SPEED * delta * 100

	move_and_slide()'


func create_projectile(_body: Player):
	var beam: Beam_Projectile = BEAM_PROJECTILE.instantiate()
	beam.global_position = global_position
	beam.damage = DAMAGE
	beam.target_position = _body.global_position
	get_tree().current_scene.add_child(beam)
