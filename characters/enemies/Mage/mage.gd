extends Enemy


func _ready() -> void:
	animated_sprite_2d = $AnimatedSprite2D
	attack_range = $AttackRange
	floor_check = $FloorCheck
	wall_check = $WallCheck
	SPEED = 100
	DAMAGE = 10
	ATTACK_COOLDOWN = 1.2
	max_health = 50
	super()


func attack(body: CharacterBody2D):
	var fire: Fire_Projectile = PROJECTILE.instantiate()

	fire.global_position = global_position
	fire.damage = DAMAGE
	fire.target_position = body.global_position
	fire.speed = 250

	get_tree().current_scene.add_child(fire)
