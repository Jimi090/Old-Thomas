extends Node


func go_to_main_menu():
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")


func go_to_start_menu():
	get_tree().change_scene_to_file("res://UI/StartMenu/StartMenu.tscn")


func quit_game():
	get_tree().quit()
