class_name Fire_Projectile
extends Projectile


func _ready() -> void:
	sprite2d = $Sprite2D
	collision_polygon_2d = $CollisionPolygon2D
	lifespan = 2.5
	super()
