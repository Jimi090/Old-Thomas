extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_range: Area2D = $AttackRange

# Optional raycasts if you have them in your scene tree
@onready var wall_check: RayCast2D = $WallCheck if has_node("WallCheck") else null
@onready var floor_check: RayCast2D = $FloorCheck if has_node("FloorCheck") else null

@export var speed: float = 80.0
@export var max_health: int = 40
var health: int

var direction := 1
const PROJECTILE = preload("uid://cymdi8bpgwy1w") 
var damage := 10
var attack_cooldown := 1.2
var player_target: Node2D = null

var shoot_timer: Timer

func _ready() -> void:
	health = max_health
	animated_sprite_2d.play("run")
	add_to_group("Enemy")
	
	shoot_timer = Timer.new()
	shoot_timer.wait_time = attack_cooldown
	shoot_timer.autostart = false
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shoot_timer)
	
	# Connect attack range signals
	if attack_range:
		attack_range.body_entered.connect(_on_attack_range_body_entered)
		attack_range.body_exited.connect(_on_attack_range_body_exited)

func _physics_process(delta: float) -> void:
	# Continuous movement
	velocity.x = direction * speed
	velocity.y = 0
	
	var hit_wall = is_on_wall() or (wall_check and wall_check.is_colliding())
	var reached_edge = (floor_check and not floor_check.is_colliding())
	
	if hit_wall or reached_edge:
		direction *= -1
		if wall_check:
			wall_check.target_position.x *= -1
		if floor_check:
			floor_check.target_position.x *= -1
			
	animated_sprite_2d.flip_h = direction < 0
	move_and_slide()
	
	if player_target and is_instance_valid(player_target):
		if player_target.global_position.x > global_position.x:
			direction = 1
		else:
			direction = -1

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.has_method("take_damage"):
		player_target = body
		shoot_timer.start()

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body == player_target:
		player_target = null
		shoot_timer.stop()

func _on_shoot_timer_timeout() -> void:
	if player_target and is_instance_valid(player_target):
		var fire = PROJECTILE.instantiate()
		fire.global_position = global_position
		fire.damage = damage
		fire.target_position = player_target.global_position
		fire.speed = 250
		get_tree().current_scene.add_child(fire)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	queue_free()
