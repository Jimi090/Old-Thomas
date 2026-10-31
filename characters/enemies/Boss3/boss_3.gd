extends Enemy

@export var player: Player

const BEAM_PROJECTILE = preload("uid://b8d8jn6cosfs")

var projectiles: Array[Beam_Projectile] = []


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
	super()


func _physics_process(delta: float) -> void:
	super(delta)
	var to_erase: Array[Beam_Projectile] = []
	for beam in projectiles:
		if beam != null:
			beam.global_position = global_position + Vector2(0, -4)
		else:
			# fix this
			to_erase.append(beam)

	for beam in to_erase:
		projectiles.erase(beam)


func create_projectile(_body: Player):
	var beam: Beam_Projectile = BEAM_PROJECTILE.instantiate()
	beam.global_position = global_position + Vector2(0, -4)
	beam.damage = DAMAGE
	beam.target_position = _body.global_position
	beam.scale = Vector2(4, 2)
	get_tree().current_scene.add_child(beam)
	projectiles.append(beam)
