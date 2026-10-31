class_name Beam_Projectile
extends Area2D

var damage: int
var speed := 200
var lifespan := 2.0

var target_position := Vector2.ZERO
var direction := Vector2.ZERO
var player_hit := false

var sprite2d: Sprite2D
var collision_polygon_2d: Node2D


func _on_body_entered(body: CharacterBody2D) -> void:
	if not player_hit:
		body.take_damage(damage)
		player_hit = true


func _ready() -> void:
	sprite2d = $Sprite2D
	collision_polygon_2d = $CollisionShape2D
	lifespan = 1.0
	body_entered.connect(_on_body_entered)
	direction = (target_position - global_position).normalized()
	rotation = direction.angle() + PI
	await get_tree().create_timer(lifespan).timeout
	queue_free()
