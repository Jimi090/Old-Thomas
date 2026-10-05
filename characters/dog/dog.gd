extends CharacterBody2D

@export var player: Player
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_check: RayCast2D = $FloorCheck
@onready var wall_check: RayCast2D = $WallCheck
@onready var attack_range: Area2D = $AttackRange

const GRAVITY := 1000
const JUMP_FORCE := 320
var direction := Vector2.ZERO
var speed := 100
var damage := 10
var attack_cooldown := 4
enum STATES {
	IDLE,
	RUN,
}
var state: STATES:
	set(value):
		state = value
		play_animation(state)
var target: CharacterBody2D


func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if !target:
		target = player
	walk_towards(player, delta)

	# jump when obstacle
	if is_on_floor() and not floor_check.is_colliding():
		velocity.y = -JUMP_FORCE

	# jump when void
	if is_on_floor() and wall_check.is_colliding():
		velocity.y = -JUMP_FORCE

	# tp to player if too far away
	if global_position.distance_to(player.global_position) >= 200:
		global_position = Vector2(player.global_position.x - 30, player.global_position.y - 10)
		velocity = Vector2.ZERO

	move_and_slide()


func play_animation(new_state):
	match new_state:
		STATES.IDLE:
			animated_sprite_2d.play("idle")
		STATES.RUN:
			animated_sprite_2d.play("run")


func walk_towards(body: CharacterBody2D, delta):
	direction = global_position.direction_to(body.global_position)
	animated_sprite_2d.flip_h = direction.x < 0

	if direction.x < 0:
		wall_check.scale.x = -1
		floor_check.scale.x = -1
	else:
		wall_check.scale.x = 1
		floor_check.scale.x = 1

	if global_position.distance_to(body.global_position) >= 50:
		state = STATES.RUN
		velocity.x = move_toward(velocity.x, direction.x * speed, delta * 1000)
	else:
		state = STATES.IDLE
		velocity.x = 0


func attack(body: Enemy):
	body.take_damage(damage)
	await get_tree().create_timer(attack_cooldown).timeout


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Enemy:
		while body and attack_range.overlaps_body(body):
			target = body
			await attack(body)
