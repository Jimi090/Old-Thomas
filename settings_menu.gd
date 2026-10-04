extends Control

@onready var volume_slider: HSlider = $Panel/HSlider 
@onready var back_button: Button = $Panel/BackButton

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	volume_slider.value_changed.connect(_on_volume_changed)

func _on_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_back_pressed():
	queue_free()
	
