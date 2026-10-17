extends Node2D

@onready var key: Key = $Key
@onready var player: Player = $Player
@onready var key_marker_2d: Marker2D = $KeyMarker2D


func _ready():
	player.player_died.connect(_on_player_death)
	Events.enemy_died.connect(_on_boss_death)

	var path = "Path" + str(name)[-1]
	var level = "level_" + str(len(GameData.level_progress[path])) + ".tscn"

	key.path_name = path
	key.level_name = level


func _on_player_death():
	call_deferred("reload_level")


func reload_level():
	get_tree().reload_current_scene()


func _on_boss_death():
	key.position = key_marker_2d.position
