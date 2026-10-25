extends CharacterBody2D

const DIALOGUE = preload("uid://djosr1t6fp8tb")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var start_dialogue: Panel = $Dialogue

@onready var current_dialogue: Dialogue = start_dialogue
@onready var current_dialogue_button: Button = null

var SPEED := 50

enum Dialogue_Position {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}
var dialogue_position: Dialogue_Position = Dialogue_Position.TOP_LEFT


func _ready() -> void:
	hide_start_dialogue()


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "jump", "down").normalized()

	if direction == Vector2.ZERO:
		animated_sprite_2d.play("idle")
	else:
		if direction.x > 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("run")

	velocity = direction * SPEED * delta * 100

	if current_dialogue:
		# flip x
		if current_dialogue.global_position.x > 300 or current_dialogue.global_position.x < 20:
			match dialogue_position:
				Dialogue_Position.TOP_LEFT:
					dialogue_position = Dialogue_Position.TOP_RIGHT
				Dialogue_Position.TOP_RIGHT:
					dialogue_position = Dialogue_Position.TOP_LEFT
				Dialogue_Position.BOTTOM_LEFT:
					dialogue_position = Dialogue_Position.BOTTOM_RIGHT
				Dialogue_Position.BOTTOM_RIGHT:
					dialogue_position = Dialogue_Position.BOTTOM_LEFT

		# flip y
		if current_dialogue.global_position.y > 160 or current_dialogue.global_position.y < 20:
			match dialogue_position:
				Dialogue_Position.TOP_LEFT:
					dialogue_position = Dialogue_Position.BOTTOM_LEFT
				Dialogue_Position.TOP_RIGHT:
					dialogue_position = Dialogue_Position.BOTTOM_RIGHT
				Dialogue_Position.BOTTOM_LEFT:
					dialogue_position = Dialogue_Position.TOP_LEFT
				Dialogue_Position.BOTTOM_RIGHT:
					dialogue_position = Dialogue_Position.TOP_RIGHT

		move_dialogue()

	move_and_slide()


func hide_start_dialogue():
	await get_tree().create_timer(2.0).timeout
	if start_dialogue:
		start_dialogue.queue_free()
		current_dialogue = null


func when_in_range_of_button(button):
	var dialogue := DIALOGUE.instantiate()

	var names_dic = {
		"BackBtn": "Start Menu",
		"ShopBtn": "Shop",
		"TownBtn": "Town",
		"HomeBtn": "Home",
		"Path1": "Path 1",
		"Path2": "Path 2",
		"Path3": "Path 3",
		"Path4": "Path 4",
	}

	dialogue.text = 'Click "Enter" to enter ' + names_dic[button.name]
	dialogue.scale = Vector2(0.6, 0.6)
	dialogue.position = Vector2(-37, -25)
	dialogue.z_index = 2

	if current_dialogue:
		current_dialogue.queue_free()
	current_dialogue = dialogue
	current_dialogue_button = button

	add_child(dialogue)
	move_dialogue()


func when_out_range_of_button(_button):
	if current_dialogue_button == _button:
		current_dialogue.queue_free()
		current_dialogue = null
		current_dialogue_button = null


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter") and current_dialogue_button:
		current_dialogue_button.pressed.emit()


func move_dialogue():
	if current_dialogue == null:
		return

	match dialogue_position:
		Dialogue_Position.TOP_LEFT:
			current_dialogue.change_sharp_corner_to(CORNER_BOTTOM_RIGHT)
			current_dialogue.position = Vector2(-38, -25)
		Dialogue_Position.TOP_RIGHT:
			current_dialogue.change_sharp_corner_to(CORNER_BOTTOM_LEFT)
			current_dialogue.position = Vector2(10, -25)
		Dialogue_Position.BOTTOM_LEFT:
			current_dialogue.change_sharp_corner_to(CORNER_TOP_RIGHT)
			current_dialogue.position = Vector2(-38, 12)
		Dialogue_Position.BOTTOM_RIGHT:
			current_dialogue.change_sharp_corner_to(CORNER_TOP_LEFT)
			current_dialogue.position = Vector2(9, 12)
