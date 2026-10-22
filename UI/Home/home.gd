extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var player_animated_sprite_2d: AnimatedSprite2D = $PlayerAnimatedSprite2D
@onready var dog_animated_sprite_2d: AnimatedSprite2D = $DogAnimatedSprite2D
@onready var friend_animated_sprite_2d: AnimatedSprite2D = $FriendAnimatedSprite2D
@onready var flying_friend_sprite_2d: Sprite2D = $FlyingFriendSprite2D
@onready var chest_container: Control = $ChestContainer

var patrol_distance := 100
var PATROL_SPEED = 150
var point1: float
var point2: float
var direction := 1
var progress_decimal: float


func _ready() -> void:
	update_progress_bar()
	random_dog_flips()
	friends_entrance()
	show_chests()

	point1 = player_animated_sprite_2d.position.x - patrol_distance
	point2 = player_animated_sprite_2d.position.x + patrol_distance

	friend_animated_sprite_2d.hide()


func _process(delta: float) -> void:
	if dog_animated_sprite_2d.position.x < point1 or dog_animated_sprite_2d.position.x > point2:
		direction *= -1
		dog_animated_sprite_2d.flip_h = direction < 0
	if player_animated_sprite_2d.position.x >= dog_animated_sprite_2d.position.x:
		player_animated_sprite_2d.flip_h = true
		friend_animated_sprite_2d.flip_h = true
	else:
		player_animated_sprite_2d.flip_h = false
		friend_animated_sprite_2d.flip_h = false

	dog_animated_sprite_2d.position.x += direction * PATROL_SPEED * delta


func update_progress_bar():
	var all_levels := 0
	var completed_levels := 0
	for path in GameData.level_progress:
		for level in GameData.level_progress[path]:
			all_levels += 1
			if GameData.level_progress[path][level]["finished"]:
				completed_levels += 1

	progress_bar.max_value = all_levels
	progress_bar.value = completed_levels
	progress_decimal = float(completed_levels) / float(all_levels)


func random_dog_flips():
	while true:
		await get_tree().create_timer(randf_range(3.0, 6.0)).timeout
		dog_flip()


func dog_flip():
	var JUMP_HEIGHT := 50
	var JUMP_LENGTH := 0.5
	var tween = create_tween()
	tween.set_parallel(true)
	tween \
			.tween_property(dog_animated_sprite_2d, "position:y", dog_animated_sprite_2d.position.y
	- JUMP_HEIGHT, JUMP_LENGTH) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		dog_animated_sprite_2d,
		"rotation",
		dog_animated_sprite_2d.rotation + 2 * PI,
		JUMP_LENGTH,
	)
	tween.set_parallel(false)
	tween \
			.tween_property(dog_animated_sprite_2d, "position:y", dog_animated_sprite_2d.position.y, JUMP_LENGTH) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_OUT)


func friends_entrance():
	var tween = create_tween()
	var duration := 3.0
	tween.tween_property(
		flying_friend_sprite_2d,
		"position",
		friend_animated_sprite_2d.position,
		duration,
	)
	await tween.finished
	flying_friend_sprite_2d.hide()
	friend_animated_sprite_2d.show()


func show_chests():
	var total := chest_container.get_child_count()
	var counter := 1
	var children = chest_container.get_children()
	children.reverse()
	for chest in children:
		if 100.0 / float(total) * counter > progress_decimal * 100:
			chest.hide()
		counter += 1
