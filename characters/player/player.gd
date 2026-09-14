extends Character

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var basic_attack_range: Area2D = $BasicAttackRange

@export var SPEED := 200
@export var GRAVITY := 1000
@export var JUMP_FORCE := 320

var basic_attack_damage := 10

var direction : float

enum State{
	IDLE,
	RUN,
	BASIC_ATTACK,
	TAKE_DAMAGE
}
var state = State.IDLE

func basic_attack():
	var bodies = basic_attack_range.get_overlapping_bodies()
	for body in bodies:
		body.take_damage(basic_attack_damage)
	state = State.BASIC_ATTACK

func take_damage(damage):
	animated_sprite_2d.play("take_damage")
	super(damage)

func update_animation():
	match state:
		State.IDLE:
			animated_sprite_2d.play("idle")
		State.RUN:
			animated_sprite_2d.play("run")
		State.BASIC_ATTACK:
			animated_sprite_2d.play("basic_attack")
		State.TAKE_DAMAGE:
			animated_sprite_2d.play("take_damage")

func _ready() -> void:
	max_health = 100
	super()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	direction = Input.get_axis("left","right")
	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0
	velocity.x = move_toward(velocity.x,direction*SPEED,delta*1000)

	if state != State.BASIC_ATTACK and state != State.TAKE_DAMAGE:
		if direction != 0:
			state = State.RUN
		else:
			state = State.IDLE

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_FORCE

	if Input.is_action_just_pressed("Basic Attack"):
		basic_attack()

	update_animation()

	move_and_slide()

func _on_animation_finished() -> void:
	if state == State.BASIC_ATTACK or state == State.TAKE_DAMAGE:
		state = State.IDLE
