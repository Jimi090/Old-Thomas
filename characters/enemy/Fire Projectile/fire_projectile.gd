class_name Fire_Projectile
extends Area2D

@export var damage := 10
@export var target_position := Vector2(50, 50)
@export var speed := 200
var direction := Vector2.ZERO


func _on_body_entered(body: Player) -> void:
	body.take_damage(damage)
	queue_free()


func _ready() -> void:
	print('a')
	direction = (target_position - global_position).normalized()
	$Sprite2D.rotation = direction.angle() + PI
	await get_tree().create_timer(2.0).timeout
	print('xd')
	queue_free()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
