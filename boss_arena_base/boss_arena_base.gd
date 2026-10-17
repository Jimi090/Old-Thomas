extends Node2D

@onready var key: Key = $Key
@onready var player: Player = $Player


func _ready():
	player.player_died.connect(_on_player_death)


func _on_player_death():
	call_deferred("reload_level")


func reload_level():
	get_tree().reload_current_scene()
