extends Button
class_name PauseMenuButton

var clicked := false


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed():
	if not clicked:
		get_tree().paused = true
		add_pause_menu()
		clicked = true


func add_pause_menu():
	var Pause_menu := preload("uid://dnndn3g33utwd").instantiate()
	get_tree().root.get_child(-1).add_child(Pause_menu)
