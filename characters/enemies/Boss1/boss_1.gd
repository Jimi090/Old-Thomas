extends Enemy

const FIRE_PROJECTILE = preload("uid://cymdi8bpgwy1w")


func _ready() -> void:
	animated_sprite_2d = $AnimatedSprite2D
	attack_range = $AttackRange
	floor_check = $FloorCheck
	wall_check = $WallCheck
	SPEED = GB.mage.speed
	DAMAGE = GB.mage.damage
	ATTACK_COOLDOWN = GB.mage.attack_cooldown
	MAX_HEALTH = GB.mage.health
	JUMP_FORCE = GB.mage.jump_force

	super()


func create_projectile(_body: Player):
	var fire: Fire_Projectile = FIRE_PROJECTILE.instantiate()

	fire.global_position = global_position
	fire.damage = DAMAGE
	fire.target_position = _body.global_position
	fire.speed = 250

	get_tree().current_scene.add_child(fire)
