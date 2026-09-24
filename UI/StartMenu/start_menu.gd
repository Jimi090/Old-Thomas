extends Control

@onready var play_btn: Button = $PlayBtn
@onready var settings_btn: Button = $SettingsBtn
@onready var exit_btn: Button = $ExitBtn


func _ready() -> void:
	play_btn.pressed.connect(new_game)
	exit_btn.pressed.connect(exit_game)


func new_game():
	get_tree().change_scene_to_file("res://Cutscenes/cutscene.tscn")


func exit_game():
	GameManager.quit_game()
