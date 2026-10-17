extends Node2D

@onready var hud: HUD = $"../HUD"
@onready var level_base: Node2D = $".."


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESC"):
		var menu_exists := false
		for node in level_base.get_children():
			if node is PauseMenu:
				menu_exists = true
				node._on_resume_button_pressed()
		if not menu_exists:
			hud.get_child(0).get_child(-1)._on_pressed()
