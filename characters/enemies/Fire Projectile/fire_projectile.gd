class_name Fire_Projectile
extends Projectile


func _ready() -> void:
	sprite2d = $Sprite2D
	collision_polygon_2d = $CollisionPolygon2D
	speed = 200
	lifespan = 2.0
	super()
