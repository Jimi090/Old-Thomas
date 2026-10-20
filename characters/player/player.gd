class_name Player
extends Character

signal health_changed(new_health)
signal player_died

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var basic_attack_range: Area2D = $BasicAttackRange
@onready var basic_attack_cooldown_timer: Timer = $BasicAttackCooldown
@onready var range_attack_cooldown_timer: Timer = $RangeAttackCooldown

const APPLE_PROJECTILE = preload("uid://cvyftohgcpsl0")

var SPEED := GB.player.speed
var basic_attack_damage := GB.player.damage
var basic_attack_cooldown := GB.player.attack_cooldown
var ranged_attack_damage := 20
var ranged_attack_cooldown = 6.0
var JUMP_FORCE := GB.player.jump_force

var attack_multi := 1.0
var speed_multi := 1.0
var direction: float
var gravity := GB.GRAVITY

var can_range_attack := true
var can_basic_attack := true


func _ready() -> void:
	var health_multiplayer = GameData.upgrades["Health_upgrade"]["level"]
	MAX_HEALTH = GB.player.health + health_multiplayer * GB.player.health / 10

	var damage_multiplayer = GameData.upgrades["Attack_upgrade"]["level"]
	basic_attack_damage += damage_multiplayer * GB.player.damage / 10

	var speed_multiplayer = GameData.upgrades["Speed_upgrade"]["level"]
	SPEED += speed_multiplayer * GB.player.speed / 10

	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

	range_attack_cooldown_timer.wait_time = ranged_attack_cooldown
	range_attack_cooldown_timer.start()

	basic_attack_cooldown_timer.wait_time = basic_attack_cooldown
	basic_attack_cooldown_timer.start()

	add_to_group("player")
	super()


func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# walking
	direction = Input.get_axis("left", "right")

	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0
		if direction < 0:
			basic_attack_range.rotation = PI
		else:
			basic_attack_range.rotation = 0
	velocity.x = move_toward(velocity.x, direction * SPEED, delta * 1000)

	# animations
	if state != State.BASIC_ATTACK and state != State.TAKE_DAMAGE and state != State.JUMP:
		if direction != 0:
			state = State.RUN
		else:
			state = State.IDLE
	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_FORCE
		state = State.JUMP

	# die when out of map
	if position.y > 300:
		take_damage(10)

	update_animation(animated_sprite_2d)

	move_and_slide()


func basic_attack(attack_range, damage):
	state = State.BASIC_ATTACK
	var bodies = attack_range.get_overlapping_bodies()
	for body in bodies:
		body.take_damage(damage)


func ranged_attack():
	var apple := APPLE_PROJECTILE.instantiate()

	apple.global_position = global_position
	apple.damage = ranged_attack_damage
	if direction != 0:
		apple.target_position = global_position + Vector2(direction, 0)
	else:
		if animated_sprite_2d.flip_h:
			apple.target_position = global_position + Vector2(-1, 0)
		else:
			apple.target_position = global_position + Vector2(1, 0)
	apple.speed = 300

	get_tree().current_scene.add_child(apple)


func _on_health_changed():
	health_changed.emit(health)


func heal(amount: int) -> void:
	health = min(MAX_HEALTH, health + amount)
	health_changed.emit(health)


func die():
	# chance of revival
	var random = randi_range(1, 100)
	var chance = 2 * int(GameData.upgrades["Revival_upgrade"]["level"])
	SoundManager.play_death_sound()
	if random <= chance:
		health = MAX_HEALTH
		position.y -= 100
	else:
		player_died.emit()


func boost_attack(multiplier: float) -> void:
	basic_attack_damage = int(basic_attack_damage * multiplier)


func boost_speed(multiplier: float) -> void:
	SPEED = int(SPEED * multiplier)


func _input(event: InputEvent) -> void:
	# basic attack
	if event.is_action_pressed("Basic Attack"):
		if can_basic_attack:
			basic_attack(basic_attack_range, basic_attack_damage)
			basic_attack_cooldown_timer.wait_time = basic_attack_cooldown
			can_basic_attack = false
			$"../HUD/UI/BasicAttackCooldownBar/".restart()

	# ranged attack
	if event.is_action_pressed("Ranged Attack"):
		if can_range_attack:
			ranged_attack()
			range_attack_cooldown_timer.wait_time = ranged_attack_cooldown
			can_range_attack = false
			$"../HUD/UI/RangeAttackCooldownBar/".restart()


func _on_range_attack_cooldown_timeout() -> void:
	can_range_attack = true


func _on_basic_attack_cooldown_timeout() -> void:
	can_basic_attack = true
