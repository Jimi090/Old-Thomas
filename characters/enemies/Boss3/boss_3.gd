extends Enemy

@export var player: Player

const BEAM_PROJECTILE = preload("uid://b8d8jn6cosfs")

var projectiles: Array[Beam_Projectile] = []

var gravity_on := true
var attack_delay := 0.2

var player_positions: Array[Vector2] = []


func _ready() -> void:
	animated_sprite_2d = $AnimatedSprite2D
	attack_range = $AttackRange
	floor_check = $FloorCheck
	wall_check = $WallCheck
	collision_shape_2d = $CollisionShape2D
	SPEED = GB.boss3.speed
	DAMAGE = GB.boss3.damage
	ATTACK_COOLDOWN = GB.boss3.attack_cooldown
	MAX_HEALTH = GB.boss3.health
	JUMP_FORCE = GB.boss3.jump_force
	save_player_position()
	super()


func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor() and gravity_on:
		velocity.y += GB.GRAVITY * delta

	# turn around
	if not floor_check.is_colliding():
		change_direction_to(direction * -1)

	var bodies = attack_range.get_overlapping_bodies()

	# attack
	if can_attack and not bodies.is_empty():
		attack(attack_range.get_overlapping_bodies()[0])

	# if player not in range
	if bodies.is_empty():
		if global_position.x - player.global_position.x > 0:
			direction = -1
		else:
			direction = 1
		change_direction_to(direction)

		# walk
		velocity.x = direction * SPEED * delta * 100

	for i in range(projectiles.size() - 1, -1, -1):
		var beam = projectiles[i]
		if is_instance_valid(beam):
			beam.global_position = global_position + Vector2(0, -4)
		else:
			projectiles.remove_at(i)

	update_animation(animated_sprite_2d)

	move_and_slide()


func create_projectile(_body: Player):
	var beam: Beam_Projectile = BEAM_PROJECTILE.instantiate()
	beam.global_position = global_position + Vector2(0, -4)
	beam.damage = DAMAGE
	beam.target_position = global_position - player_positions.front()
	beam.scale = Vector2(4, 1)
	get_tree().current_scene.add_child(beam)
	projectiles.append(beam)


func beam_star():
	gravity_on = false
	can_attack = false
	var tween = create_tween()
	var time := 0.3
	var degrees = 20.0
	tween.tween_property(self, "position:y", self.position.y - 40, 0.1)
	tween \
			.tween_property(self, "rotation_degrees", degrees, time) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_IN_OUT)
	tween \
			.tween_property(self, "rotation_degrees", -degrees, time) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_IN_OUT)
	tween \
			.tween_property(self, "rotation_degrees", 0, time / 2) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_IN_OUT)

	await tween.finished

	var vectors: Array[Vector2] = [
		Vector2(1, 0),
		Vector2(1, 1),
		Vector2(0, 1),
		Vector2(-1, 0),
		Vector2(-1, -1),
		Vector2(0, -1),
		Vector2(-1, 1),
		Vector2(1, -1),
	]
	for i in vectors:
		var beam: Beam_Projectile = BEAM_PROJECTILE.instantiate()
		beam.global_position = global_position + Vector2(0, -4)
		beam.damage = DAMAGE
		beam.target_position = global_position + Vector2(0, -4) + i
		beam.scale = Vector2(4, 1)
		get_tree().current_scene.add_child(beam)
		projectiles.append(beam)
	await get_tree().create_timer(1.0).timeout
	gravity_on = true
	can_attack = true


func _on_beam_star_timer_timeout() -> void:
	beam_star()


func save_player_position():
	while true:
		player_positions.append(global_position - player.global_position)

		if player_positions.size() > int(attack_delay / 0.05) + 1:
			player_positions.pop_front()

		await get_tree().create_timer(0.05).timeout
