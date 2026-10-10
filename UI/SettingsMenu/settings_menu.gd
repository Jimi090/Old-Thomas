extends Control

@onready var h_slider_gv: HSlider = $SettingsContainer/Audio/Sliders/HSliderGV
@onready var h_slider_mv: HSlider = $SettingsContainer/Audio/Sliders/HSliderMV
@onready var h_slider_sfx: HSlider = $SettingsContainer/Audio/Sliders/HSliderSFX


func _ready():
	h_slider_gv.value_changed.connect(_on_general_volume_changed)
	h_slider_mv.value_changed.connect(_on_music_volume_changed)
	h_slider_sfx.value_changed.connect(_on_sfx_volume_changed)
	h_slider_gv.value = GameData["game_settings"]["Audio"]["GeneralVolume"]
	h_slider_mv.value = GameData["game_settings"]["Audio"]["MusicVolume"]
	h_slider_sfx.value = GameData["game_settings"]["Audio"]["SFXVolume"]


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
