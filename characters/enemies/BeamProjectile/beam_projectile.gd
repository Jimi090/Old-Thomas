class_name Beam_Projectile
extends Projectile


func _ready() -> void:
	sprite2d = $Sprite2D
	collision_polygon_2d = $CollisionShape2D
	speed = 0
	lifespan = 1.0
	super()
