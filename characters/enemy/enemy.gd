extends Character

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_range: Area2D = $AttackRange
@onready var floor_check: RayCast2D = $FloorCheck
@onready var wall_check: RayCast2D = $WallCheck

@export var SPEED := 100
@export var GRAVITY := 1000
@export var JUMP_FORCE := 200

const PROJECTILE = preload("uid://cymdi8bpgwy1w")

var damage := 20
var attack_cooldown := 2.5

var direction: float


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if state != State.BASIC_ATTACK:
		if not floor_check.is_colliding():
			direction *= -1
			floor_check.target_position.x *= -1
			wall_check.target_position.x *= -1

		if wall_check.is_colliding() and is_on_floor():
			velocity.y = -JUMP_FORCE

		velocity.x = direction * SPEED

	animated_sprite_2d.flip_h = direction < 0

	update_animation(animated_sprite_2d)

	move_and_slide()


func _ready() -> void:
	direction = 1
	state = State.RUN
	max_health = 20
	super()


func _on_attack_range_body_entered(body: Character) -> void:
	while body.health > 0 and attack_range.overlaps_body(body):
		if body.position.x > position.x:
			direction = 1
		else:
			direction = -1
		fire_attack(body)
		await get_tree().create_timer(attack_cooldown).timeout
	state = State.RUN


func fire_attack(body: CharacterBody2D):
	var fire: Fire_Projectile = PROJECTILE.instantiate()

	fire.global_position = global_position
	fire.damage = damage
	fire.target_position = body.global_position
	fire.speed = 100

	get_tree().current_scene.add_child(fire)
