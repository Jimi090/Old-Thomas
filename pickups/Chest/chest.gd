class_name Chest
extends Area2D

const COIN = preload("uid://dharn33rhc8ko")
const coin_number = 5
@export var chest_number: int
@export var path: String
@export var level: String
@export var opened = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_entered(_body: Node2D) -> void:
	if not opened:
		opened = true
		GameData.level_progress[path][level]["chestsCollected"].append(chest_number)

		animated_sprite_2d.play("open")
		await get_tree().create_timer(0.7).timeout

		spawn_coins()


func spawn_coins():
	for i in coin_number:
		var coin: Coin = COIN.instantiate()
		var offset = randi_range(-20, 20)
		coin.global_position = Vector2(global_position.x + offset, global_position.y)
		get_tree().current_scene.add_child(coin)
