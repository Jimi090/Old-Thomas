extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_range: Area2D = $AttackRange

@export var speed: float = 80.0
@export var max_health: int = 30
var health: int

var direction := 1

const PROJECTILE = preload("uid://cymdi8bpgwy1w") 
var damage := 10
var attack_cooldown := 1.2
var is_attacking := false

func _ready() -> void:
	health = max_health
	animated_sprite_2d.play("run")
	
	if attack_range:
		attack_range.body_entered.connect(_on_attack_range_body_entered)

func _physics_process(delta: float) -> void:
	if not is_attacking:
		velocity.x = direction * speed
		velocity.y = 0
		
		if is_on_wall():
			direction *= -1
			
		animated_sprite_2d.flip_h = direction < 0
		
	move_and_slide()

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.has_method("take_damage"):
		is_attacking = true
		
		while attack_range.overlaps_body(body) and is_instance_valid(body) and health > 0:
			if body.global_position.x > global_position.x:
				direction = 1
			else:
				direction = -1
			animated_sprite_2d.flip_h = direction < 0
			
			call_deferred("fire_attack", body)
			await get_tree().create_timer(attack_cooldown).timeout
			
		is_attacking = false

func fire_attack(body: Node2D):
	if health <= 0: return
	var fire = PROJECTILE.instantiate()
	fire.global_position = global_position
	fire.damage = damage
	fire.target_position = body.global_position
	fire.speed = 250
	get_tree().current_scene.add_child(fire)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	queue_free()
