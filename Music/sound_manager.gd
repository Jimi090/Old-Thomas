extends AudioStreamPlayer

var coinsnd = preload("res://Music/assets/coinsound.mp3")

func play_coin_sound():
	stream = coinsnd
	play()
