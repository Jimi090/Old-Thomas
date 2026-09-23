extends Node2D

@export var player_start_position := Vector2.ZERO
@onready var player: Player = $Player


func _ready() -> void:
	player.global_position = player_start_position
