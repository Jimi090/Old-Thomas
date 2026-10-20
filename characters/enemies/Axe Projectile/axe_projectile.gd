class_name Axe_Projectile
extends Projectile


func _ready() -> void:
	sprite2d = $Sprite2D
	collision_polygon_2d = $CollisionPolygon2D
	speed = 200
	lifespan = 4.0
	super()


func _physics_process(delta: float) -> void:
	rotate(0.2)
	super(delta)
