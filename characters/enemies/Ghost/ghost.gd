extends Enemy

const FIRE_PROJECTILE = preload("uid://cymdi8bpgwy1w")


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
	var fire: Fire_Projectile = FIRE_PROJECTILE.instantiate()

	fire.global_position = global_position
	fire.damage = DAMAGE
	fire.target_position = body.global_position
	fire.speed = 250

	get_tree().current_scene.add_child(fire)
