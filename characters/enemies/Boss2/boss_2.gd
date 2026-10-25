extends Enemy

@onready var weapon: Area2D = $Weapon
@onready var charge_timer: Timer = $ChargeTimer


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

	super()
