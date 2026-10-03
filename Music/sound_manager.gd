extends AudioStreamPlayer

var coinsnd = preload("res://Music/assets/coinsound.mp3")
var deathsnd = preload("res://Music/assets/deathsound.mp3")

func play_coin_sound():
	stream = coinsnd
	play()
	
func play_death_sound(): 
	stream = deathsnd
	volume_db = 10.0
	play()
