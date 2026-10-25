extends Node2D

@onready var key: Key = $Key
@onready var player: Player = $Player
@onready var key_marker_2d: Marker2D = $KeyMarker2D

const COIN = preload("uid://dharn33rhc8ko")
var coin_number: int


func _ready():
	player.player_died.connect(_on_player_death)
	Events.enemy_died.connect(_on_boss_death)

	var path = "Path" + str(name)[-1]
	var level = "level_" + str(len(GameData.level_progress[path])) + ".tscn"

	coin_number = int(path[-1]) * 10
	key.path_name = path
	key.level_name = level


func _on_player_death():
	call_deferred("reload_level")


func reload_level():
	get_tree().call_deferred("reload_current_scene")


func _on_boss_death():
	key.position = key_marker_2d.position
	spawn_coins()


func spawn_coins():
	for i in coin_number:
		var coin: Coin = COIN.instantiate()
		var offset = randi_range(-40, -100)
		coin.global_position = Vector2(
			key_marker_2d.global_position.x + offset,
			key_marker_2d.global_position.y,
		)
		call_deferred("add_child_to_scene", coin)


func add_child_to_scene(child):
	get_tree().current_scene.add_child(child)
