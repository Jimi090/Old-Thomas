class_name Ghost_Projectile
extends Projectile


func _ready() -> void:
	sprite2d = $Sprite2D
	speed = 160
	lifespan = 1.6
	super()
