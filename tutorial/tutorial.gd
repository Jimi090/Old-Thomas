extends Node2D

@onready var player: Player = $Player
@onready var hud: HUD = $HUD
@onready var mage_2: Enemy = $Mage2


func _ready() -> void:
	player.player_died.connect(_on_player_death)
	player.ability1_used = true
	hud.get_child(0).get_node("Ability1CooldownBar").hide()
	mage_2.health = 1


func _on_player_death():
	call_deferred("reload_level")


func reload_level():
	get_tree().reload_current_scene()
