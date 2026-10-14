extends Panel

@onready var resume_button: Button = $FloatingMenu/ResumeButton
@onready var settings_button: Button = $FloatingMenu/SettingsButton
@onready var restart_button: Button = $FloatingMenu/RestartButton
@onready var main_menu_button: Button = $FloatingMenu/MainMenuButton


func _ready() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)


func _on_resume_button_pressed():
	pass


func _on_settings_button_pressed():
	var current_level := get_tree().current_scene.duplicate()
	var settings = preload("uid://bdwa8rq6rnrr2").instantiate()
	settings.return_destination = current_level
	get_tree().change_scene_to_node(settings)


func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed():
	GameManager.go_to_main_menu()
