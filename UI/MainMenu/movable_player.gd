extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogue: Panel = $Dialogue

var SPEED := 50


func _ready() -> void:
	hide_dialogue()


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


func hide_dialogue():
	await get_tree().create_timer(2.0).timeout
	dialogue.queue_free()
