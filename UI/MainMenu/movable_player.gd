extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var start_dialogue: Panel = $Dialogue

var SPEED := 50

const DIALOGUE = preload("uid://djosr1t6fp8tb")

@onready var current_dialogue: Dialogue = start_dialogue


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
	move_and_slide()


func hide_start_dialogue():
	await get_tree().create_timer(2.0).timeout
	if start_dialogue:
		start_dialogue.queue_free()
	current_dialogue = null


func when_in_range_of_button(button):
	var dialogue := DIALOGUE.instantiate()
	dialogue.text = 'Click "Enter" to enter' + button.name
	dialogue.scale = Vector2(0.6, 0.6)
	dialogue.position = Vector2(-37, -25)
	dialogue.z_index = 2

	if current_dialogue:
		current_dialogue.queue_free()
	current_dialogue = dialogue

	add_child(dialogue)


func when_out_range_of_button(_button):
	print(current_dialogue)
	if current_dialogue:
		current_dialogue.queue_free()
		current_dialogue = null
