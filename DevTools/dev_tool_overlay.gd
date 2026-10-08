extends CanvasLayer

@onready var panel: Panel = $Panel
var fly_mode := false


func _ready() -> void:
	panel.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DevTools"):
		panel.visible = !panel.visible
	if fly_mode:
		var player = get_player()
		if player:
			if event.is_action("down"):
				player.position.y += 20
			if event.is_action("jump"):
				player.position.y -= 20


func _on_clear_save_btn_pressed() -> void:
	GameData.clear_save()
	get_tree().change_scene_to_file("res://UI/StartMenu/StartMenu.tscn")


func _on_fly_button_pressed() -> void:
	var player: Player = get_player()
	if player:
		if player.gravity == 0:
			player.gravity = GB.GRAVITY
			player.JUMP_FORCE = GB.player.jump_force
			fly_mode = false
		else:
			player.gravity = 0
			player.JUMP_FORCE = 0
			fly_mode = true


func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")


func _on_infinite_health_button_pressed() -> void:
	var player: Player = get_player()
	if player:
		if player.health > player.MAX_HEALTH:
			player.health = player.MAX_HEALTH
		else:
			player.health = 10000
