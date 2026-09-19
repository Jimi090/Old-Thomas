extends Area2D

enum TypePotion { HEALTH, ATTACK, SPEED }
@export var potion_type: TypePotion

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		apply_affect(body)
		queue_free()
		
func apply_affect(player: Node2D) -> void:
	match potion_type:
		TypePotion.HEALTH:
			player.heal(25)
		TypePotion.ATTACK:
			player.boost_attack(1.5)
		TypePotion.SPEED:
			player.boost_speed(1.5)
