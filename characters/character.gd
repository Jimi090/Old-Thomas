class_name Character
extends CharacterBody2D

@export var max_health: int

var health: int:
	set(value):
		health = value
		_on_health_changed()

enum State {
	IDLE,
	RUN,
	BASIC_ATTACK,
	TAKE_DAMAGE,
	JUMP,
}
var state = State.IDLE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health


func take_damage(damage: int):
	state = State.TAKE_DAMAGE
	health -= damage
	print(health)

	if health <= 0:
		die()


func update_animation(animated_sprite_2d):
	match state:
		State.IDLE:
			animated_sprite_2d.play("idle")
		State.RUN:
			animated_sprite_2d.play("run")
		State.BASIC_ATTACK:
			animated_sprite_2d.play("basic_attack")
		State.TAKE_DAMAGE:
			animated_sprite_2d.play("take_damage")
		State.JUMP:
			animated_sprite_2d.play("jump")


func is_moving():
	return velocity.x != 0


func die():
	queue_free()


func basic_attack(attack_range, damage):
	state = State.BASIC_ATTACK
	var bodies = attack_range.get_overlapping_bodies()
	for body in bodies:
		body.take_damage(damage)


func _on_health_changed():
	pass
