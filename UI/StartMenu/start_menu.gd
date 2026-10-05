extends Control

@onready var play_btn: Button = $PlayBtn
@onready var settings_btn: Button = $SettingsBtn
@onready var exit_btn: Button = $ExitBtn
@onready var running_enemy: AnimatedSprite2D = $RunningEnemy
var direction := 1

const SETTINGS_SCENE = preload("res://UI/SettingsMenu/SettingsMenu.tscn")


func _ready() -> void:
	play_btn.pressed.connect(new_game)
	exit_btn.pressed.connect(exit_game)
	settings_btn.pressed.connect(_on_settings_button_pressed)


func _process(_delta: float) -> void:
	running_enemy.position.x += 1 * direction
	if running_enemy.position.x > 320 or running_enemy.position.x < 0:
		direction *= -1
		running_enemy.flip_h = direction < 0


func new_game():
	get_tree().change_scene_to_file("res://Cutscenes/cutscene.tscn")


func exit_game():
	GameManager.quit_game()


func _on_settings_button_pressed():
	var settings_instance = SETTINGS_SCENE.instantiate()
	get_tree().current_scene.add_child(settings_instance)
