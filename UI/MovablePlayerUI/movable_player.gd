extends CharacterBody2D

const DIALOGUE = preload("uid://djosr1t6fp8tb")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var start_dialogue: Dialogue = $Dialogue
@export var start_dialogue_text: String

@onready var current_dialogue: Dialogue = start_dialogue
@onready var current_dialogue_button: Button = null
@onready var dialogue_position_marker: Marker2D = $DialoguePositionMarker

enum Type {
	MAIN_MENU,
	NORMAL_UI,
}
@export var type: Type = Type.NORMAL_UI

var SPEED := 100

enum Dialogue_Position {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}
var dialogue_position: Dialogue_Position = Dialogue_Position.TOP_LEFT


func _ready() -> void:
	if start_dialogue_text:
		start_dialogue.text = start_dialogue_text
	else:
		start_dialogue.queue_free()
	if type == Type.NORMAL_UI:
		scale = Vector2(0.5, 0.5)
		dialogue_position_marker.scale = Vector2.ONE
		start_dialogue.scale = Vector2(1.5, 1.5)

		start_dialogue.position = dialogue_position_marker.position - (
			(start_dialogue.size + Vector2(0, 25)) * start_dialogue.scale
		)

		SPEED = 200
	await hide_start_dialogue()


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

	velocity.x = move_toward(velocity.x, direction.x * SPEED, delta * 1000)
	velocity.y = move_toward(velocity.y, direction.y * SPEED, delta * 1000)

	var offset = 8
	position.x = min(320 - offset, position.x)
	position.x = max(offset, position.x)
	position.y = min(180 - offset, position.y)
	position.y = max(offset, position.y)

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
	await get_tree().create_timer(5.0).timeout
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
	if event.is_action_pressed("Enter"):
		if type == Type.MAIN_MENU:
			if current_dialogue_button:
				current_dialogue_button.pressed.emit()
		elif type == Type.NORMAL_UI:
			var pos = get_global_transform_with_canvas() * Vector2.ZERO
			check_for_buttons(get_tree().current_scene, pos)


func check_for_buttons(node: Node, pos: Vector2):
	var children = node.get_children()
	if len(children) == 0:
		return
	for node2 in children:
		if (
			(node2 is Button or node2 is Shop_item) and node2.visible
			and node2.get_global_rect().has_point(pos)
		):
			if node2 is Shop_item:
				node2.get_child(0).pressed.emit()
			else:
				node2.pressed.emit()
			return
		else:
			check_for_buttons(node2, pos)
	return


func move_dialogue():
	if current_dialogue == null:
		return

	var scaler: Vector2

	match dialogue_position:
		Dialogue_Position.TOP_LEFT:
			current_dialogue.change_sharp_corner_to(CORNER_BOTTOM_RIGHT)
			dialogue_position_marker.position = Vector2(-9, -10)
			scaler = Vector2(0, 0)
		Dialogue_Position.TOP_RIGHT:
			current_dialogue.change_sharp_corner_to(CORNER_BOTTOM_LEFT)
			dialogue_position_marker.position = Vector2(9, -10)
			scaler = Vector2(1, 0)
		Dialogue_Position.BOTTOM_LEFT:
			current_dialogue.change_sharp_corner_to(CORNER_TOP_RIGHT)
			dialogue_position_marker.position = Vector2(-9, 10)
			scaler = Vector2(0, 1)
		Dialogue_Position.BOTTOM_RIGHT:
			current_dialogue.change_sharp_corner_to(CORNER_TOP_LEFT)
			dialogue_position_marker.position = Vector2(9, 10)
			scaler = Vector2(1, 1)

	current_dialogue.position = dialogue_position_marker.position - (
		current_dialogue.size * current_dialogue.scale
	) + scaler * current_dialogue.size * current_dialogue.scale
