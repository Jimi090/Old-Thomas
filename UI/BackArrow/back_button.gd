extends Button

enum Destination {
	MENU,
	START,
}
@export var destiantion: Destination


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	match destiantion:
		Destination.MENU:
			GameManager.go_to_main_menu()
		Destination.START:
			GameManager.go_to_start_menu()
