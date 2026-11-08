extends Node2D

@onready var key: Key = $Key
@onready var player: Player = $Player
@onready var key_marker_2d: Marker2D = $KeyMarker2D
@onready var hud: HUD = $HUD
@onready var dog: CharacterBody2D = $Dog

const COIN = preload("uid://dharn33rhc8ko")
var coin_number: int
var bosses_killed = 0


func _ready():
	player.scale = Vector2(4, 4)
	player.MAX_HEALTH *= 2
	player.health = player.MAX_HEALTH
	player.player_died.connect(_on_player_death)
	Events.enemy_died.connect(_on_boss_death)

	coin_number = 50


func _on_player_death():
	call_deferred("reload_level")


func reload_level():
	get_tree().call_deferred("reload_current_scene")


func _on_boss_death():
	spawn_coins()
	bosses_killed += 1
	if bosses_killed == 4:
		key.position = key_marker_2d.position


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
