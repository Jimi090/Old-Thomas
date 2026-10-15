extends Control

@onready var back_button: Button = $BackButton
@onready var h_slider_gv: HSlider = $SettingsContainer/Audio/Sliders/HSliderGV
@onready var h_slider_mv: HSlider = $SettingsContainer/Audio/Sliders/HSliderMV
@onready var h_slider_sfx: HSlider = $SettingsContainer/Audio/Sliders/HSliderSFX
@onready var fs_button: CheckButton = $SettingsContainer/Graphics/FsButton
@onready var clear_save_button: Button = $SettingsContainer/Buttons/ClearSaveButton

var return_destination = null


func _ready():
	h_slider_gv.value_changed.connect(_on_general_volume_changed)
	h_slider_mv.value_changed.connect(_on_music_volume_changed)
	h_slider_sfx.value_changed.connect(_on_sfx_volume_changed)
	h_slider_gv.value = GameData["game_settings"]["Audio"]["GeneralVolume"]
	h_slider_mv.value = GameData["game_settings"]["Audio"]["MusicVolume"]
	h_slider_sfx.value = GameData["game_settings"]["Audio"]["SFXVolume"]

	fs_button.toggled.connect(_on_fs_button_toggled)
	fs_button.button_pressed = GameData.game_settings["Fullscreen"]

	clear_save_button.pressed.connect(_on_clear_save_button_pressed)

	if is_instance_valid(return_destination):
		back_button.pressed.disconnect(back_button._on_pressed)
		back_button.pressed.connect(change_scene_to_destination)


func change_scene_to_destination():
	get_tree().paused = true
	return_destination.get_child(-1).show()
	get_tree().paused = false
	get_tree().change_scene_to_node(return_destination)


func _on_general_volume_changed(value: float):
	change_bus_volume_to("Master", value)


func _on_music_volume_changed(value: float):
	change_bus_volume_to("Music", value)


func _on_sfx_volume_changed(value: float):
	change_bus_volume_to("SFX", value)


func change_bus_volume_to(bus: String, value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(value / 100.0))
	match bus:
		"Master":
			GameData.game_settings["Audio"]["GeneralVolume"] = value
		"Music":
			GameData.game_settings["Audio"]["MusicVolume"] = value
		"SFX":
			GameData.game_settings["Audio"]["SFXVolume"] = value
	GameData.save_data()


func _on_fs_button_toggled(toggled_on: bool):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	GameData.game_settings["Fullscreen"] = toggled_on
	GameData.save_data()


func _on_clear_save_button_pressed():
	GameData.clear_save()
	get_tree().change_scene_to_file("uid://cidsvy4wrqrsh")
