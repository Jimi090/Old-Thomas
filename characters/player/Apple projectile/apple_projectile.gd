class_name Apple_Projectile
extends Projectile


func _ready() -> void:
	sprite2d = $Sprite2D
	collision_polygon_2d = $CollisionPolygon2D
	speed = 250
	lifespan = 1.0
	super()


func _physics_process(delta: float) -> void:
	rotate(0.2)
	super(delta)
