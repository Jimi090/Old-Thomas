extends AudioStreamPlayer2D

var music = [
	preload("uid://cadt1voy7vt7y"),
	preload("uid://dplwmhqqji1lu"),
	preload("uid://b876h04xruetu"),
	preload("uid://bflqsw128jmjb"),
]
var current_music := 0


func _ready() -> void:
	play_music()


func play_music():
	stream = music[current_music]
	play()


func _on_finished() -> void:
	current_music += 1
	if current_music >= music.size():
		current_music = 0
	play_music()
