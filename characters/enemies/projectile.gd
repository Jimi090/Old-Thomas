extends Area2D
class_name Projectile

var damage: int
var speed := 200
var lifespan := 2.0

var target_position := Vector2.ZERO
var direction := Vector2.ZERO

var sprite2d: Sprite2D


func _on_body_entered(body: CharacterBody2D) -> void:
	body.take_damage(damage)
	queue_free()


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	direction = (target_position - global_position).normalized()
	sprite2d.rotation = direction.angle() + PI
	await get_tree().create_timer(lifespan).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
