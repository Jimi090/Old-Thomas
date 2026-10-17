extends CanvasLayer
class_name PauseMenu

@onready var resume_button: Button = $Panel/Container/ResumeButton
@onready var settings_button: Button = $Panel/Container/SettingsButton
@onready var restart_button: Button = $Panel/Container/RestartButton
@onready var main_menu_button: Button = $Panel/Container/MainMenuButton


func _ready() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)


func _on_resume_button_pressed():
	get_tree().paused = false
	for node in get_parent().get_children():
		if node is HUD:
			node.get_child(0).get_child(-1).clicked = false
	queue_free()


func _on_settings_button_pressed():
	var current_level = get_tree().current_scene.duplicate(1 | 2 | 4)
	var settings = preload("uid://bdwa8rq6rnrr2").instantiate()
	settings.return_destination = current_level
	hide()
	get_tree().paused = false
	get_tree().change_scene_to_node(settings)


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()


func _on_main_menu_button_pressed():
	get_tree().paused = false
	GameManager.go_to_main_menu()
	queue_free()
