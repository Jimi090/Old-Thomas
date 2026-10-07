extends Enemy

const GHOST_PROJECTILE = preload("uid://c6xfvvv4p5msq")


func _ready() -> void:
	animated_sprite_2d = $AnimatedSprite2D
	attack_range = $AttackRange
	floor_check = $FloorCheck
	wall_check = $WallCheck
	SPEED = GB.ghost.speed
	DAMAGE = GB.ghost.damage
	ATTACK_COOLDOWN = GB.ghost.attack_cooldown
	MAX_HEALTH = GB.ghost.health
	JUMP_FORCE = GB.ghost.jump_force

	super()


func attack(body: CharacterBody2D):
	var ghost_proj: Ghost_Projectile = GHOST_PROJECTILE.instantiate()

	ghost_proj.global_position = global_position
	ghost_proj.damage = DAMAGE
	ghost_proj.target_position = body.global_position
	ghost_proj.speed = 200

	get_tree().current_scene.add_child(ghost_proj)
