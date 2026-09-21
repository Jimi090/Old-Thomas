extends CanvasLayer

@onready var panel: Panel = $Panel


func _ready() -> void:
	panel.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DevTools"):
		panel.visible = !panel.visible


func _on_clear_save_btn_pressed() -> void:
	GameData.clear_save()
	get_tree().change_scene_to_file("res://UI/StartMenu/StartMenu.tscn")


func _on_check_button_pressed() -> void:
	var player: Player = get_player()
	if player:
		if player.GRAVITY == 0:
			player.GRAVITY = 1000
			player.JUMP_FORCE = 320
		else:
			player.GRAVITY = 0
			player.JUMP_FORCE = 30


func get_player():
	return get_tree().get_first_node_in_group("player")


func _on_infinite_health_button_pressed() -> void:
	var player: Player = get_player()
	if player:
		if player.health > player.max_health:
			player.health = player.max_health
		else:
			player.health = 10000
